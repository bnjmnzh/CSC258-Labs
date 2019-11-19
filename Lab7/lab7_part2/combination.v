module combination(clock, resetn, load, go, colour_in, location, x_out, y_out, colour_out);
    input clock, resetn, load, go;
    input [2:0] colour_in;
    input [6:0] location;
    output [7:0] x_out;
    output [6:0] y_out;
    output [2:0] colour_out;
    wire controlX, controlY, controlC, writeEn, enable_x;

    control c0(
        .clock(clock),
        .resetn(resetn),
        .load(load),
        .go(go),
        .controlX(controlX),
        .controlY(controlY),
        .controlC(controlC),
        .writeEn(writeEn),
        .enable_x(enable_x)
    );

    datapath d0(
        .location_in(location),
        .colour_in(colour_in),
        .clock(clock),
        .resetn(resetn),
        .controlX(controlX),
        .controlY(controlY),
        .controlC(controlC),
        .enable_x(enable_x),
        .x_out(x_out),
        .y_out(y_out),
        .colour_out(colour_out)
    );
endmodule

module control(clock, resetn, load, go, controlX, controlY, controlC, writeEn, enable_x);
    input clock, resetn, load, go;
    output reg controlC, controlX, controlY, writeEn, enable_x;
    reg [2:0] curr, next;

    localparam  LOAD_X = 3'b000,
                LOAD_X_WAIT = 3'b001,
                LOAD_Y = 3'b010,
                LOAD_Y_WAIT = 3'b011,
                PLOT = 3'b100;

    // Current state registers
    always @(posedge clock) begin
        if(!resetn)
            curr <= LOAD_X;
        else
            curr <= next; 
    end
    // State Table
    always @(*)
    begin: state_table
        case (curr)
            LOAD_X: next = load ? LOAD_X_WAIT : LOAD_X; // load load if load is high, otherwise load from LOAD_X
            LOAD_X_WAIT: next = load ? LOAD_X_WAIT : LOAD_Y; //load load if load is high, otherwise load from LOAD_Y
            LOAD_Y: next = go ? LOAD_Y_WAIT : LOAD_Y; // load go if go is high, otherwise load from LOAD_Y
            LOAD_Y_WAIT: next = go ? LOAD_Y_WAIT :  PLOT; // load go if go is high, eitherwise load PLOT
            PLOT: next = load ? LOAD_X : PLOT; // load load if load is high, otherwise load PLOT
            default: next = LOAD_X;
        endcase
    end
    
    always @(*)
    begin
        controlX = 1'b0;
        controlY = 1'b0;
        controlC = 1'b0;
        writeEn = 0;
        case (curr)
            LOAD_X: begin
                controlX = 1;
                enable_x = 1;
                end
            LOAD_X_WAIT: controlX = 1;
            LOAD_Y: 
                begin
                    controlX = 0;
                    controlY = 1;
                    controlC = 1;
                end
            LOAD_Y_WAIT:
                begin
                    controlX = 0;
                    controlY = 1;
                    controlC = 1;
                end
            PLOT: writeEn = 1;
        endcase
    end
endmodule

module datapath(location_in, colour_in, clock, resetn, controlX, controlY, controlC, enable_x, x_out, y_out, colour_out);
	input [6:0] location_in;
	input [2:0] colour_in;
	input clock;
	input resetn;
	input enable_x;
	input controlX, controlY, controlC;
	output [7:0] x_out;
	output [6:0] y_out;
    output [2:0] colour_out;

    // Input registers
	reg [7:0] x;
	reg [6:0] y;
	reg [2:0] colour;


	reg [3:0] i_x, i_y;
	reg enable_y;

    // X, Y, C registers
	always @(posedge clock) begin 
		if(!resetn) begin
			x <= 8'b0;
			y <= 7'b0;
			colour <= 3'b0;
		end
		else begin
			if (controlX)
				x <= {1'b0, location_in};
			if (controlY)
				y <= location_in;
			if (controlC)
				colour <= colour_in;
		end
	end

    // Inccrement x
	always @(posedge clock) begin
		if (!resetn)
			i_x <= 4'b0000;
		else if(enable_x) begin
			if(i_x == 4'b1111) begin
				i_x <= 4'b0000;
				enable_y <= 1;
			    end
			else begin
				i_x <= i_x + 1;
				enable_y <= 0;
			    end
		    end
	end

    // Inccrement y
	always @(posedge clock) begin
		if (!resetn)
			i_y <= 4'b0000;
		else if(enable_y) begin
			if(i_y == 4'b1111)
				i_y <= 4'b0000;
			else 
				i_y <= i_y + 1;
		    end
	end

	assign x_out = x + i_x;
	assign y_out = y + i_y;
	assign colour_out = colour;
endmodule