// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2021
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	WhiteBallBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic collision_White_Border, //input indicator of collision between WhiteBall and Border 
					input logic collision_White_Red,		//input indicator of collision between WhiteBall and RedBall 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout,  //rgb value from the bitmap 
					output	logic	[3:0] HitEdgeCode //one bit per edge 
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;  // 2^5 = 32 


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [7:0] object_colors = {
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff},
	{8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff},
	{8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff},
	{8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff},
	{8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff},
	{8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff},
	{8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff},
	{8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff},
	{8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff},
	{8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff},
	{8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff},
	{8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff},
	{8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff},
	{8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff}};


//////////--------------------------------------------------------------------------------------------------------------=
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	
//there is one bit per edge, in the corner two bits are set  


logic [0:3] [0:3] [3:0] hit_colors = 
		  {16'h0440,     
			16'h8C62,    
			16'h8932,
			16'h0110};

 

// pipeline (ff) to get the pixel color from the array 



//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	TRANSPARENT_ENCODING;
		HitEdgeCode <= 4'h0;

	end

	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default  
		HitEdgeCode <= 4'h0;

		if (InsideRectangle == 1'b1 && (collision_White_Border || collision_White_Red ) ) //case of collision with HitEdges
		begin // inside an external bracket 
			HitEdgeCode <= hit_colors[offsetY >> OBJECT_HEIGHT_Y_DIVIDER][offsetX >> OBJECT_WIDTH_X_DIVIDER];	//get hitting edge from the colors table  
			RGBout <= object_colors[offsetY][offsetX];
		end 
		
		else if (InsideRectangle == 1'b1) 		//case of no collision without HitEdges
			RGBout <= object_colors[offsetY][offsetX];
	end
		
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule