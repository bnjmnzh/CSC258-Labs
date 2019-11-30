module fibonacci_lfsr_7bit(
  input clk,
  input rst_n,

  output reg [8:0] data
);

reg [8:0] data_next;

always @(*) begin
  data_next[8] = data[8]^data[1];
  data_next[7] = data[7]^data[0];
  data_next[6] = data[6]^data[8];
  data_next[5] = data[5]^data[7];
  data_next[4] = data[4]^data[6];
  data_next[3] = data[3]^data[5];
  data_next[2] = data[2]^data_next[4];
  data_next[1] = data[1]^data_next[3];
  data_next[0] = data[0]^data_next[2];
end

always @(posedge clk or negedge rst_n)
  if(!rst_n)
    data <= 5'h1f;  
  else
    data <= data_next;

endmodule