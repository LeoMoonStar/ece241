module BaseDefense
	(
	   SW,
		CLOCK_50,						//	On Board 50 MHz
		KEY,
		LEDR,
		PS2_CLK,
		PS2_DAT,
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

	input	CLOCK_50;//	50 MHz

   input [9:0]SW;	
	input [3:0]KEY;
	inout PS2_CLK;
	inout PS2_DAT;
	output [9:0]LEDR;
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

   wire clock;
	assign clock=CLOCK_50;
	wire [16:0] address;
	wire resetn;
	assign resetn = ~KEY[0];
	wire startgame;
	assign startgame=SW[0];
	assign LEDR[0]=startgame;
	/*connect a keyboard to the fpga board*/
	
	wire		[7:0]	ps2_key_data;
	wire				ps2_key_pressed;
	reg			[7:0]	last_data_received;
	always @(posedge CLOCK_50)
	begin
	if (KEY[0] == 1'b0)
		last_data_received <= 8'h00;
	else if (ps2_key_pressed == 1'b1)
		last_data_received <= ps2_key_data;
  end

	PS2_Controller PS2 (
	// Inputs
	.CLOCK_50				(CLOCK_50),
	.reset				(~KEY[0]),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.


//wire [9:0] backgroundAddress;

/*Geting memory from background rom */
  wire [2:0] colour;
  wire writeEn=1;
  wire[8:0]loading_x=counter_x;
  wire[7:0]loading_y=counter_y;
  reg[16:0] loadingAddress;
  wire [2:0] loadingDataOut;
	ld ld1(
	.address(loadingAddress),
	.clock(CLOCK_50),
	.q(loadingDataOut));

	vga_address_translator loadingtranslator(
	.x(loading_x),
	.y(loading_y),
	.mem_address(loadingAddress));


/*Geting memory from background rom */
	wire [8:0]background_x=counter_x;
	wire [7:0]background_y=counter_y;
	reg[16:0] backgroundAddress;
	wire [2:0]backgroundDataout;
   bg bg1(
	.address(backgroundAddress),
	.clock(CLOCK_50),
	.q(backgroundDataout));
	vga_address_translator bgtranslator(
	.x(background_x),
	.y(background_y),
	.mem_address(backgroundAddress));



	/*finite state machine for the whole game*/
	localparam  loadingState = 4'b0000,
	            gameState = 4'b0001;

	reg [3:0] currentState;
	reg [3:0] nextState;
   assign LEDR[1]=currentState[0];
	
	always@(posedge clock)
	begin
	case (currentState)
		loadingState:nextState=(startgame)?gameState:loadingState;
		gameState:nextState=(resetn||!startgame)?loadingState:gameState;
		default: nextState=loadingState;
	endcase
	end

	always @ ( posedge clock) begin
	currentState<=nextState;
	end

reg[8:0]counter_x;
reg[7:0]counter_y;


/*travel through the whole screen*/
always @ (posedge clock)
	begin
	counter_x<=9'd0;
			if (counter_x < 9'd320)
				counter_x <= counter_x + 1;
			else if (counter_x == 9'd320)
				counter_x <= 0;
			else
				counter_x <= counter_x;

	
	end

	always @ (posedge clock)
	begin
         counter_y<=8'd0;
			if (counter_y < 8'd240&&counter_x==9'd320)
				counter_y <= counter_y + 1;
			else if (counter_y == 8'd240&&counter_x==8'd0)
				counter_y <= 0;
			else
				counter_y <= counter_y;

	end

	wire[8:0]x;
	wire[7:0]y;
	reg[8:0] final_x;
	reg[7:0] final_y;
	reg[2:0] final_data;

always @ ( * ) begin
	case (currentState)
		loadingState:begin
		            final_x<=loading_x;
								final_y<=loading_y;
								final_data<=loadingDataOut;
								 end
	gameState:begin
	          final_x<=background_x;
						final_y<=background_y;
						final_data<=backgroundDataout; end
		default:begin
		        final_x<=9'd0;
            final_y<=8'd0;
            final_data<=3'b000;
		end
	endcase
end

	assign x=final_x;
	assign y=final_y;
	assign colour=final_data;


	vga_adapter VGA(
			.resetn(resetn||turnblack),
			.clock(clock),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "background.colour.mif";

	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.


endmodule
