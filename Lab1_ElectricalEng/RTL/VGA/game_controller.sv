
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  							// short pulse every start of frame 30Hz 
			input	logic	drawing_request_WhiteBall,       	//high if the white ball is drawing
			input	logic	[5:0] drawing_request_BlackBall,		//high if any black hole is drawing
			input	logic drawing_request_RedBall,				//high if the red ball is drawing
			input	logic drawing_request_border,					//high if the border is drawing
			input logic white_ball_stopped,						//high if the white ball stopped
			input logic red_ball_stopped,							//high if the red ball stopped
			input logic white_started, 							//high if the white ball started
			
			
			output logic collision, 								// collisions get high if some DR are in high
			output logic collision_White_Red,
			output logic collision_Red_Black,
			output logic collision_White_Black,
			output logic collision_White_Border,
			output logic collision_Red_Border,
			output logic SingleHitPulse ,							// critical code, generating A single pulse in a frame 
			output logic [10:0] new_red_x_loc,					// new red ball location
			output logic [10:0] new_red_y_loc,					
			output logic [10:0] new_white_x_loc,				// new white ball location
			output logic [10:0] new_white_y_loc,	
			output logic collision_Red_Black0,					//specific collision for every black hole
			output logic collision_Red_Black1,
			output logic collision_Red_Black2,
			output logic collision_Red_Black3,
			output logic collision_Red_Black4,
			output logic collision_Red_Black5,
			output logic turn_over,									// high if the turn is over
			output logic [3:0] Level,								// output of the level of the stage
			output logic [3:0] score_out,							// output of the current score
			output logic [10:0] green_x_loc,						// green ball output location
			output logic [10:0] green_y_loc
			
			
			
);


logic [10:0] counter;



assign collision = (( drawing_request_WhiteBall &&  drawing_request_RedBall ) ||
( drawing_request_RedBall &&  (drawing_request_BlackBall>0)) ||
(drawing_request_WhiteBall &&  (drawing_request_BlackBall>0) )  ||
(drawing_request_WhiteBall &&  (drawing_request_border)) ||
(drawing_request_RedBall &&  (drawing_request_border)));// any collision 

//conditions to decide wich collision is happen, the flags make every signal gets high just once in a row

assign collision_White_Red = (drawing_request_WhiteBall &&  drawing_request_RedBall && (flagc==0));  										

assign collision_Red_Black = ((drawing_request_RedBall) &&  (drawing_request_BlackBall>0) && (flagc2==0));

assign collision_White_Black = (drawing_request_WhiteBall &&  (drawing_request_BlackBall>0) && (flagc1==0));

assign collision_White_Border = drawing_request_WhiteBall &&  (drawing_request_border);

assign collision_Red_Border = drawing_request_RedBall &&  (drawing_request_border);

assign collision_Red_Black0 = drawing_request_RedBall && drawing_request_BlackBall[0];

assign collision_Red_Black1 = drawing_request_RedBall && drawing_request_BlackBall[1];

assign collision_Red_Black2 = drawing_request_RedBall && drawing_request_BlackBall[2];

assign collision_Red_Black3 = drawing_request_RedBall && drawing_request_BlackBall[3];

assign collision_Red_Black4 = drawing_request_RedBall && drawing_request_BlackBall[4];

assign collision_Red_Black5 = drawing_request_RedBall && drawing_request_BlackBall[5];

//conditions of turn over and score

assign turn_over = (collision_White_Black || collision_Red_Black ||(white_ball_stopped && red_ball_stopped && white_started));

assign score_out[3:0] = score_ps[3:0];

						 					
//inside signals

logic [3:0] score_ps;
logic [3:0] score_ns;
logic [3:0] desired_hole;
logic flag;															//semaphores to set the output only once per frame / regardless of the number of collisions
logic flagc ; 														 
logic flagc1;
logic flagc2;
logic [10:0]counter1;
logic [10:0]counter2;


//-------------------------------------------------------------------------------------------

// state machine decleration 
	enum logic [5:0] {s_turn1, s_turn2, s_turn3, s_turn4, s_turn5, s_turn6, s_turn7, s_turn8, s_turn9, s_turn10, s_gameOver } game_ps, game_ns;
 	
//--------------------------------------------------------------------------------------------
//  1.  syncronous code:  executed once every clock to update the current state 
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN ) begin // Asynchronic reset 
		game_ps <= s_turn1;
		score_ps <= 0;
		end
		
   
	else 	begin	// Synchronic logic FSM
		game_ps <= game_ns;
		score_ps <= score_ns;
		end
	end // always sync



//white ball has white_started output, which is 1 always, except for when it is the beggining of a turn. it is the beginning of a turn when the if(turn over) is true, in which
// we make white_started 0. 
	
	//--------------------------------------------------------------------------------------------
//  2.  asynchornous code: logically defining what is the next state, and the ouptput 
//      							(not seperating to two different always sections)  	
always_comb // Update next state and outputs
	begin
	// set all default values 
		game_ns = game_ps;
		score_ns = score_ps;
		Level = 1;
		new_red_x_loc = 300;
		new_red_y_loc = 300;
		new_white_x_loc = 500;
		new_white_y_loc = 400;
		desired_hole = 5;
		green_x_loc = 585;
		green_y_loc = 425;
		
		case (game_ps)												//those are the 10 levels of the game as state machine, each level (state) gets his uniqe values 
		
			s_turn1: begin
				Level = 1;
				//the location of the balls for level 1 come from the parameters set in the white/red ball blocks
				desired_hole = 4;
				green_x_loc = 300;
				green_y_loc = 428;
				if (collision_Red_Black4 && (flagc2==0))
					score_ns = score_ps + 1;
				if (collision_White_Black&& (flagc1==0) && (score_ps>0))
					score_ns = score_ps - 1;
				if (turn_over) begin
					new_red_x_loc = 200;
					new_red_y_loc = 200;
					new_white_x_loc = 150;
					new_white_y_loc = 150;
					game_ns = s_turn2; 
					end
				end 
						
			s_turn2: begin
				Level = 2;
				desired_hole = 5;
				green_x_loc = 585;
				green_y_loc = 428;
				if (collision_Red_Black5 && (flagc2==0))
					score_ns = score_ps + 1;
				if (collision_White_Black&& (flagc1==0)&& (score_ps>0))
					score_ns = score_ps - 1;
				if (turn_over) begin 
					new_red_x_loc = 500;
					new_red_y_loc = 400;
					new_white_x_loc = 450;
					new_white_y_loc = 300;
					game_ns = s_turn3; 
					end
				end 
						
			s_turn3: begin
				Level = 3;
				desired_hole = 4;	
				green_x_loc = 300;
				green_y_loc = 428;
				if (collision_Red_Black4 && (flagc2==0))
					score_ns = score_ps + 1;
				if (collision_White_Black&& (flagc1==0)&& (score_ps>0))
					score_ns = score_ps - 1;
				if (turn_over)begin 
					new_red_x_loc = 150;
					new_red_y_loc = 200;
					new_white_x_loc = 400;
					new_white_y_loc = 400;
					game_ns = s_turn4;
					end
				end 
					
			s_turn4: begin
				Level = 4;
				desired_hole = 0;
				green_x_loc = 15;
				green_y_loc = 15;
				if (collision_Red_Black4 && (flagc2==0))
					score_ns = score_ps + 1;
				if (collision_White_Black&& (flagc1==0)&& (score_ps>0))
					score_ns = score_ps - 1;
				if (turn_over)begin 
					new_red_x_loc = 300;
					new_red_y_loc = 300;
					new_white_x_loc = 550;
					new_white_y_loc = 100;
					game_ns = s_turn5;
					end
				end 
						
			s_turn5: begin
				Level = 5;
				desired_hole = 3;		
				green_x_loc = 15;
				green_y_loc = 428;
				if (collision_Red_Black5 && (flagc2==0))
					score_ns = score_ps + 1;
				if (collision_White_Black&& (flagc1==0)&& (score_ps>0))
					score_ns = score_ps - 1;
				if (turn_over)begin
					new_red_x_loc = 500;
					new_red_y_loc = 400;
					new_white_x_loc = 500;
					new_white_y_loc = 200;
					game_ns = s_turn6;
					end
				end 
				
			s_turn6: begin	
				Level = 6;
				desired_hole = 1;	
				green_x_loc = 1;
				green_y_loc = 15;
				if (collision_Red_Black1 && (flagc2==0))
					score_ns = score_ps + 1;
				if (collision_White_Black&& (flagc1==0)&& (score_ps>0))
					score_ns = score_ps - 1;
				if (turn_over)begin
					new_red_x_loc = 100;
					new_red_y_loc = 100;
					new_white_x_loc = 400;
					new_white_y_loc = 400;					
					game_ns = s_turn7;
					end
				end 
				
			s_turn7	: begin
				Level = 7;
				desired_hole = 0;
				green_x_loc = 15;
				green_y_loc = 15;
				if (collision_Red_Black0 && (flagc2==0))
					score_ns = score_ps + 1;
				if (collision_White_Black&& (flagc1==0)&& (score_ps>0))
					score_ns = score_ps - 1;
				if (turn_over)begin 
					new_red_x_loc = 400;
					new_red_y_loc = 400;
					new_white_x_loc = 100;
					new_white_y_loc = 100;
					game_ns = s_turn8;
					end
				end
					
			s_turn8	: begin
				Level = 8;
				desired_hole = 4;	
				green_x_loc = 300;
				green_y_loc = 428;
				if (collision_Red_Black4 && (flagc2==0))
					score_ns = score_ps + 1;
				if (collision_White_Black&& (flagc1==0)&& (score_ps>0))
					score_ns = score_ps - 1;
				if (turn_over)begin 
					new_red_x_loc = 100;
					new_red_y_loc = 100;
					new_white_x_loc = 500;
					new_white_y_loc = 200;
					game_ns = s_turn9;
					end
				end	
			
			s_turn9	: begin
				Level = 9;
				desired_hole = 4;
				green_x_loc = 300;
				green_y_loc = 428;
				if (collision_Red_Black4 && (flagc2==0))
					score_ns = score_ps + 1;
				if (collision_White_Black&& (flagc1==0)&& (score_ps>0))
					score_ns = score_ps - 1;
				if (turn_over)begin 
					new_red_x_loc = 300;
					new_red_y_loc = 300;
					new_white_x_loc = 400;
					new_white_y_loc = 400;
					game_ns = s_turn10;
					end
				end
		
			s_turn10	: begin
				Level = 10;
				green_x_loc = 585;
				green_y_loc = 15;
				desired_hole = 2;				
				if (collision_Red_Black2 && (flagc2==0))
					score_ns = score_ps + 1;
				if (collision_White_Black&& (flagc1==0)&& (score_ps>0))
					score_ns = score_ps - 1;
				if (turn_over) 
					game_ns = s_gameOver;
				end	
			
			s_gameOver	: begin
				
				end	
						
		endcase
	end 


always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN)
	begin 
		counter <= 0;
		counter1 <= 0;
		counter2 <= 0;
		flag <= 0;
		flagc	<= 1'b0;
		flagc1	<= 1'b0;
		flagc2	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 
			
			SingleHitPulse <= 1'b0 ; // default 
			if(startOfFrame) 
				flag <= 1'b0 ; // reset for next time 
			
				if( collision_White_Red && (flagc == 0)) 
					flagc <= 1;
				if (flagc == 1)
					counter <= counter + 1;
				if (counter == 1000)
					flagc <=0;
				
				if( collision_White_Black && (flagc1 == 0))
					flagc1 <= 1;
				if (flagc1 == 1)
					counter1 <= counter1 + 1;
				if (counter1 == 150)
					flagc1 <=0;
					
				if( collision_Red_Black && (flagc2 == 0))
					flagc2 <= 1;
				if (flagc2 == 1)
					counter2 <= counter2 + 1;
				if (counter2 == 150)
					flagc2 <=0;
				


if ( collision && (flag == 1'b0)) begin 
			flag	<= 1'b1; // to enter only once 
			SingleHitPulse <= 1'b1 ; 
		end ; 
	end 
end


endmodule
