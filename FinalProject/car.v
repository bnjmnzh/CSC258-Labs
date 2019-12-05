module car(clk, a, d, left_key, right_key, speed, can_move, car_x, reset, direction);

input clk, can_move, reset, a, d, left_key, right_key;
input [3:0] speed;
inout reg [8:0] car_x;

localparam 	none = 2'b00,
				left = 2'b01,
				right = 2'b10;
				
output reg [2:0] direction = none;

	always @(posedge clk) begin
	
		if (left_key ^ right_key ^ a ^ d) begin
			
			if (left_key || a)
				direction <= left;
				
			else if (right_key || d) 
				direction <= right;
				
			else
				direction <= none;
		end
				
	end
	
	always @(posedge clk) begin

		if (can_move == 1) begin // after erasing, control will give the can_move signal
			if (reset == 1)
				car_x <= 150;
			if (direction == left) begin
				if (car_x - speed >= 2)
					car_x <= car_x - speed;
					
			end else if (direction == right) begin
				if (car_x + speed <= 290)
					car_x <= car_x + speed;

			end 
		end
	end
endmodule 