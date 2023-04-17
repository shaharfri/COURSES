// 64-bit ALU test bench template
module alu64bit_test;

logic [63:0] a;
logic [63:0] b;
logic cin ;
logic [1:0] op;
logic [63:0] s;
logic cout;

alu64bit alu64bit_inst (.s(s), .cout(cout), .a(a), .b(b), .cin(cin), .op(op));
initial begin
a[63:0]=64'b0;
b[63:0]=64'b0;
cin=1'b0;
op[0]=1'b1;
op[1]=1'b1;
#100 //upper bound for the expected tpd
cin=1'b1;
#100 //upper bound for the expected tpd
cin=1'b0;
#100; //upper bound for the expected tpd
end
// End of your code

endmodule
