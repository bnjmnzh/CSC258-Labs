//SW[7:4] A inputs
//SW[3:0] B inputs
//SW[8] Carry in
//LEDR[4] S output
//LEDR[3:0] Carry out

module ripple(LEDR, SW);
    input[9:0] SW;
    output[9:0] LEDR;
    wire c1, c2, c3;

    full_adder m1(
        .S(LEDR[0]),
        .cout(c1),
        .A(SW[4]),
        .B(SW[0]),
        .cin(SW[8])
    );

    full_adder m2(
        .S(LEDR[1]),
        .cout(c2),
        .A(SW[5]),
        .B(SW[1]),
        .cin(c1)
    );

    full_adder m3(
        .S(LEDR[2]),
        .cout(c3),
        .A(SW[6]),
        .B(SW[2]),
        .cin(c2)
    );

    full_adder m4(
        .S(LEDR[3]),
        .cout(LEDR[4]),
        .A(SW[7]),
        .B(SW[3]),
        .cin(c3)
    );

endmodule

module full_adder(S, cout, A, B, cin);
    input A, B, cin;
    output S, cout;

    assign S = A^B^cin;
    assign cout = (A&B) | (A&cin) | (B&cin);

endmodule

