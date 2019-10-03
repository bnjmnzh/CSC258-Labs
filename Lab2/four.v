//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

//module mux(LEDR, SW);
//    input [9:0] SW;
//    output [9:0] LEDR;
//
//    mux2to1 u0(
//        .x(SW[0]),
//        .y(SW[1]),
//        .s(SW[9]),
//        .m(LEDR[0])
//        );
//endmodule

// 4-to-1

module mux4(LEDR, SW);
	input [9:0] SW;
	output [9:0] LEDR;

	mux4to1 u0(
		.v(SW[0]),
		.u(SW[1]),
		.x(SW[2]),
		.y(SW[3]),
		.s1(SW[8]),
		.s2(SW[9]),
		.m(LEDR[0])
	);
endmodule 

module mux4to1(v, u, x, y, s1, s2, m);
	input v;
	input u;
	input x;
	input y;
	input s1;
	input s2;
	output m;
	wire first, second;
	
	mux2to1 u0(
		.x(v),
		.y(u),
		.s(s1),
		.m(first)
	);
	
	mux2to1 u1(
		.x(x),
		.y(y),
		.s(s1),
		.m(second)
	);
	
	mux2to1 u2(
		.x(first),
		.y(second),
		.s(s2),
		.m(m)
	);
	
endmodule 


module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;

endmodule
