// Full Adder/Subtractor template
module fas (
    input logic a,           // Input bit a
    input logic b,           // Input bit b
    input logic cin,         // Carry in
    input logic a_ns,        // A_nS (add/not subtract) control
    output logic s,          // Output S
    output logic cout        // Carry out
);

logic s1;
logic s2;
logic s3;
logic s4;
logic s5;

NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND1 (.Z(s1), .A(cin), .B(b));
OR2#(.Tpdlh(7), .Tpdhl(7)) instOR1 (.Z(s2), .A(cin), .B(b));
XNOR2#(.Tpdlh(9), .Tpdhl(9)) instXNOR1 (.Z(s3), .A(a_ns), .B(a));
NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND2 (.Z(s4), .A(s2), .B(s3));
NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND3 (.Z(cout), .A(s1), .B(s4));
XNOR2#(.Tpdlh(9), .Tpdhl(9)) instXNOR2 (.Z(s5), .A(b), .B(cin));
XNOR2#(.Tpdlh(9), .Tpdhl(9)) instXNOR3 (.Z(s), .A(s5), .B(a));

// End of your code

endmodule
