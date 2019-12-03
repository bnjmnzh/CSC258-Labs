module pedestrian(clk, x, y, move_p, can_move, reset, dead);
	input clk, reset, can_move;
	inout reg [7:0] x, y;
	output reg move_p, dead;
	
	always @(posedge clk) begin
		if (reset) begin
			y <= 0;
			move_p <= 0;
			dead <= 0;
		end else
			if (can_move) begin
				move_p <= 1;
				if (y > 190) begin
					dead <= 1;
					y <= 0;
				end else begin 
					y <= y + 3;
					dead <= 0;
				end
			end
	end
		
endmodule