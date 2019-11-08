// Part 2 skeleton

module part2
	(
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
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

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
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn, enable, id_x, id_y, id_c;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
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
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
	// datapath d0(...);
	datapath d0(
		.location_in(SW[6:0]),
		.colour_in(SW[9:7]),
		.clock(CLOCK_50),
		.resetn(resetn),
		.controlX(id_x),
		.controlY(id_y),
		.controlC(id_c),
		.enable_x(enable),
		.x_out(x),
		.y_out(y),
		.colour_out(colour)
	);

    // Instansiate FSM control
    // control c0(...);

module datapath(location_in, colour_in, clock, resetn, controlX, controlY, controlC, enable_x, x_out, y_out, colour_out);
	input [6:0] location_in;
	input [2:0] colour_in;
	input clock;
	input resetn;
	input enable_x;
	input controlX, controlY, controlC;
	output [7:0] x_out;
	output [6:0] y_out;

	reg [7:0] x;
	reg [6:0] y;
	reg [2:0] colour;
	reg [1:0] i_x, i_y;
	reg [1:0] enable_y;

	always @(posedge clock) begin
		if (!resetn) begin
			x <= 8'b0;
			y <= 7'b0;
			colour <= 3'b0;
		else begin
			if (controlX)
				x <= {1'b0, location_in};
			if (controlY)
				y <= location_in;
			if (controlC)
				colour <= colour_in;
		end
	end

	always @(posedge clock) begin
		if (!resetn)
			i_x <= 2'b00;
		else if(enable_x) begin
			if(i_x == 2'b11);
				i_x <= 2'b00;
				enable_y <= 1;
				end
			else begin
				i_x <= i_x + 1;
				enable_y <= 0;
			end
		end
	end

	always @(posedge clock) begin
		if (!resetn)
			i_y <= 2'b00;
		else if(enable_y) begin
			if(i_y == 2'b11);
				i_y <= 2'b00;
			else
				i_y <= i_y + 1;
		end
	end

	assign x_out = x + i_x;
	assign y_out = y + i_y;
	assign colour_out = colour;
endmodule
