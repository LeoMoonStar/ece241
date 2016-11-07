module lab7part2(SW,KEY,CLOCK_50);
//VGA_CLK,
//VGA_HS,
//VGA_BLANK,
//VGA_SYNC,
//VGA_R,
//VGA_G,
//VGE_B


input CLOCK_50;     //50HZ
input [3:0]KEY;
input [9:0]sw;



wire plot=KEY[1];
wire BLACK=KEY[2];
wire Restn=KEY[0];

wire [6:0]data_input=SW[6:0];
wire VGA_R=SW[9];
wire VGA_G=SW[8];
wire VGA_B=SW[7];



endmodule
/*output VGA_HS;
output VGA_VS;
output VGA_BLANK;
output [9:0]VGA_R;
output [9:0]VGA_G;
output [9:0]VGA_B;*/

