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
	
	assign HEX0[0] = (~S[3] & ~S[2] & ~S[1] & S[0]) | (~S[3] & S[2] & ~S[1] & ~S[0]) | 
						  (S[3] & S[2] & ~S[1] & S[0]) | (S[3] & ~S[2] & S[1] & S[0]);
						  
	assign HEX0[1] =  (~S[3] & S[2] & ~S[1] & S[0]) | (S[2] & S[1] & ~S[0]) | 
							(S[3] & S[1] & S[0]) & (S[3] & S[2] & ~S[0]);
		
	assign HEX0[2] = (~S[3] & ~S[2] & S[1] & ~S[0]) | (S[3] & S[2] & S[1]) | (S[3] & S[2] & ~S[0]);
	
	assign HEX0[3] = (~S[3] & S[2] & ~S[1] & ~S[0]) | (S[3] & ~S[2] & S[1] & ~S[0]) | 
							(S[2] & S[1] & S[0]) | (~S[2] & ~S[1] & S[0]);
						  
	assign HEX0[4] = (~S[3] & S[0]) | (~S[3] & S[2] & ~S[1]) | (~S[2] & ~S[1] & S[0]);
	
	assign HEX0[5] = (S[3] & S[2] & ~S[1] & S[0]) | (~S[3] & ~S[2] & S[0]) | 
					     (~S[3] & S[1] & S[0]) | (~S[3] & ~S[2] & S[1]);
						
   assign HEX0[6] = (~S[3] & ~S[2] & ~S[1]) | (~S[3] & S[2] & S[1] & S[0]) | 
						  (S[3] & S[2] & ~S[1] & ~S[0]);
						
endmodule 