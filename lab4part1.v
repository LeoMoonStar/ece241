module lab2(SW,LEDR);
input [2:0] SW;
output[2:0] LEDR;

wire D;
assign D=SW[1];
wire Clk;
assign Clk=SW[0];
wire S;

assign S=~(D&Clk);
wire R;
assign R=~(~D&Clk);

wire Qa,Qb;
assign Qa=~(Qb&S);
assign Qb=~(Qa&R);

assign LEDR[0]=Qa;
assign LEDR[1]=Qb;
endmodule


