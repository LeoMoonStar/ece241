`timescale 1ns / 1ns // `timescale time_unit/time_precision
module alu(SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY);
input [9:0] SW;
input [2:0] KEY;
output [9:0] LEDR;
output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;
output [6:0] HEX4;
output [6:0] HEX5;
wire [3:0] A_input;
wire [3:0] B_input;
assign A_input = SW[7:4];

wire clock;
assign clock=KEY[0];
wire reset_b;
assign reset_b=SW[9];
wire [2:0] key_select;
assign key_select=KEY[3:1];


alu_model a0(.A(A_input), .B(B_input), .key_select(KEY), .ALUout(LEDR));
hex_display_model h0(.hex_input(B_input), .hex_output(HEX0));
hex_display_model h1(.hex_input(4'b0000), .hex_output(HEX1));
hex_display_model h2(.hex_input(A_input), .hex_output(HEX2));
hex_display_model h3(.hex_input(4'b0000), .hex_output(HEX3));
hex_display_model h4(.hex_input(LEDR[3:0]), .hex_output(HEX4));
hex_display_model h5(.hex_input(LEDR[7:4]), .hex_output(HEX5));


register_model(.in(ALUout),.reset(
endmodule



module alu_model(A,B,key_select,ALUout);

input [3:0] A;
input [3:0] B;
output [7:0] ALUout;
reg [7:0] ALUout;
input [2:0] key_select;
wire [7:0] reduction_oper;
wire [7:0] case_0;
wire [7:0] case_1;
wire [7:0] case_2;
reg [7:0] case_3;
reg [7:0] case_4;
wire [7:0] case_5;
wire[7:0] case_6;
//wire[7:0] current_Value;

//case_0
ripple_carry_adder r0(.CIN(1'b0), .INPUT_1(A), .INPUT_2(B), .COUT(case_0[4]), .RESULT(case_0[3:0]));
assign case_0[7:5] = 3'b000;
//assign current_value[7:5]=case_0[7:5];

//case_1
assign case_1 = A + B;
//assign current_value=case_1;

//case_2 
assign case_2[7:4] = A ^ B;
assign case_2[3:0] = A | B;
//assign current_value[7:4]=case_2;

//Combine A and B 
assign reduction_oper[7:4] = A;
assign reduction_oper[3:0] = B;

//case_3 & case_4
always@(*)
	begin
		if(|reduction_oper)
			case_3 = 8'b10000001;
		else
			case_3 = 8'b00000000;
		
		if(&reduction_oper)
			case_4 = 8'b01111110;
		else
			case_4 = 8'b00000000;
	end
	
//case_5
assign case_5[7:4] = B<<A;

//case_6
assign case_6[7:0]=A*B;

//case_7
assign case_7[7:0]=ALUout;


always@(*)
	begin
		case(key_select)
			3'b000: ALUout = case_0;
			3'b001: ALUout = case_1;
			3'b010: ALUout = case_2;
			3'b011: ALUout = case_3;
			3'b100: ALUout = case_4;
			3'b101: ALUout = case_5;
			3'b110: ALUout = case_6;
			3'b111: ALUout = case_7;
			default: ALUout = 8'b00000000;
		endcase
	end
	
endmodule 

module register_model();

input [7:0]in;
input reset,clk;
output [7:0];
reg[7:0] out;

always@(posedge clk)
begin
   if(reset=1'b0)
	 begin
	    out<=0;
	 end
else
    begin
	    out<=in;
	 end
end
endmodule;


module ripple_carry_adder(CIN,INPUT_1,INPUT_2,COUT,RESULT);
	input [3:0] INPUT_1;
	input [3:0] INPUT_2;
	input CIN;
	output [3:0] RESULT;
	output COUT;
	wire [2:0] TEMP;
	
	full_adder_model f0(
	.a(INPUT_1[0]),
	.b(INPUT_2[0]),
	.cin(CIN),
	.s(RESULT[0]),
	.cout(TEMP[0])
	);

	full_adder_model f1(
	.a(INPUT_1[1]),
	.b(INPUT_2[1]),
	.cin(TEMP[0]),
	.s(RESULT[1]),
	.cout(TEMP[1])
	);
	
	full_adder_model f2(
	.a(INPUT_1[2]),
	.b(INPUT_2[2]),
	.cin(TEMP[1]),
	.s(RESULT[2]),
	.cout(TEMP[2])
	);
	
	full_adder_model f3(
	.a(INPUT_1[3]),
	.b(INPUT_2[3]),
	.cin(TEMP[2]),
	.s(RESULT[3]),
	.cout(COUT)
	);
	
endmodule



module full_adder_model(a,b,cin,s,cout);
	input a, b, cin;
	output s, cout;
	assign s = cin ^ (a ^ b);
	mux2to1 u0(b,cin,a^b,cout);
	
endmodule

module mux(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    mux2to1 u0(
        .x(SW[0]),
        .y(SW[1]),
        .s(SW[9]),
        .m(LEDR[0])
        );
endmodule

module mux2to1(x, y, s, m);
    input x; //select 0
    input y; //select 1
    input s; //select signal
    output m; //output
  
    //assign m = s & y | ~s & x;
    // OR
    assign m = s ? y : x;

endmodule
 
module hex_display_model(hex_input,hex_output);
	input [3:0] hex_input;
	output [6:0] hex_output;
	
	seven_h0 seg0(.C3(hex_input[3]),
						.C2(hex_input[2]),
						.C1(hex_input[1]),
						.C0(hex_input[0]),
						.H0(hex_output[0])
						);
						
	seven_h1 seg1(.C3(hex_input[3]),
						.C2(hex_input[2]),
						.C1(hex_input[1]),
						.C0(hex_input[0]),
						.H1(hex_output[1])
						);
						
	seven_h2 seg2(.C3(hex_input[3]),
						.C2(hex_input[2]),
						.C1(hex_input[1]),
						.C0(hex_input[0]),
						.H2(hex_output[2])
						);

	seven_h3 seg3(.C3(hex_input[3]),
						.C2(hex_input[2]),
						.C1(hex_input[1]),
						.C0(hex_input[0]),
						.H3(hex_output[3])
						);
	
	seven_h4 seg4(.C3(hex_input[3]),
						.C2(hex_input[2]),
						.C1(hex_input[1]),
						.C0(hex_input[0]),
						.H4(hex_output[4])
						);
						
	seven_h5 seg5(.C3(hex_input[3]),
						.C2(hex_input[2]),
						.C1(hex_input[1]),
						.C0(hex_input[0]),
						.H5(hex_output[5])
						);
						
	seven_h6 seg6(.C3(hex_input[3]),
						.C2(hex_input[2]),
						.C1(hex_input[1]),
						.C0(hex_input[0]),
						.H6(hex_output[6])
						);
					
endmodule

module seven_h0(C3,C2,C1,C0,H0);
	input C3,C2,C1,C0;
	output H0;
	assign H0 = ~((C3|C2|C1|(~C0))&(C3|(~C2)|C1|C0)&((~C3)|C2|(~C1)|(~C0))&(~C3|~C2|C1|~C0));

endmodule

module seven_h1(C3,C2,C1,C0,H1);
	input C3,C2,C1,C0;
	output H1;
	assign H1 = ~((C3|~C2|C1|~C0)&(C3|~C2|~C1|C0)&(~C3|C2|~C1|~C0)&(~C3|~C2|C1|C0)&(~C3|~C2|~C1|C0)&(~C3|~C2|~C1|~C0));
	
endmodule

module seven_h2(C3,C2,C1,C0,H2);
	input C3,C2,C1,C0;
	output H2;
	assign H2 = ~((C3|C2|~C1|C0)&(~C3|~C2|C1|C0)&(~C3|~C2|~C1|C0)&(~C3|~C2|~C1|~C0));
	
endmodule

module seven_h3(C3,C2,C1,C0,H3);
	input C3,C2,C1,C0;
	output H3;
	assign H3 = ~((C3|C2|C1|~C0)&(C3|~C2|C1|C0)&(C3|~C2|~C1|~C0)&(~C3|C2|C1|~C0)&(~C3|C2|~C1|C0)&(~C3|~C2|~C1|~C0));
	
endmodule

module seven_h4(C3,C2,C1,C0,H4);
	input C3,C2,C1,C0;
	output H4;
	assign H4 = ~((C3|C2|C1|~C0)&(C3|C2|~C1|~C0)&(C3|~C2|C1|C0)&(C3|~C2|C1|~C0)&(C3|~C2|~C1|~C0)&(~C3|C2|C1|~C0));
	
endmodule

module seven_h5(C3,C2,C1,C0,H5);
	input C3,C2,C1,C0;
	output H5;
	assign H5 = ~((C3|C2|C1|~C0)&(C3|C2|~C1|C0)&(C3|C2|~C1|~C0)&(C3|~C2|~C1|~C0)&(~C3|~C2|C1|~C0));
	
endmodule

module seven_h6(C3,C2,C1,C0,H6);
	input C3,C2,C1,C0;
	output H6;
	assign H6 = ~((C3|C2|C1|C0)&(C3|C2|C1|~C0)&(C3|~C2|~C1|~C0)&(~C3|~C2|C1|C0));
	
endmodule
