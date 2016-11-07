module datapath(clock,VGA_R,VGA_G.VGE_B,ResetN,[6:0]datainput,ctlA,ctlB,ctlC,[7:0]X_location,[7:0]y_location,R_O,G_O,B_O);
input clock;
input VGA_R;
input VGA_G;
input VGA_B;
input ResetN;
input [6:0]datainput;
input ctlA;
input ctlB;
input ctlC;
output [7:0]x_location;
output [7:0]y_location;
reg[2:0] command;
assign command[2]=ctlA;
assign command[1]=ctlB;
assign command[0]=ctlC;

always@(posdge clock)
begin
if(command==3'b100)
begin
x_location[7]=1'b0;
x_location[6:0]=datainput[6:0];
end 
else if(command==3'b010)
begin

end
end
end

endmodule