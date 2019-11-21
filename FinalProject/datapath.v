module datapath(x_in, y_in, clock, resetn, enable_x, x_out, y_out);
	input [7:0] x_in;
	input [7:0] y_in;
	input clock;
	input resetn;
	input enable_x;
	output [7:0] x_out;
	output [7:0] y_out;

	reg [7:0] x;
	reg [6:0] y;
	reg [6:0] i_x;
	reg [7:0] i_y;
	reg enable_y;

	always @(posedge clock) begin 
		if(!resetn) begin
			x <= 8'b00000000;
			y <= 8'b00000000;
		end
		else begin
				x <= x_in;
				y <= y_in;
		end
	end

	always @(posedge clock) begin
		if (!resetn)
			i_x <= 0;
		else if(enable_x) begin
			if(i_x == 27) begin
				i_x <= 0;
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
			i_y <= 0;
		else if(enable_y) begin
			if(i_y == 48)
				i_y <= 0;
			else 
				i_y <= i_y + 1;
		    end
	end
	
	assign x_out = x + i_x;
	assign y_out = y + i_y;
endmodule