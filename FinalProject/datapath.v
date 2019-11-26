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
	reg [7:0] x, y;
	reg enable_y; 

//	always @ (posedge clock) begin
//	
//			// Reset when no enable signal.
//        if (!enable || resetn) begin
//             i_x <= 0;
//             i_y <= 0;
//        end
//       
//        // Increment on enable signal.
//        if (enable) begin
//            if (i_x < 27) begin
//                i_x <= i_x + 1;
//            end else begin
//                i_x <= 0;
//                i_y <= i_y + 1;
//            end
//        end
// 
//        // Signal done when reached max.
//        // MAX_X - 2 is so that the signal is high during the last (x, y).
//        if (i_x == 27 && i_y == 48) begin
//            done <= 1;
//        end else begin
//            done <= 0;
//        end
// 
//    end
	always @(posedge clock) begin
		if (!enable) begin
			x <= 8'b10100000;
			y <= 190;
		end else begin
			x <= x_in;
			y <= y_in;
		end
	end

	always @(posedge clock) begin
		if (!enable)
			i_x <= 0;
		else if (enable) begin
			if (i_x == 26) begin
				i_x <= 0;
				enable_y <= 1;
			end else begin
				i_x <= i_x + 1;
				enable_y <= 0;
			end
		end
	end
			
	always @(posedge clock) begin
		if (!enable)
			i_y <= 0;
		else if (enable_y) begin
			if (i_y == 47) begin
				i_y <= 0;
			end else
				i_y <= i_y + 1;
		end
		
		if (i_x == 26 && i_y == 47)
			done <= 1;
		else
			done <= 0;
		
	end
	
//	assign x_out = x_in + i_x;
//	assign y_out = y_in + i_y;
	
	assign x_out = x + i_x;
	assign y_out = y + i_y;
endmodule