module alureg(SW, LEDR, KEY, HEX0, HEX4, HEX5);
    input [9:0]SW;
    input [2:0]KEY;
    output [7:0]LEDR;
    output [6:0] HEX0, HEX4, HEX5;
    wire [7:0]regout;

    seven_seg s0(
        .HEX(HEX0),
        .s(SW[3:0])
    );
    seven_seg s4(
        .HEX(HEX4), 
        .s(regout[3:0])
    );
    seven_seg s5(
        .HEX(HEX5),
        .s(regout[7:4])
    );

    alu a0(.A(SW[3:0]),
        .B(regout[3:0]),
        .out(LEDR[7:0]),
        .func(SW[7:5])
        );

    flipflop re(.d(LEDR[7:0]),
                .clock(KEY[0]),
                .reset_n(SW[9]),
                .q(regout));
endmodule

module alu(A, B, out, func);
    input[3:0] A, B;
    input[2:0] func;
    output[7:0] out;
    wire [7:0]case0, case1, case2, case3, case4, case5;

    ripple r0(
        .in({4'b0001, A[3:0]}),
        .out(case0)
    );

    ripple r1(
        .in({A[3:0],B[3:0]}),
        .out(case1)
    );

    reg [7:0]ALUout;
    assign out[7:0] = ALUout[7:0];

    always @(*)
    begin
	case (func)
		0: ALUout = case0;
		1: ALUout = case1;
		2: ALUout = A + B;
		3: ALUout = { (A | B), (A ^ B) };
		4: ALUout = {{7'b0000000},(|{A,B})};
		5: ALUout = B << A;
		6: ALUout = B >> A;
		7: ALUout = A * B;
		default: ALUout = 0;
    	endcase
    end
endmodule

module flipflop(d, clock, reset_n, q);
    input[7:0] d;
    input clock;
    input reset_n;

    output reg[7:0] q;

    always @(posedge clock)
    begin
        if (reset_n == 1'b0)
            q <= 0;
        else
            q <= d;
    end
endmodule

module ripple(in, out);
	input [9:0] in;
	output [7:0] out;

	wire [2:0] c;

	fulladder fa1(
				.x(in[0]),
				.y(in[4]),
				.cin(in[8]),
				.cout(c[0]),
				.s(out[0])
				);

	fulladder fa2(
				.x(in[1]),
				.y(in[5]),
				.cin(c[0]),
				.cout(c[1]),
				.s(out[1])
				);

	fulladder fa3(
				.x(in[2]),
				.y(in[6]),
				.cin(c[1]),
				.cout(c[2]),
				.s(out[2])
				);

	fulladder fa4(
				.x(in[3]),
				.y(in[7]),
				.cin(c[2]),
				.cout(out[4]),
				.s(out[3])
				);

endmodule

module fulladder(x, y, cin, cout, s);
    input x,y, cin;
    output cout,s;

	assign cout = (x&y) | (x&cin) | (y&cin);
	assign s = x^y^cin;
endmodule

module seven_seg(HEX, s);
    input [3:0] s;
    output [6:0] HEX;

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