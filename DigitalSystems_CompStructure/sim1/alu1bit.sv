// 1-bit ALU template
module alu1bit (
    input logic a,           // Input bit a
    input logic b,           // Input bit b
    input logic cin,         // Carry in
    input logic [1:0] op,    // Operation
    output logic s,          // Output S
    output logic cout        // Carry out
);

logic or1_nand1, nand1_mux4;                    // NOR Logic 
logic xnor1_nand2, nand2_mux4;                  // XOR Logic
logic fas_s_mux4, nand3_ans;                    // FAS Logic

OR2#(.Tpdlh(7), .Tpdhl(7)) instOR1 (.Z(or1_nand1), .A(a), .B(b)); 
NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND1 (.Z(nand1_mux4), .A(or1_nand1), .B(or1_nand1)); 
XNOR2#(.Tpdlh(9), .Tpdhl(9)) instXNOR1 (.Z(xnor1_nand2), .A(a), .B(b)); 
NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND2 (.Z(nand2_mux4), .A(xnor1_nand2), .B(xnor1_nand2)); 
NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND3 (.Z(nand3_ans), .A(op[0]), .B(op[0])); 
fas instFAS
    (.s(fas_s_mux4), .cout(cout), .a(a), .b(b), .cin(cin), .a_ns(nand3_ans));
mux4 instMUX4
    (.d0(nand1_mux4), .d1(nand2_mux4), .d2(fas_s_mux4), .d3(), .sel(op), .z(s));

endmodule
