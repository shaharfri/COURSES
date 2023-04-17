
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // WhiteBall inputs
					input		logic	WhiteBallDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] WhiteBallRGB, 
					     
		   // RedBall inputs
					input		logic	RedBallDrawingRequest, 
					input		logic	[7:0] RedBallRGB, 
			  
			// BlackBall inputs
					input		logic	[5:0] BlackBallDrawingRequest, 
					input		logic	[7:0] BlackBallRGB_0_, 
					input		logic	[7:0] BlackBallRGB_1_,
					input		logic	[7:0] BlackBallRGB_2_,
					input		logic	[7:0] BlackBallRGB_3_,
					input		logic	[7:0] BlackBallRGB_4_,
					input		logic	[7:0] BlackBallRGB_5_,
		  // background 
					input    logic boardersDrawReq, //   
					input		logic	[7:0] backGroundRGB, 
			//scoreLevel boards
					input logic scoreLevelDR,
					input logic [7:0] scoreLevelRGB,
			// Score Numbers
					input logic ScoreNumberDR,
					input logic [7:0] ScoreNumberRGB,
					input logic ScoreNumber2DR,
					input logic [7:0] ScoreNumber2RGB,
			// Level Numbers
					input logic LevelNumberDR,
					input logic [7:0] LevelNumberRGB,
					input logic LevelNumber2DR,
					input logic [7:0] LevelNumber2RGB,
					
			//GreenBall inputs
					input		logic	GreenBallDrawingRequest, 
					input		logic	[7:0] GreenBallRGB, 
			  
				   output	logic	[7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
	
		if (GreenBallDrawingRequest == 1'b1)
			RGBOut <= GreenBallRGB;  										//first priority-blue hole 
			
		else if (BlackBallDrawingRequest > 1'b0) begin
		
			if (BlackBallDrawingRequest[0] == 1'b1 )  				//second priority-black hole 
				RGBOut <= BlackBallRGB_0_;  //first hole
				
			if (BlackBallDrawingRequest[1] == 1'b1 )   
				RGBOut <= BlackBallRGB_1_;  //second hole
				
			if (BlackBallDrawingRequest[2] == 1'b1 )   
				RGBOut <= BlackBallRGB_2_;  //third hole
				
			if (BlackBallDrawingRequest[3] == 1'b1 )   
				RGBOut <= BlackBallRGB_3_;  //fourth hole
				
			if (BlackBallDrawingRequest[4] == 1'b1 )   
				RGBOut <= BlackBallRGB_4_;  //fifth hole
				
			if (BlackBallDrawingRequest[5] == 1'b1 )   
				RGBOut <= BlackBallRGB_5_;  //sixth hole
			end
			
		
		
			
		else if (WhiteBallDrawingRequest == 1'b1 )   
			RGBOut <= WhiteBallRGB;  										//third priority-white ball 
		 
		else if (RedBallDrawingRequest == 1'b1 )   
			RGBOut <= RedBallRGB;  											//fourth priority-red ball 
			
		else if (scoreLevelDR == 1'b1)
			RGBOut <= scoreLevelRGB;										//fifth priority-score level boards
			
		else if (ScoreNumberDR == 1'b1)
			RGBOut <= ScoreNumberRGB;										//sixth priority-score digit 1
			
		else if (ScoreNumber2DR == 1'b1)
			RGBOut <= ScoreNumber2RGB;										//seventh priority-score digit 2
		 
		else if (LevelNumberDR == 1'b1)
			RGBOut <= LevelNumberRGB; 										//eightth priority-level digit 1
			
		else if (LevelNumber2DR == 1'b1)
			RGBOut <= LevelNumber2RGB; 									//ninth priority-level digit 2
		 
		else if (boardersDrawReq == 1'b1 )   
			RGBOut <= backGroundRGB;  										//tenth priority-background
		
		
		else 
			RGBOut <= backGroundRGB ; // last priority 
		end ; 
	end

endmodule


