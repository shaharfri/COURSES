// 32X32 Multiplier test template
module mult32x32_fast_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

// Put your code here
// ------------------
mult32x32_fast mult(.clk(clk), .reset(reset), .start(start), .busy(busy) ,.a(a), .b(b), .product(product) );
always begin
	#5 
	clk=~clk;
end

initial begin 
	clk = 1'b1;
	start = 1'b0;
	reset = 1'b1; 
	
	repeat (4) begin
	@(posedge clk);
	end 
	
reset=1'b0;
a=32'd204377923;
b=32'd316109081;
@(posedge clk);


start=1'b1;
@(posedge clk);
start=1'b0;
@(posedge clk);


	repeat (9) begin
	@(posedge clk);
	end 

a=32'b00000000000000001000111101000011;
b=32'b00000000000000000111000100011001;
@(posedge clk);


start=1'b1;
@(posedge clk);
start=1'b0;
@(posedge clk);


	repeat (9) begin
	@(posedge clk);
	end 
end 
// End of your code

endmodule
