module alu(LEDR, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input[7:0] SW; //A, B
    input[2:0] KEY;
    output[7:0] LEDR; //ALUout[7:0]
    output[6:0] HEX0; //A in hexa
    output[6:0] HEX1;
    output[6:0] HEX2; //B in hexa
    output[6:0] HEX3;
    output[6:0] HEX4; //ALUout[3:0]
    output[6:0] HEX5; //ALUout[7:4]

    //A+1 using adder
    wire[3:0] case0;
    wire case01;
    ripple r0(
        .A(SW[7:4]),
        .B(4'b0001),
        .cin(1'b0),
        .s(case0),
        .cout(case01)
    );

    //A+B using adder
    wire[3:0] case1;
    wire case11;
    ripple r1(
        .A(SW[7:4]),
        .B(SW[3:0]),
        .cin(1'b0),
        .s(case1),
        .cout(case11)
    );

    //A+B using + operator
    wire[3:0] case2;
    wire[3:0] case21;
    add r2(
        .A(SW[7:4]),
        .B(SW[3:0]),
        .res(case2),
        .overflow(case21)
    );

    //A xor B in lower and A or B in upper
    wire[7:0] case3;
    orxor r3(
        .A(SW[7:4]),
        .B(SW[3:0]),
        .res(case3)
    );

    //Output 1 or 0 using reduction OR operator
    wire[7:0] case4;
    reduc r4(
        .A(SW[7:4]),
        .B(SW[3:0]),
        .res(case4)
    );

    //A most significant, B least significant
    wire[7:0] case5;
    concat r5(
        .A(SW[7:4]),
        .B(SW[3:0]),
        .res(case5)
    );

    reg[7:0] Out;

    always @(*)
    begin
        case(KEY[2:0])
            3'b000: Out = {case01, case0};
            3'b000: Out = {case11, case1};
            3'b000: Out = {case21, case2};
            3'b000: Out = case3;
            3'b000: Out = case4;
            3'b000: Out = case5;
            default: Out = 8'b00000000;
        endcase
    end

    assign LEDR = Out;

    seven_seg r6(
        .SW(SW[3:0]),
        .display(HEX0[6:0])
    );

    seven_seg r7(
        .SW(SW[7:4]),
        .display(HEX2[6:0])
    );

    seven_seg r8(
        .SW(Out[3:0]),
        .display(HEX4[6:0])
    );

    seven_seg r9(
        .SW(Out[7:4]),
        .display(HEX5[6:0])
    );

    assign HEX1[6:0] = 7'b0000000;
	assign HEX3[6:0] = 7'b0000000;

endmodule

//A+B using + operator
module add(A, B, res, overflow);
    input[3:0] A;
    input[3:0] B;
    output[3:0] overflow;
    output[3:0] res;

    assign res[3:0] = A + B;
    assign overflow[3:0] = 4'b0000;

endmodule

//A xor B in lower and A or B in upper
module orxor(A, B, res);
    input[3:0] A;
    input[3:0] B;
    output[7:0] res;

    assign res[7:4] = A|B;
    assign res[3:0] = A^B;

endmodule

//A most significant, B least significant
module concat(A, B, res);
    input[3:0] A;
    input[3:0] B;
    output[7:0] res;

    assign res[7:0] = {A, B};

endmodule 


//Output 1 or 0 using reduction OR operator
module reduc(A, B, res);
    input[3:0] A;
    input[3:0] B;
    output[7:0] res;

    assign res[7:1] = 7'b0000000;
    assign res[0] = | {A, B};

endmodule

module ripple(A, B, cin, s, cout);
    input[3:0] A;
    input[3:0] B;
    input cin;
    output[3:0] s;
    output cout;

    wire c1, c2, c3;

    full_adder f1(
        .sum(s[0]),
        .cout(c1),
        .A(A[0]),
        .B(B[0]),
        .cin(cin)
    );

    full_adder f2(
        .sum(s[1]),
        .cout(c2),
        .A(A[1]),
        .B(B[1]),
        .cin(c1)
    );

    full_adder f3(
        .sum(s[2]),
        .cout(c3),
        .A(A[2]),
        .B(B[2]),
        .cin(c2)
    );

    full_adder f4(
        .sum(s[3]),
        .cout(cout),
        .A(A[3]),
        .B(B[3]),
        .cin(c3)
    );

endmodule

module full_adder(sum, cout, A, B, cin);
    input A, B, cin;
    output sum, cout;

    assign sum = A^B^cin;
    assign cout = (A&B) | (A&cin) | (B&cin);

endmodule

module seven_seg(SW, display);
	input [3:0] SW;
 	output [6:0] display;
	
	assign display[0] = (~SW[0] & SW[1] & ~SW[2] & ~SW[3]) | 
					     (SW[0] & ~SW[1] & SW[2] & SW[3]) | 
						  (SW[0] & SW[1] & ~SW[2] & SW[3]) | 
						  (~SW[0] & ~SW[1] & ~SW[2] & SW[3]);
						  
	assign display[1] = (SW[0] & SW[2] & SW[3]) | 
						  (SW[0] & SW[1] & ~SW[3]) | 
						  (SW[1] & SW[2] & ~SW[3]) | 
						  (~SW[0] & SW[1] & ~SW[2] & SW[3]);
	
	assign display[2] = (~SW[0] & ~SW[1] & SW[2] & ~SW[3]) | 
						  (SW[0] & SW[1] & ~SW[3]) | 
						  (SW[0] & SW[1] & SW[2]);
	
	assign display[3] = (~SW[1] & ~SW[2] & SW[3]) | 
						  (SW[0] & ~SW[1] & SW[2] & ~SW[3]) | 
						  (SW[1] & SW[2] & SW[3]) | 
						  (~SW[0] & SW[1] & ~SW[2] & ~SW[3]);
						  
	assign display[4] = (~SW[0] & ~SW[1] & SW[3]) | 
						  (~SW[1] & ~SW[2] & SW[3]) | 
						  (~SW[0] & SW[1] & ~SW[2]) | 
						  (~SW[0] & SW[1] & SW[3]);
						  
	assign display[5] = (~SW[0] & ~SW[1] & SW[2]) | 
						  (~SW[0] & ~SW[1] & SW[3]) | 
						  (~SW[0] & SW[2] & SW[3]) | 
						  (SW[0] & SW[1] & ~SW[2] & SW[3]);
						  
	assign display[6] = (~SW[0] & ~SW[1] & ~SW[2]) | 
						  (SW[0] & SW[1] & ~SW[2] & ~SW[3]) | 
						  (~SW[0] & SW[1] & SW[2] & SW[3]);
endmodule 