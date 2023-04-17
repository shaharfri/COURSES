// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	WhiteBall_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  						// short pulse every start of frame 30Hz 
					input	logic	left_button_rise,  					// high pulse for 1 clk when each button press
					input	logic	up_button_rise, 						
					input	logic	right_button_rise, 					
					input	logic	down_button_rise, 					
					input	logic	enter_button_rise, 	 				
					input logic collision,  							// high when any ball hit any object
					input logic collision_White_Red, 				// high when white ball and red ball is hitting each other 
					input logic collision_White_Black,				// high when white ball is getting inside any black hole
					input logic collision_White_Border, 			// high when white ball is hitting the border of the table
					input logic collision_Red_Black,					// high when red ball is getting inside any black hole
					input	logic	[3:0] HitEdgeCode, 					// one bit per edge 
					input logic signed [10:0] red_x_speed,			// inputs of red ball current speed and location in both axis
					input logic signed [10:0] red_y_speed,
					input logic signed [10:0] red_x_loc,
					input logic signed [10:0] red_y_loc,
					input logic singleHitPulse,						// high for 1 clk after occure any collision
					input logic signed [10:0] new_white_x_loc,	// inputs of new location of the white ball
					input logic signed [10:0] new_white_y_loc,
					input logic turn_over,								// high when every turn over


					output	 logic signed 	[10:0]	topLeftX, 	// output the top left corner 
					output	 logic signed	[10:0]	topLeftY,  	// can be negative , if the object is partliy outside 
					output logic signed [10:0] white_x_speed, 	// outputs of the new speed of the white ball
					output logic signed [10:0] white_y_speed,
					output logic white_ball_stopped,					// indicates if the white ball stopped
					output logic white_started							// indicates if the white ball started
);		


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 40;
parameter int INITIAL_Y_SPEED = 20;
parameter int MAX_Y_SPEED = 230;
const int  Y_ACCEL = 2;
const int  X_ACCEL = 2;
const int  add_speed = 100;

const int	FIXED_POINT_MULTIPLIER	=	128;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;

int topLeftX_FixedPoint;
int topLeftY_FixedPoint;
logic signed [10:0] Xspeed;
logic signed [10:0] Yspeed;
logic signed [10:0] counterUp;										// counters for the keyboard    
logic signed [10:0] counterDown;
logic signed [10:0] counterLeft;
logic signed [10:0] counterRight;
int flagX;																	// make sure enter once in a row (and not more) for each condition
int flagY;
int first_hitX;															// make sure every turn includes two hits
int first_hitY;
int red_Ball_stopped;

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation 0f Y Axis speed using gravity or colision

always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN) begin 
		first_hitY <= 0;
		white_started <= 0;
		flagY <= 0;
		counterUp <= 9'b0;
		counterDown <= 9'b0;
		Yspeed	<= INITIAL_Y_SPEED;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end 
	else begin 
			
		//hit bit map has one bit per edge:  Left-Top-Right-Bottom	
	

		if (collision_White_Border && (HitEdgeCode[0]) )     // hitting the top and the bottom (0 and 2)
			if (Yspeed > 0)
				Yspeed <= -Yspeed;
				
				
		if (collision_White_Border && (HitEdgeCode[2]))
			if (Yspeed < 0)
				Yspeed <= -Yspeed;
			

		
		if (collision_White_Red && (flagY ==0))  begin		// hitting the red ball	
			Yspeed <= red_y_speed;
			flagY <= 1;
			end
		
		if ((flagY == 1) && (collision_White_Red == 0))		// only once ^
			flagY <= 0;
		
			
		if (turn_over) begin											// the turn is over
			white_started <= 0;
			Yspeed <= 0;
			topLeftY_FixedPoint <= new_white_y_loc*FIXED_POINT_MULTIPLIER;
			first_hitY <= 0;
		end
			
		
	if (up_button_rise && (counterUp < 720) && (white_ball_stopped==1) && (red_ball_stopped==1))      			// inputs from the keyboard and the limit of each keypad
			counterUp <= counterUp + 80;
			
	if (down_button_rise&& (counterDown < 720) && (white_ball_stopped==1) && (red_ball_stopped==1)) 
			counterDown <= counterDown + 80;

	if ((enter_button_rise) && (first_hitY==0) && (white_ball_stopped==1) && (red_ball_stopped==1)) begin		// first hit
		Yspeed <= counterUp- counterDown;
		counterDown <= 0;
		counterUp<=0;
		first_hitY <= 1;
		end
		
	if ((enter_button_rise) && (first_hitY==1) && (white_ball_stopped==1) && (red_ball_stopped==1)) begin		// second hit
		Yspeed <= counterUp- counterDown;
		counterDown <= 0;
		counterUp<=0;
		first_hitY <= 0;
		white_started <= 1;
		end
	
		if (startOfFrame == 1'b1) begin 
		
				topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; // position interpolation 
				if (Yspeed > 0)
					Yspeed <= Yspeed - Y_ACCEL;					//accleration impact
				if (Yspeed < 0)
					Yspeed <= Yspeed + Y_ACCEL;
		end
	
	
	
	end
end 

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of X Axis speed using and position calculate regarding X_direction key or colision

always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN) begin
		flagX <= 0;
		first_hitX <= 0;
		counterLeft <= 9'b0;
		counterRight <= 9'b0;
		Xspeed	<= INITIAL_X_SPEED;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
	else begin
	
	
	if (collision_White_Border && (HitEdgeCode[1]))				// hitting the right and the left (1 and 3)
		if(Xspeed>0)
			Xspeed <= -Xspeed;
			
			
	if (collision_White_Border && (HitEdgeCode[3]))
		if(Xspeed<0)
			Xspeed <= -Xspeed;
	
	
	if (collision_White_Red && (flagX == 0)) begin				// hitting the red ball
			Xspeed <= red_x_speed;
			flagX <= 1;
	end
		
	if ((flagX == 1) && (collision_White_Red == 0))				// only once ^
		flagX <= 0;
		
			
	if (turn_over) begin													// the turn is over
			Xspeed <= 0;
			topLeftX_FixedPoint <= new_white_x_loc*FIXED_POINT_MULTIPLIER;
			first_hitX <= 0;
	end
		
		
	if (right_button_rise&&(counterRight < 720) && (white_ball_stopped==1) && (red_ball_stopped==1)) 				// inputs from the keyboard and the limit of each keypad
			counterRight <= counterRight + 80;

			
	if (left_button_rise&&(counterLeft < 720) && (white_ball_stopped==1) && (red_ball_stopped==1)) 
			counterLeft <= counterLeft + 80;

			
	if ((enter_button_rise) && (first_hitX==0) && (white_ball_stopped==1) && (red_ball_stopped==1)) begin			// first hit
		Xspeed <= counterLeft - counterRight;
		counterRight <= 0;
		counterLeft<=0;
		first_hitX <= 1;
		end
		
	if ((enter_button_rise) && (first_hitX==1) && (white_ball_stopped==1) && (red_ball_stopped==1)) begin			// second hit
		Xspeed <= counterLeft - counterRight;
		counterRight <= 0;
		counterLeft<=0;
		first_hitX <= 0;
		end
	
	if (startOfFrame == 1'b1 ) begin
		topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;	// position interpolation 
		
		if (Xspeed > 0)
				Xspeed <= Xspeed - X_ACCEL;  							//accleration impact
		if (Xspeed < 0)
				Xspeed <= Xspeed + X_ACCEL;
		end			
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;   
assign white_x_speed = Xspeed;
assign white_y_speed = Yspeed;
assign white_ball_stopped = ((Xspeed == 0) && (Yspeed == 0)) ? 1 : 0;
assign red_ball_stopped = ((red_x_speed == 0) && (red_y_speed == 0)) ? 1 : 0;
endmodule
