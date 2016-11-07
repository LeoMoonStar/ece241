module datapath(

      clock,
      colour,
      plot,
      ResetN,
      datainput,
      ctlCommand,
      VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
		);
		
input clock;
input [2:0]colour;
input ResetN;
input plot;
input [6:0]datainput;
input [2:0]ctlCommand;

 
output			VGA_CLK;   				//	VGA Clock
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output			VGA_BLANK_N;				//	VGA BLANK
output			VGA_SYNC_N;				//	VGA SYNC
output	[9:0]	VGA_R;   				//	VGA Red[9:0]
output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

localparam  s0   = 3'b000,// initial state,x=0,y=0
            s1   = 3'b001, // get x value
            s3   = 3'b100,//get y value & plot
            s4   = 3'b101;//make the screen black again

vga_adapter VGA(
			     .resetn(resetn),
			     .clock(clock),
			     .colour(w3),
			     .x(w1),
			     .y(w2),
			     .plot(plot),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK)
			);
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
				
				
			
reg [3:0]counter;
wire [1:0]deltax=counter[3:2];
wire [1:0]deltay=counter[1:0];


always@(clock)
begin
if(counter<4'b1111)
counter=counter+4'b0001;
else if(counter=4'b1111)
counter=4'b0000;
end
end

wire [7:0]w1;
wire [6:0]w2;
wire [2:0]w3;
reg [7:0]x_location;
reg [6:0]y_location;				
reg [2:0]usingColour;
assign w1=x_location;
assign w2=y_location;
assign w3=usingColour;
				
always@(posedge clock)
begin
    case(ctlCommand)
	 s0:
	      begin
	        x_location<=8'b00000000;
	        y_location<=7'b0000000;
	      end
	 s1:
	     begin
		  x_location[7]=1'b0;
		  x_location[6:0]=datainput;
		  end
	 s3:
	     begin
		  usingColour<=colour;
		  x_location<=x_location+deltax;
		  y_location<=y_location+deltay;
		  end
	 s4:
	     begin
	     usingColour<=3'b000;
		
		  
		  
		  
		  end
	endcase
	end               
endmodule