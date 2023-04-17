//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2021
// generating a number bitmap 



module digit2BitMap	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,
					input		logic	InsideRectangle, //input that the pixel is within a bracket 
					input 	logic	[3:0] digit, // digit to display
					
					output	logic				drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0]		RGBout
);
// generating a smily bitmap 

parameter  logic	[7:0] digit_color = 8'h00 ; //set the color of the digit 


bit [0:31] [0:15] number_bitmap  = {


{16'b	0000001111100000,
16'b	0000111111111000,
16'b	0000111111111000,
16'b	0001111111111100,
16'b	0011111001111100,
16'b	0011100000111110,
16'b	0111100000011110,
16'b	0111100000011110,
16'b	1111100000011111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000001111,
16'b	1111000000011110,
16'b	1111100000011110,
16'b	0111110000111110,
16'b	0111110000111100,
16'b	0011111001111100,
16'b	0011111111111000,
16'b	0001111111111000,
16'b	0000111111110000,
16'b	0000011111000000},
													
} ; 
																	
	


// pipeline (ff) to get the pixel color from the array 	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest <=	1'b0;
	end
	else begin
		drawingRequest <=	1'b0;
	
		if ((InsideRectangle == 1'b1) && (digit == 10))				// when need to show the number 10, this module can show the second digit of this number-0
			drawingRequest <= (number_bitmap[offsetY][offsetX]);	//get value from bitmap  
	end 
end

assign RGBout = digit_color ; // this is a fixed color 

endmodule