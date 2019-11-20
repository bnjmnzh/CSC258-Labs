module game(
//	Clock Input
  input CLOCK_50,	//	50 MHz
// VGA
  output VGA_CLK,   						//	VGA Clock
  output VGA_HS,							//	VGA H_SYNC
  output VGA_VS,							//	VGA V_SYNC
  output VGA_BLANK,						//	VGA BLANK
  output VGA_SYNC,						//	VGA SYNC
  output [9:0] VGA_R,   						//	VGA Red[9:0]
  output [9:0] VGA_G,	 						//	VGA Green[9:0]
  output [9:0] VGA_B,    //	VGA Blue[9:0]
  input [3:0] KEY,
  input [17:0] SW,
  output  [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
  output  [8:0]  LEDG,  //  LED Green[8:0]
  output  [17:0]  LEDR,  //  LED Red[17:0]
 
  input	PS2_DAT,
  input	PS2_CLK
);
    wire [7:0] keyValue;
    wire tick;
    reg [31:0] tps = 32'd15;

    // always @(posedge tick) begin
    //     if (keyValue == )

    keyboardController(CLOCK_50, PS2_DAT, PS2_CLK, keyValue);

endmodule

module Tick(Clk, tick, tps);
	output reg tick;
	input [31:0] tps; 
	input Clk;
	reg [26:0] clockcount;
	always@(posedge Clk)
	begin
		clockcount <= clockcount+1;
		if(clockcount >= 50000000/tps)
		begin
			tick  <= 1;
			clockcount <= 0;
		end
		else	
			tick <= 0;
	end
endmodule
