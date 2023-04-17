// 32X32 Multiplier test template
module mult32x32_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

// Put your code here
mult32x32 mult32x32_inst (
.clk(clk), 
.reset(reset),
.start(start), 
.a(a), 
.b(b), 
.busy(busy), 
.product(product)
);

initial begin 
	
	clk = 1'b0;
	#5
	clk = 1'b1;
	reset = 1'b1;
	start = 1'b0;
	busy = 1'b0;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	reset = 1'b0;
	a = 32'd204377923;
	b = 32'd316109081;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	start = 1'b1;
	busy = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	start = 1'b0;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	busy = 1'b0;
	#5
	clk = 1'b0;
	#5
	clk = 1'b1;
	#5
	clk = 1'b0;
	
end

// End of your code

endmodule
