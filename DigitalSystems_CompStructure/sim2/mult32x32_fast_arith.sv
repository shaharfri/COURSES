// 32X32 Multiplier arithmetic unit template
module mult32x32_fast_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic a_msb_is_0,     // Indicates MSB of operand A is 0
    output logic b_msb_is_0,     // Indicates MSB of operand B is 0
    output logic [63:0] product  // Miltiplication product
);

// Put your code here
// ------------------
logic [7:0]mux_4_1_out;
logic [15:0]mux_2_1_out;
logic [23:0]mult_16x8_out;
logic [63:0]shifter_out;
logic [23:0]mult_temp_1;
logic [23:0]mult_temp_2;
logic [23:0]mult_temp_3;

always_comb begin
if ( a[31:24] == { 8{1'b0} } ) begin 
a_msb_is_0 = 1'b1;
end 
else begin 
a_msb_is_0 = 1'b0;
end 
end 

always_comb begin 
if (b[31:16] == { 16{1'b0}}) begin 
b_msb_is_0 = 1'b1;
end 
else begin 
b_msb_is_0 = 1'b0;
end 
end

always_comb begin
case (a_sel)
    2'd0: mux_4_1_out = a[7:0];
	2'd1: mux_4_1_out = a[15:8];
	2'd2: mux_4_1_out = a[23:16];
    2'd3: mux_4_1_out = a[31:24];
endcase
end

always_comb begin
case (b_sel)
    1'd0: mux_2_1_out = b[15:0];
    1'd1: mux_2_1_out = b[31:16];
endcase
end

always_comb begin
	mult_temp_1[23:0] = mux_2_1_out[15:8] * mux_4_1_out[7:0];
	mult_temp_2[23:0] = mult_temp_1[15:0] << 8;
	mult_temp_3[23:0] = mux_2_1_out[7:0] * mux_4_1_out[7:0];
	mult_16x8_out[23:0] = mult_temp_2[23:0] + mult_temp_3[23:0];
end

always_comb begin
	case(shift_sel)
		3'd0: shifter_out = mult_16x8_out;
		3'd1: shifter_out = mult_16x8_out << 8;
		3'd2: shifter_out = mult_16x8_out << 16;
		3'd3: shifter_out = mult_16x8_out << 24;
		3'd4: shifter_out = mult_16x8_out << 32;
		3'd5: shifter_out = mult_16x8_out << 40;
	endcase
end

always_ff @ (posedge clk, posedge reset) begin
	if ((reset == 1'b1) || (clr_prod == 1'b1))  begin 
		product <= 63'b0;
	end
	else if (upd_prod == 1'b1) begin
		product <= product + shifter_out;
	end
end

// End of your code

endmodule
