module FSM(clock,setx,black,plot,ResetN,ControlA,ControlB,ControlC,plotOut);
input black;
input clock;
input setx;
input plot;
input ResetN;
output ControlA;
output ControlB;
output ControlC;
output plotOut;


localparam  s0   = 3'b000,// initial state
            s1   = 3'b001, // get x value
            s2   = 3'b010,// clear x value & clear y value
            s3   = 3'b100,//get y value & plot
            s4   = 3'b101,//make the screen black again

reg [2:0] current_command,next_command;
current_command=s0
always@(posdge clock)
begin
     case(current_command)
	  s0:next_command=setx?s








endmodule