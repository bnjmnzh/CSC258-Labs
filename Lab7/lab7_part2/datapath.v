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

	reg [7:0] x;
	reg [6:0] y;
	reg [2:0] colour;
	reg [3:0] i_x, i_y;
	reg enable_y;

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

	always @(posedge clock) begin
		if (!resetn)
			i_x <= 2'b0000;
		else if(enable_x) begin
			if(i_x == 2'b1111) begin
				i_x <= 2'b0000;
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
			i_y <= 2'b0000;
		else if(enable_y) begin
			if(i_y == 2'b1111)
				i_y <= 2'b0000;
			else 
				i_y <= i_y + 1;
		    end
	end

	assign x_out = x + i_x;
	assign y_out = y + i_y;
	assign colour_out = colour;
endmodule