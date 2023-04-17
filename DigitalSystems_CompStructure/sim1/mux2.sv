// 2->1 multiplexer template
module mux2 (
    input logic d0,          // Data input 0
    input logic d1,          // Data input 1
    input logic sel,         // Select input
    output logic z           // Output
);

logic a;
logic b;
logic c;
logic d;
logic e;
logic f;
logic g;

NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND1 (.Z(a), .A(d1), .B(sel));
NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND2 (.Z(b), .A(d1), .B(sel));
NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND3 (.Z(c), .A(a), .B(b));
NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND4 (.Z(d), .A(sel), .B(sel));
NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND5 (.Z(e), .A(d), .B(d0));
NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND6 (.Z(f), .A(d), .B(d0));
NAND2#(.Tpdlh(10), .Tpdhl(10)) instNAND7 (.Z(g), .A(e), .B(f));
OR2#(.Tpdlh(7), .Tpdhl(7)) instOR1 (.Z(z), .A(c), .B(g));
endmodule
