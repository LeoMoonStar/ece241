module lab7part1(input [9:0]SW,input [0:0]KEY,output [6:0]HEX0,HEX2,HEX5,HEX4);
wire [3:0]data_input=SW[3:0];
wire [4:0]address_input=SW[8:4];
wire wren=SW[9];
wire clock=~KEY[0];

wire [3:0]ram_output;

ram32x4 ram(data_input[3:0],wren,address_input[4:0],clock,ram_output[3:0]);

reg[3:0] double_digit;
always@(*)
begin
double_digit[3]=1'b0;
double_digit[2]=1'b0;
double_digit[1]=1'b0;
double_digit[0]=SW[8];
end
hex_decoder h0(ram_output[3:0],HEX0);
hex_decoder h1(data_input[3:0],HEX2);
hex_decoder h2(double_digit,hex5);
hex_decoder h3(address_input[3:0],HEX4);
endmodule