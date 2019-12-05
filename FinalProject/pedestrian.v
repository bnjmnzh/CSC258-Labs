module pedestrian(clk, x, y, move_p, hit, can_move, reset);
	input clk, reset, can_move, hit;
	inout reg [8:0] x;
	inout reg [7:0] y;
	output reg move_p;
	wire [8:0] random;
	reg [1:0]tick = 2'b11;
	fibonacci_lfsr_9bit rng(clk, reset,random);

	
	always @(posedge clk) begin
		if (reset == 1) begin
			y <= 0;
			move_p <= 0;
		end else begin
		
			move_p <= 1;
			
			if (can_move) begin
				if (hit == 1) begin
					y <= 0;
					x <= 20 + random;
				end else begin
					if (y == 239)
						y <= 0;
					else
						y <= y + 1;
				end
			end
		end
	end
		
endmodule 