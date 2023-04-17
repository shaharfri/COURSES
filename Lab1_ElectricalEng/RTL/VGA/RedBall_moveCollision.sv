// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	RedBall_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  									// short pulse every start of frame 30Hz 	 
					input logic collision,  										// collision if smiley hits an object
					input logic collision_Red_White,								// high when white ball and red ball is hitting each other
					input logic collision_Red_Black,								// high when red ball is getting inside any black hole
					input logic collision_Red_Border,							// high when red ball is hitting borders
					input logic collision_White_Black,							// high when white ball is getting inside any black hole
					input	logic	[3:0] HitEdgeCode, 								//one bit per edge 
					input logic signed [10:0] white_x_speed,					// inputs of white ball current speed and location in both axis
					input logic signed [10:0] white_y_speed,
					input logic signed [10:0] white_x_loc,
					input logic signed [10:0] white_y_loc,
					input logic singleHitPulse,									// high for 1 clk after occure any collision
					input logic signed [10:0] new_red_x_loc,					// inputs of new speed and location of the white ball
					input logic signed [10:0] new_red_y_loc,
					input logic turn_over, 

					output	 logic signed 	[10:0]	topLeftX, 				// output the top left corner 
					output	 logic signed	[10:0]	topLeftY,  				// can be negative , if the object is partliy outside 
					output logic signed [10:0] red_x_speed, 					// outputs of the new speed of the white ball
					output logic signed [10:0] red_y_speed,
					output logic red_ball_stopped									// indicates if the red ball stopped

					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 40;
parameter int INITIAL_Y_SPEED = 20;
parameter int MAX_Y_SPEED = 230;
const int  Y_ACCEL = 2;
const int  X_ACCEL = 2;

const int	FIXED_POINT_MULTIPLIER	=	128;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;

int topLeftX_FixedPoint; 															// local parameters 
int topLeftY_FixedPoint;
logic signed [10:0] Xspeed;
logic signed [10:0] Yspeed;

int flagX;																				// make sure enter once in a row (and not more) for each condition
int flagY;


//////////--------------------------------------------------------------------------------------------------------------=
//  calculation 0f Y Axis speed using gravity or colision

always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN) begin 
		flagY= 0;
		Yspeed	<= INITIAL_Y_SPEED;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end 
	else begin
	
		//hit bit map has one bit per edge:  Left-Top-Right-Bottom	 
		
			
		if (collision_Red_Border && (HitEdgeCode[0]) )						// hitting the top and the bottom (0 and 2)
			if (Yspeed > 0)
				Yspeed <= -Yspeed;
				
		if (collision_Red_Border && (HitEdgeCode[2]))
			if (Yspeed < 0)
				Yspeed <= -Yspeed;

				
		if (collision_Red_White && (flagY ==0)) begin						// hitting the white ball
			Yspeed <= white_y_speed;
			flagY <= 1;
			end
		
		if ((flagY == 1) && (collision_Red_White == 0))						// only once ^
			flagY <= 0;
			
		if (turn_over) begin															// the turn is over
			Yspeed <= 0;
			topLeftY_FixedPoint <= new_red_y_loc* FIXED_POINT_MULTIPLIER;
		end
	
		if (startOfFrame == 1'b1) begin 
				
				topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; // position interpolation 
				if (Yspeed > 0)
					Yspeed <= Yspeed - Y_ACCEL;								//accleration impact
				if (Yspeed < 0)
					Yspeed <= Yspeed + Y_ACCEL;
		end
	
	
	
	end
end 

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of X Axis speed using and position calculate regarding X_direction key or colision

always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN)
	begin
		flagX = 0;
		Xspeed	<= INITIAL_X_SPEED;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
	else begin
	
	
	if (collision_Red_Border && (HitEdgeCode[1]))						// hitting the right and the left (1 and 3)
		if(Xspeed>0)
			Xspeed <= -Xspeed;
			
			
	if (collision_Red_Border && (HitEdgeCode[3]))
		if(Xspeed<0)
			Xspeed <= -Xspeed;
	
	
	if (collision_Red_White && (flagX ==0)) begin						// hitting the white ball
		flagX <= 1;
		Xspeed <= white_x_speed;
		end
		
	if ((flagX == 1) && (collision_Red_White == 0))						// only once ^
		flagX <= 0;
		
	if (turn_over) begin															// the turn is over
			Xspeed <= 0;
			topLeftX_FixedPoint <= new_red_x_loc* FIXED_POINT_MULTIPLIER;
	end
		
	
	
	if (startOfFrame == 1'b1 ) begin
		topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;			// position interpolation
		if (Xspeed > 0)
				Xspeed <= Xspeed - X_ACCEL;									//accleration impact
		if (Xspeed < 0)
				Xspeed <= Xspeed + X_ACCEL;
		end
			
					
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ; 
assign red_x_speed = Xspeed;
assign red_y_speed = Yspeed;   
assign red_ball_stopped = ((Xspeed == 0) && (Yspeed == 0)) ? 1 : 0;


endmodule
