module FSM(clock,setx,black,plot,ResetN,ctlCommand);
input black;
input clock;
input setx;
input plot;
input ResetN;
output[2:0]ctlCommand;

reg [3:0]input_command;
always@(*)
begin
input_command[0]<=ResetN;//4'b0001  ResetN
input_command[1]<=plot;//4'b0010  save y value and plot
input_command[2]<=black;//4'b0100  set the entire screen to be black
input_command[3]<=setx;//4'b1000 save x value

end
localparam  s0   = 3'b000,// initial state,x=0,y=0
            s1   = 3'b001, // get x value
            //s2   = 3'b010,// clear x value & clear y value
            s3   = 3'b100,//get y value & plot
            s4   = 3'b101;//make the screen black again

reg [2:0] current_command;
reg [2:0] next_command;

always@(posedge clock)
begin
     case(current_command)
	  s0:begin
	        if(input_command==4'b1000)
			  next_command<=s1;
			  else if(input_command==4'b0100)
			  next_command<=s4;
		  end
	  s1:begin
	        if(input_command==4'b0010)
			  next_command<=s3;
			  else if(input_command==4'b0001)
			  next_command<=s0;
			  else if( input_command==4'b0100)
			  next_command<=s4;
		  end
	  s3:begin
	        if(input_command==4'b0001)
			  next_command<=s0;
			  else if(input_command==4'b0100)
			  next_command<=s4;
		  end
	  s4:begin
	        if(input_command==4'b0001)
			  next_command<=s0;
			  end
	default:current_command=s0;
	  endcase
	  
	  current_command<=next_command;
	  end
	  
	  assign ctlCommand=current_command;
	  
endmodule