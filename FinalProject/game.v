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
	wire can_move;
	wire [8:0] x_final;
	wire [7:0] y_final;
	wire [7:0] keyValue;
	wire tick;
	reg [31:0] tps = 100000;
	wire writeEn, enable, id_x, id_y;
	wire [2:0] state;
	wire [2:0] direction;

	
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

	control #(
		.colour_background(colour_background)
		) c0(
		.clock(tick),
		.reset(resetn),
		.erase(erase),
		.done(car_done | p1_done),
		.en_vga(writeEn),
		.want_to_move(| {direction, move_p}), // since none = 0, if direction != none, then (|direction) = 1, also triggers if move_p = 1
		.can_move(can_move),
		.state(state),
		.colour_car(colour_car), 
		.car_x_final(car_x_final), 
		.car_y_final(car_y_final),
		.en_car_datapath(en_car_datapath),
		.colour_pedestrian(colour_p1), 
		.pedestrian_x_final(p1_x_final), 
		.pedestrian_y_final(p1_y_final),
		.en_pedestrian_datapath(en_pedestrian_datapath),
		.x_final(x_final), 
		.y_final(y_final),
		.colour(colour)
	);
	
//------------------------------------------------
// SET TICK

	tick t0(CLOCK_50, tick, tps);
	
//------------------------------------------------
// CAR
	wire [8:0] car_x, car_x_final;
	wire [7:0] car_y = 190;
	wire [7:0] car_y_final;
	wire [2:0] colour_car;
	wire en_car_datapath;
	wire car_done;
	
	car car0(.clk(tick),
				.left_key(!KEY[3]),
				.right_key(!KEY[2]),
				.speed(2),
				.can_move(can_move),
				.car_x(car_x),
				.reset(resetn),
				.direction(direction)
			);
			
	sprite_ram #(
        .WIDTH_X(6),
        .WIDTH_Y(8),
        .RESOLUTION_X(27),
        .RESOLUTION_Y(48),
        .MIF_FILE("PixelCar.mif")
    ) car_sprite(
        .clk(tick),
        .x(car_x_final - car_x), .y(car_y_final - car_y),
        .color_out(colour_car)
    );

	 datapath #(
		.x_max(26),
		.y_max(47)
	) car_d(
		.x_in(car_x),
		.y_in(car_y),
		.clock(tick),
		.resetn(resetn),
		.done(car_done),
		.enable(en_car_datapath),
		.x_out(car_x_final),
		.y_out(car_y_final)
	);
	
//------------------------------------------------
// PEDESTRIAN (WIP)
	
	wire [8:0] p1_x, p1_x_final;
	wire [7:0] p1_y, p1_y_final;
	wire [2:0] p1_colour;
	wire move_p, en_pedestrian_datapath, p1_done, can_move_p, dead;
	
	wire [8:0]random;
	fibonacci_lfsr_8bit rng(tick, resetn, dead, random);
	
	pedestrian p1(tick, p1_x, p1_y, move_p, can_move, resetn, dead);
	
	hex_decoder h0(dead,HEX0);
	
	  
	datapath #(
		.x_max(9),
		.y_max(16)
	) ped1_d(
		.x_in(random),
		.y_in(p1_y),
		.clock(tick),
		.resetn(resetn),
		.done(p1_done),
		.enable(en_pedestrian_datapath),
		.x_out(p1_x_final),
		.y_out(p1_y_final)
	);
	
	sprite_ram #(
        .WIDTH_X(4),
        .WIDTH_Y(5),
        .RESOLUTION_X(10),
        .RESOLUTION_Y(17),
        .MIF_FILE("pedestrian.mif")
    ) p1_sprite(
        .clk(tick),
        .x(p1_x_final - random), .y(p1_y_final - p1_y),
        .color_out(colour_p1)
    );
	 
//------------------------------------------------

endmodule