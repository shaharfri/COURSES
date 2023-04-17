// 4->1 multiplexer template
module mux4 (
    input logic d0,          // Data input 0
    input logic d1,          // Data input 1
    input logic d2,          // Data input 2
    input logic d3,          // Data input 3
    input logic [1:0] sel,   // Select input
    output logic z           // Output
);

logic s1;
logic s2;
mux2 instMUX2_1 (.z(s1), .d0(d0), .d1(d1), .sel(sel[0]));
mux2 instMUX2_2 (.z(s2), .d0(d2), .d1(d3), .sel(sel[0]));
mux2 instMUX2_3 (.z(z), .d0(s1), .d1(s2), .sel(sel[1]));

endmodule
