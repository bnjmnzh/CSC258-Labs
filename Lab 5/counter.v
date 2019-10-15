module counter(SW, KEY, HEX0, HEX1);
    input[2:0] KEY;
    input[1:0] SW;
    output[6:0] HEX0, HEX1;
    wire[7:0] w1;

    count c1(
        .enable(SW[1]),
        .clock(KEY[0]),
        .clear(SW[0]),
        .Q(w1)
    );
    
endmodule

module count(enable, clock, clear, Q);
    input enable, clock, clear;
    output[7:0] Q;
    wire w1, w2, w3, w4, w5, w6, w7;

    flipflop f0(
        .clock(clock),
        .clear(clear),
        .T(enable),
        .q(Q[0])
    );

    assign w1 = enable & Q[0];

    flipflop f1(
        .clock(clock),
        .clear(clear),
        .T(w1),
        .q(Q[1])
    );

    assign w2 = enable & Q[1];

    flipflop f2(
        .clock(clock),
        .clear(clear),
        .T(w2),
        .q(Q[2])
    );

    assign w3 = enable & Q[2];

    flipflop f3(
        .clock(clock),
        .clear(clear),
        .T(w3),
        .q(Q[3])
    );

    assign w4 = enable & Q[3];

    flipflop f4(
        .clock(clock),
        .clear(clear),
        .T(w4),
        .q(Q[4])
    );

    assign w5 = enable & Q[4];

    flipflop f5(
        .clock(clock),
        .clear(clear),
        .T(w5),
        .q(Q[5])
    );

    assign w6 = enable & Q[5];

    flipflop f6(
        .clock(clock),
        .clear(clear),
        .T(w6),
        .q(Q[6])
    );

    assign w7 = enable & Q[6];

    flipflop f7(
        .clock(clock),
        .clear(clear),
        .T(w7),
        .q(Q[7])
    );
endmodule


module flipflop(clock, clear, T, q);
    input clock, clear, T;
    output q;
    reg q;

    always @(posedge clock, negedge clear)
    begin
        if(~clear)
            q <= 1'b0;
        else
            q <= q ^ T;
    end
endmodule


module HEX(S,H);
    input [3:0]S;
    output [6:0]H;
   
    assign H[0]=(~S[3]&~S[2]&~S[1]&S[0]) |
                (~S[3]&S[2]&~S[1]&~S[0])|
                (S[3]&~S[2]&S[1]&S[0])|
                (S[3]&S[2]&~S[1]&S[0]);
    assign H[1]=(~S[3]&S[2]&~S[1]&S[0])|(S[3]&S[1]&S[0])|(S[2]&S[1]&~S[0])|(S[3]&S[2]&~S[0]);
    assign H[2]=(~S[3]&~S[2]&S[1]&~S[0])|(S[3]&S[2]&S[1])|(S[3]&S[2]&~S[0]);
    assign H[3]=(~S[3]&S[2]&~S[1]&~S[0])|(S[3]&~S[2]&S[1]&~S[0])|(S[2]&S[1]&S[0])|(~S[2]&~S[1]&S[0]);
    assign H[4]=(~S[3]&S[0])|(~S[2]&~S[1]&S[0])|(~S[3]&S[2]&~S[1]);
    assign H[5]=(S[3]&S[2]&~S[1]&S[0])|(~S[3]&S[1]&S[0])|(~S[3]&~S[2]&S[0])|(~S[3]&~S[2]&S[1]);
    assign H[6]=(S[3]&S[2]&~S[1]&~S[0])|(~S[3]&S[2]&S[1]&S[0])|(~S[3]&~S[2]&~S[1]);
endmodule

