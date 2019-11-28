module car(clk, left_key, right_key, speed, can_move, car_x, reset, direction);

input clk, left_key, right_key, can_move, reset;
input [3:0] speed;
inout reg [7:0] car_x;

localparam 	none = 2'b00,
				left = 2'b01,
				right = 2'b10;
				
output reg [2:0] direction = none;

	always @(posedge clk) begin
	
		if (left_key ^ right_key) begin
			
			if (left_key)
				direction <= left;
				
			else if (right_key) 
				direction <= right;
				
		end 
		
		else
			direction <= none;
		
	end
	
	always @(posedge clk) begin

		if (can_move == 1) begin // after erasing, control will give the can_move signal
			if (reset == 1)
				car_x <= 150;
			if (direction == left) begin
				if (car_x - speed >= 5)
					car_x <= car_x - speed;
					
			end else if (direction == right) begin
				if (car_x + speed <= 205)
					car_x <= car_x + speed;
					
			end 
		end
	end
endmodule