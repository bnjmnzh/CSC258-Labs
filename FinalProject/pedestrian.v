module pedestrian(clk, x, y, move_p, can_move, reset);
	input clk, reset;
	inout reg [7:0] x, y;
	output move_p;
	
	wire [6:0]random;
	
	fibonacci_lfsr_7bit rng(clk, reset, random);
	
	always @(posedge clk) begin
		if (reset) begin
			x <= random;
			y <= 0;
		end else
			if (can_move)
				y <= y + 1;
	end
		
endmodule