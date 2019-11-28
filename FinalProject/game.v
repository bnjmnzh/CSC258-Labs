module game(
		CLOCK_50, 
		KEY, 
		SW,
		VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B,
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
);

	input	CLOCK_50;
	input [9:0] SW;
	input [3:0] KEY;
	output VGA_CLK;   				//	VGA Clock
	output VGA_HS;					//	VGA H_SYNC
	output VGA_VS;					//	VGA V_SYNC
	output VGA_BLANK_N;				//	VGA BLANK
	output VGA_SYNC_N;				//	VGA SYNC
	output [9:0] VGA_R;   				//	VGA Red[9:0]
	output [9:0] VGA_G;	 				//	VGA Green[9:0]
	output [9:0] VGA_B;   				//	VGA Blue[9:0]
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;


	localparam colour_background = 3'b000;

	wire resetn, erase, done;
	assign resetn = !KEY[0];
	wire [2:0] colour;
	wire [2:0] colour_car;
	wire can_move;
	wire [7:0] car_x;
	wire [7:0] car_y = 190;
	wire [7:0] x_final;
	wire [7:0] y_final;
	wire [7:0] keyValue;
	wire tick;
	reg [31:0] tps = 600000;
	wire writeEn, enable, id_x, id_y;
	wire [2:0] state;
	wire [2:0] direction;

	hex_decoder h0(done,HEX0);
	hex_decoder h1(can_move,HEX1);
	hex_decoder h2(erase,HEX2);
	hex_decoder h3(state,HEX3);
	hex_decoder h4(direction,HEX4);
	hex_decoder h5(SW[1] + SW[0],HEX5);

//------------------------------------------------
// VGA 

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

//------------------------------------------------
// Instansiate FSM control

	control c0(
		.clock(tick),
		.reset(resetn),
		.erase(erase),
		.done(done),
		.en_vga(writeEn),
		.en_datapath(enable),
		.want_to_move(|direction), // since none = 0, if direction != none, then (|direction) = 1
		.can_move(can_move),
		.state(state)
	);

//------------------------------------------------	
// Instansiate datapath

	datapath d0(
		.x_in(car_x),
		.y_in(car_y),
		.clock(tick),
		.resetn(resetn),
		.done(done),
		.enable(enable),
		.x_out(x_final),
		.y_out(y_final)
	);
	
//------------------------------------------------
// Returns color of pixel in .mif for x,y coordinates

	sprite_ram #(
        .WIDTH_X(6),
        .WIDTH_Y(8),
        .RESOLUTION_X(27),
        .RESOLUTION_Y(48),
        .MIF_FILE("PixelCar.mif")
    ) car (
        .clk(tick),
        .x(x_final - car_x), .y(y_final - car_y),
        .color_out(colour_car)
    );

//------------------------------------------------
// SET TICK

	tick t0(CLOCK_50, tick, tps);
	
//------------------------------------------------
// CAR MOVEMENT
	
	car car0(.clk(tick),
				.left_key(!KEY[3]),
				.right_key(!KEY[2]),
				.speed(1),
				.can_move(can_move),
				.car_x(car_x),
				.reset(resetn),
				.direction(direction)
			);
	
//------------------------------------------------
// ASSIGN COLOR TO BE BLACK (ERASE) OR NOT
	
	assign colour = (erase == 1'b1) ? colour_background : colour_car;
	
//------------------------------------------------
// PEDESTRIAN (WIP)
// Image from http://pixelartmaker.com/art/c89ff395c379999
	
//	wire p0_x, p0_y;
//	
//	pedestrian p0(tick, p0_x, p0_y, resetn);
//	
//		datapath d1(
//		.x_in(p0_x),
//		.y_in(p0_y),
//		.clock(tick),
//		.resetn(resetn),
//		.done(done),
//		.enable(enable),
//		.x_out(x_final),
//		.y_out(y_final)
//	);
	
//------------------------------------------------

endmodule