module lab2_part2 (LEDR,SW);
input [9:0] SW;
output [9:0] LEDR;
mux4to1(
.in0(SW[0]),
.in1(SW[1]),
.in2(SW[2]),
.in3(SW[3]),
.s0(SW[8]),
.s1(SW[9]),
.m(LEDR[0]),
);

endmodule


module mux4to1(in0,in1,in2,in3,s0,s1,m);
input in0;
input in1;
input in2;
input in3;
input s0;
input s1;
output m;

wire w0;
wire w1;
mux2to1(in0,in1,s0,w0);
mux2to1(in2,in3,s0,w1);
mux2to1(w0,w1,s1,m);
endmodule







module mux2to1(x,y,s,m);
input x;//select 0

input y;//select 1
input s;// select signal
output m;//output

assign m = s & y | ~s & x;
endmodule
