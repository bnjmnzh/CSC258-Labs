module fibonacci_lfsr_8bit(
  input  clock,
  input  reset,
  input dead,
  
  output [8:0] data
);

	reg feedback;
	reg [8:0] random;
	
	initial
		random <= 8'b01100101;
	always @(*) begin
		 feedback <=  random[7] ^ (random[5] ^ (random[3] ^ (random[2] ^ random[0])));
	 end
	 
	assign data = (dead == 1) ? {random[7:0], feedback} : data ;

endmodule