module game(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
      KEY,
      SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
		PS2_DAT,
		PS2_CLK
);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;
	input	PS2_DAT;
	input	PS2_CLK;

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
	output  [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;


	localparam none = 2'b00,
				  left = 2'b01,
				  right = 2'b10,
				  speed = 1,
				  colour_background = 3'b000;

	wire resetn, erase, done;
	assign resetn = !KEY[0];
	wire [2:0] colour;
	wire [2:0] colour_car;
	wire can_move;
	reg [4:0] car_x = 0;
	reg [5:0] car_y = 0;
	reg enable_y;
	reg [7:0] x_init = 8'b10100000;
	wire [7:0] y_init = 190;
	wire [7:0] x_final;
	wire [7:0] y_final;
	wire [7:0] keyValue;
	wire tick;
	reg [31:0] tps = 7000;
	wire writeEn, enable, id_x, id_y;
	reg [2:0] direction = none;
	wire [2:0] state;

	hex_decoder h0(done,HEX0);
	hex_decoder h1(can_move,HEX1);
	hex_decoder h2(erase,HEX2);
	hex_decoder h3(state,HEX3);

	 // Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(!resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x_final),
			.y(y_final),
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
		defparam VGA.BACKGROUND_IMAGE = "black.mif";


    // Instansiate FSM control

	control c0(
		.clock(tick),
		.reset(resetn),
		.erase(erase),
		.done(done),
		.en_vga(writeEn),
		.en_datapath(enable),
		.can_move(can_move),
		.state(state)
	);

	// Instansiate datapath
	// datapath d0(...);
	datapath d0(
		.x_in(x_init),
		.y_in(y_init),
		.clock(tick),
		.resetn(resetn),
		.done(done),
		.enable(enable),
		.x_out(x_final),
		.y_out(y_final)
	);
	
	// Returns color of pixel in .mif for x,y coordinates

	sprite_ram #(
        .WIDTH_X(6),
        .WIDTH_Y(8),
        .RESOLUTION_X(27),
        .RESOLUTION_Y(48),
        .MIF_FILE("PixelCar.mif")
    ) srm_frog (
        .clk(tick),
        .x(x_final - x_init), .y(y_final - y_init),
        .color_out(colour_car)
    );


//   keyboardController(CLOCK_50, PS2_DAT, PS2_CLK, keyValue);
	Tick(CLOCK_50, tick, tps);

	always @(posedge tick) begin
		if (!KEY[3] & direction != right) begin // left if not right
				direction <= left;
		end else if (!KEY[2] & direction != left) begin // Right if not left
				direction <= right;
		end else if (KEY[2] || KEY[3]) begin // No movement
				direction <= none;
		end
	end
	
	always @(posedge tick) begin

		if (can_move == 1) begin 
			if (direction == left) begin // Left
				if (x_init - speed >= 0)
					x_init <= x_init - speed;
				else x_init <= x_init;

			end else if (direction == right) begin// Right
				if (x_init + speed <= 293)
					x_init <= x_init + speed;
				else x_init <= x_init;

			end else if (direction == none) begin // No movement
			end
		end
	end
	
	assign colour = (erase == 1'b1) ? colour_background : colour_car;

endmodule

module Tick(Clk, tick, tps);
	output reg tick;
	input [31:0] tps; 
	input Clk;
	reg [26:0] clockcount;
	always@(posedge Clk)
	begin
		clockcount <= clockcount+1;
		if(clockcount >= 50000000/tps)
		begin
			tick  <= 1;
			clockcount <= 0;
		end
		else	
			tick <= 0;
	end
endmodule