module shifter(SW, KEY, LEDR);
    input[9:0] SW;
    input[3:0] KEY;
    output[7:0] LEDR;

    shifterone s1(
        .load_val(SW[7:0]),
        .Q(LEDR[7:0]),
        .shift(KEY[2]),
        .load_n(KEY[1]),
        .clk(KEY[0]),
        .reset_n(SW[9]),
        .asr(KEY[3])
    );
endmodule

module shifterone(load_val, Q, shift, load_n, clk, reset_n, asr);
    input[7:0] load_val;
    input shift, load_n, clk, reset_n, asr;
    output[7:0] Q;

    reg left;

    always @(asr)
    begin 
        if (asr == 0)
            left <= 0;
        else
            left <= Q[0];
    end

    oneshifter o1(
        .load_val(load_val[7]),
        .load_n(load_n),
        .shift(shift),
        .clk(clk),
        .reset_n(reset_n),
        .in(left),
        .out(Q[7])
    );

    oneshifter o2(
        .load_val(load_val[6]),
        .load_n(load_n),
        .shift(shift),
        .clk(clk),
        .reset_n(reset_n),
        .in(Q[7]),
        .out(Q[6])
    );

    oneshifter o3(
        .load_val(load_val[5]),
        .load_n(load_n),
        .shift(shift),
        .clk(clk),
        .reset_n(reset_n),
        .in(Q[6]),
        .out(Q[5])
    );

    oneshifter o4(
        .load_val(load_val[4]),
        .load_n(load_n),
        .shift(shift),
        .clk(clk),
        .reset_n(reset_n),
        .in(Q[5]),
        .out(Q[4])
    );

    oneshifter o5(
        .load_val(load_val[3]),
        .load_n(load_n),
        .shift(shift),
        .clk(clk),
        .reset_n(reset_n),
        .in(Q[4]),
        .out(Q[3])
    );

    oneshifter o6(
        .load_val(load_val[2]),
        .load_n(load_n),
        .shift(shift),
        .clk(clk),
        .reset_n(reset_n),
        .in(Q[3]),
        .out(Q[2])
    );

    oneshifter o7(
        .load_val(load_val[1]),
        .load_n(load_n),
        .shift(shift),
        .clk(clk),
        .reset_n(reset_n),
        .in(Q[2]),
        .out(Q[1])
    );

    oneshifter o8(
        .load_val(load_val[0]),
        .load_n(load_n),
        .shift(shift),
        .clk(clk),
        .reset_n(reset_n),
        .in(Q[1]),
        .out(Q[0])
    );
endmodule


module oneshifter(load_val, load_n, shift, clk, reset_n, in, out);
    input in, load_val, load_n, shift, clk, reset_n;
    output out; 
    wire data_other_mux, data_to_diff;

    mux2to1 m1(
        .x(out),
        .y(in),
        .s(shift),
        .m(data_other_mux)
    );

    mux2to1 m2(
        .x(load_val),
        .y(data_other_mux),
        .s(load_n),
        .m(data_to_diff)
    );

    flipflop f0(
        .d(data_to_diff),
        .q(out),
        .clock(clk),
        .reset_n(reset_n)
    );
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

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;

endmodule   