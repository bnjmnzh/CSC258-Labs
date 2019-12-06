module fibonacci_lfsr_9bit(
  input  clock,
  input  reset,
  
  output reg [7:0] data
);
	
	reg [7:0] data_next;
	//LFSR feedback bit
	wire feedback;
	assign feedback = data_next[7] ^ data_next[5] ^ data_next[4] ^ data_next[3];

	always @(posedge clock or posedge reset) begin
		if (reset == 1) begin
			data_next[7:0] <= 8'h1F;
		end else begin
			data_next <= {data_next[6:0], feedback};
		end
	end

	always @(posedge clock)
	  if(reset)
		 data <= 7'h1F;
	  else
		 data <= data_next;

endmodule 