module game(
		CLOCK_50, 
		KEY, SW, LEDR,
		PS2_DAT, PS2_CLK, 
		VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B,
		HEX0, HEX1, HEX5,
);

	input	CLOCK_50;
	inout	PS2_DAT, PS2_CLK;
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
	output [6:0] HEX0, HEX1, HEX5;
	output [9:0] LEDR;


	localparam colour_background = 0;

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
	wire a1, a2, a3, a4;
	
	assign LEDR[1] = p1_y + 16 >= 190; // p_y2 > c_y1
	assign LEDR[2] = p1_y <= 237; // p_y1 < c_y2
	assign LEDR[3] = p1_x + 9 >= car_x; // p_x2 > c_x1
	assign LEDR[4] = p1_x <= car_x + 26;  // p_x1 < c_x2

	hex_decoder h1(score[4:0],HEX0);
	hex_decoder h2(score[7:4],HEX1);
	hex_decoder h5(p_speed, HEX5);

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
// Keyboard controller
//		
	wire a, d, left, right;
	
		 keyboard_tracker #(.PULSE_OR_HOLD(0)) tester(
	     .clock(CLOCK_50),
		  .reset(resetn),
		  .PS2_CLK(PS2_CLK),
		  .PS2_DAT(PS2_DAT),
		  .a(a),
		  .d(d),
		  .left(left),
		  .right(right),
		  );

//------------------------------------------------
// Instansiate FSM control
	reg [7:0] score;
	wire gameover, hit;
	reg [3:0] p_speed = 1;

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
		.car_x(car_x),
		.car_y(car_Y),
		.pedestrian_x(p1_x),
		.pedestrian_y(p1_y),
		.colour_car(colour_car), 
		.car_x_final(car_x_final), 
		.car_y_final(car_y_final),
		.en_car_counter(en_car_counter),
		.colour_pedestrian(colour_p1), 
		.pedestrian_x_final(p1_x_final), 
		.pedestrian_y_final(p1_y_final),
		.en_pedestrian_counter(en_pedestrian_counter),
		.x_final(x_final), 
		.y_final(y_final),
		.colour(colour),
		.gameover(gameover),
		.hit(hit)
	);
	
	always @(posedge tick) begin
		if (resetn == 1) begin
			score <= 0;
			p_speed <= 1;
		end else
			if (hit == 1) begin
				score <= score + 1;
				if (score % 4 == 0)
					if (p_speed < 7)
						p_speed <= p_speed + 1;
			end
	end
	
	
//------------------------------------------------
// SET TICK

	tick t0(CLOCK_50, tick, tps);
	
//------------------------------------------------
// CAR
	wire [8:0] car_x, car_x_final;
	wire [7:0] car_y = 190;
	wire [7:0] car_y_final;
	wire [2:0] colour_car;
	wire en_car_counter;
	wire car_done;
	
	car car0(
				.clk(tick),
				.a(a),
				.d(d),
				.left_key(left),
				.right_key(right),
				.speed(5),
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

	 counter #(
		.x_max(26),
		.y_max(47)
	) car_d(
		.x_in(car_x),
		.y_in(car_y),
		.clock(tick),
		.resetn(resetn),
		.done(car_done),
		.enable(en_car_counter),
		.x_out(car_x_final),
		.y_out(car_y_final)
	);
	
//------------------------------------------------
// PEDESTRIAN
	
	wire [8:0] p1_x, p1_x_final;
	wire [7:0] p1_y, p1_y_final;
	wire [2:0] colour_p1;
	wire move_p, en_pedestrian_counter, p1_done;
	
	pedestrian p1(
		.speed(p_speed),
		.clk(tick), 
		.x(p1_x), 
		.y(p1_y), 
		.move_p(move_p), 
		.hit(hit), 
		.can_move(can_move), 
		.reset(resetn)
		);

	  
	counter #(
		.x_max(9),
		.y_max(16)
	) ped1_d(
		.x_in(p1_x),
		.y_in(p1_y),
		.clock(tick),
		.resetn(resetn),
		.done(p1_done),
		.enable(en_pedestrian_counter),
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
        .x(p1_x_final - p1_x), .y(p1_y_final - p1_y),
        .color_out(colour_p1)
    );
	 
//------------------------------------------------

endmodule