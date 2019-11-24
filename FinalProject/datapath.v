module datapath(x_in, y_in, clock, resetn, done, enable, x_out, y_out);
	input [7:0] x_in;
	input [7:0] y_in;
	input clock;
	input resetn;
	input enable;
	output [7:0] x_out;
	output [7:0] y_out;
	output reg done;

	reg [6:0] i_x;
	reg [7:0] i_y;

	always @ (posedge clock) begin
	
			// Reset when no enable signal.
        if (!enable || resetn) begin
             i_x <= 0;
             i_y <= 0;
        end
       
        // Increment on enable signal.
        if (enable) begin
            if (i_x < 27) begin
                i_x <= i_x + 1;
            end else begin
                i_x <= 0;
                i_y <= i_y + 1;
            end
        end
 
        // Signal done when reached max.
        // MAX_X - 2 is so that the signal is high during the last (x, y).
        if (i_x == 27 && i_y == 48) begin
            done <= 1;
        end else begin
            done <= 0;
        end
 
    end
			
	
	assign x_out = x_in + i_x;
	assign y_out = y_in + i_y;
endmodule