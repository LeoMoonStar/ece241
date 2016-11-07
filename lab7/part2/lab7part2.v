module lab7part2(
      CLOCK_50,						//	On Board 50 MHz
		KEY,
		SW,
		// Your inputs and outputs here
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);
   input CLOCK_50;     //50HZ
   input [3:0]KEY;
   input [9:0]SW;
   output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]



	
	wire plot=KEY[1];

	wire BLACK=KEY[2];

	wire Restn=KEY[0];
	wire setx=KEY[3];

	wire [6:0]data_input=SW[6:0];

	wire[2:0]colour=SW[9:7];
	wire[2:0]ctlCommand;
	
	FSM fsm(
	.clock(clock),
	.setx(setx),
	.black(BLACK),
	.plot(plot),
	.ResetN(RestN),
	.ctlCommand(ctlCommand)
	);
	
	datapath p1(
	   .clock(clock),
      .colour(colour),
      .plot(plot),
      .ResetN(ResetN),
      .datainput(data_input),
      .ctlCommand(ctlCommand),
      .VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK(VGA_BLANK_N),
		.VGA_SYNC(VGA_SYNC_N),
		.VGA_CLK(VGA_CLK)
		);
	endmodule
	
	


