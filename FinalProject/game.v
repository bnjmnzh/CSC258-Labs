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

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule