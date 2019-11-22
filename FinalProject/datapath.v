module datapath(x_in, y_in, clock, resetn, done, enable_x, x_out, y_out);
	input [7:0] x_in;
	input [7:0] y_in;
	input clock;
	input resetn;
	input enable_x;
	output [7:0] x_out;
	output [7:0] y_out;
	output reg done;

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

	always @ (posedge clock) begin
       
        // Increment on enable signal.
        if (enable_x) begin
            if (i_x < 16) begin
                i_x <= i_x + 1;
            end else begin
                i_x <= 0;
                i_y <= y + 1;
            end
        end
 
        // Reset when no enable signal.
        if (!enable_x) begin
             i_x <= 0;
             i_y <= 0;
        end
 
        // Signal done when reached max.
        // MAX_X - 2 is so that the signal is high during the last (x, y).
        if (x == 15 && y == 46) begin
            done <= 1;
        end else begin
            done <= 0;
        end
 
    end
			
	
	assign x_out = x + i_x;
	assign y_out = y + i_y;
endmodule