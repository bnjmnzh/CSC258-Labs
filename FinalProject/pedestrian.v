module pedestrian(clk, x, y, move_p, can_move, reset, dead);
	input clk, reset, can_move;
	inout reg [8:0] x;
	inout reg [7:0] y;
	output reg move_p, dead;
	wire [8:0] random;
//	reg [1:0]tick = 2'b11;
	fibonacci_lfsr_9bit rng(clk, reset,random);

	
	always @(posedge clk) begin
		move_p <= 1;
		
//		tick <= tick - 1;
//		if (tick == 0)
//			tick <= 3;
		
		if (can_move) begin
			if (reset == 1 | dead == 1) begin
				x <= 20 + random;
				y <= 0;
				dead <= 0;
			end 
		
			else begin
				if (y > 240)
					dead <= 1;
				else  
					y <= y + 1;
			end
		end
	end
		
endmodule 