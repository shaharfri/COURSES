// Full Adder/Subtractor test bench template
module fas_test;

logic cin;
logic b;
logic a_ns;
logic a;
logic cout;
logic s;
fas fas_inst (.cout(cout), .s(s), .cin(cin), .b(b), .a_ns(a_ns), .a(a));
initial begin
cin=1'b1;
b=1'b0;
a_ns=1'b1;
a=1'b0;
#100 //upper bound for the expected tpd
a_ns=1'b0;
#100 //upper bound for the expected tpd
a_ns=1'b1;
#100; //upper bound for the expected tpd
end
// End of your code

endmodule

