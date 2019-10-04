module decode(HEX0, SW);
	input[9:0]SW;
	output[6:0]HEX0;
	
	seven_seg s1(
		.S(SW[3:0]),
		.HEX0(HEX0[6:0])
		);
endmodule

module seven_seg(S, HEX0);
	input [3:0]S;
 	output [6:0]HEX0;
	
	// 3 = A, 2 = B, 1 = C, 0 = D
	
	assign HEX[0] = ~s[3] & ~s[2] & ~s[1] & s[0] |
					~s[3] & s[2] & ~s[1] & ~s[0] |
					s[3] & ~s[2] & s[1] & s[0] |
					s[3] & s[2] & ~s[1] & s[0] ;


	assign HEX[1] = ~s[3] & s[2] & ~s[1] & s[0] |
					s[2] & s[1] & ~s[0] |
					s[3] & s[2] & ~s[0] |
					s[3] & s[1] & s[0] ;

	assign HEX[2] = ~s[3] & ~s[2] & s[1] & ~s[0] |
					s[3] & s[2] & ~s[0] |
					s[3] & s[1] & s[0] ;


	assign HEX[3] = ~s[2] & ~s[1] & s[0] |
					s[2] & s[1] & s[0] |
					~s[3] & s[2] & ~s[1] & ~s[0] |
					s[3] & ~s[2] & s[1] & ~s[0] ;


	assign HEX[4] = ~s[2] & ~s[1] & s[0] |
					~s[3] & s[1] & s[0] |
					~s[3] & s[2] & ~s[1] ;


	assign HEX[5] = ~s[3] & ~s[2] & s[0] |
					~s[3] & ~s[2] & s[1] |
					~s[3] & s[1] & s[0] |
					s[3] & s[2] & ~s[1] & s[0] ;


	assign HEX[6] = ~s[3] & ~s[2] & ~s[1] |
					~s[3] & s[2] & s[1] & s[0] |
					s[3] & s[2] & ~s[1] & ~s[0] ;
						
endmodule 