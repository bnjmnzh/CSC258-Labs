module datapath(x_in, y_in, clock, resetn, done, enable, x_out, y_out);
	parameter [5:0] x_max;
	parameter [5:0] y_max;
	
	input [8:0] x_in;
	input [7:0] y_in;
	input clock;
	input resetn;
	input enable;
	output [8:0] x_out;
	output [7:0] y_out;
	output reg done;

	reg [6:0] i_x;
	reg [7:0] i_y;

	always @(posedge clock) begin
	
		if (!enable) begin
			i_x <= 0;
			i_y <= 0;
		end
		
		else begin
			
			if (i_x <= x_max) begin
				i_x <= i_x + 1;
				done <= 0;
				
			end else begin
				i_x <= 0;
				i_y <= i_y + 1;
		
				if (i_y == y_max) begin
					done <= 1;
					i_y <= 0;
				end else 
					done <= 0;
			end
		end
	end
	
	assign x_out = x_in + i_x;
	assign y_out = y_in + i_y;

endmodule