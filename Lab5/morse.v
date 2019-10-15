module morse(SW, KEY, LEDR, CLOCK_50);
    input[1:0] KEY;
    input[2:0] SW;
    input CLOCK_50;
    output[1:0] LEDR;
    wire[15:0] table_out;
    wire[31:0] rate_out;
    wire shifter_enable;
    wire[31:0] period;

    assign period = 25000000;
    assign shifter_enable = (rate_out == 0) ? 1 : 0;

    lutable u0(
        .letter(SW[2:0]),
        .morse(table_out)
    );

    ratedivider u1(
        .clock(CLOCK_50),
        .period(period),
        .reset_n(KEY[0]),
        .q(rate_out)
    );

    shifter u2(
        .clock(CLOCK_50),
        .enable(shifter_enable),
        .load(KEY[1]),
        .reset(~KEY[0]),
        .data(table_out),
        .out(LEDR[0])
    );
endmodule

module lutable(letter, morse);
    input[2:0] letter;
    output reg [15:0] morse;

    always @(*)
    begin
        case(letter)
            3'b000: morse = 16'b1010100000000000;
            3'b001: morse = 16'b1110000000000000;
            3'b010: morse = 16'b1010111000000000;
            3'b011: morse = 16'b1010101110000000;
            3'b100: morse = 16'b1011101110000000;
            3'b101: morse = 16'b1110101011100000;
            3'b110: morse = 16'b1110101110111000;
            3'b111: morse = 16'b1110111010100000;
            default: morse = 16'b0000000000000000;
        endcase
    end
endmodule

module shifter(clock, enable, load, reset, data, out);
    input clock, enable, load, reset;
    input[15:0] data;
    output out;
    reg[15:0] s;

    always @(posedge clock, posedge load, posedge reset)
    begin
        if (load)
            s = data;
        else if (reset)
            s = 0;
        else if (enable == 1'b1)
            s = s  << 1;
    end
    assign out = s[15];
endmodule

module ratedivider(clock, period, reset_n, q);
    input clock;
    input reset_n;
    input[31:0] period;
    output reg[31:0] q;

    always @(posedge clock, posedge reset_n)
    begin
        if (reset_n == 1'b0)
            q <= period - 1;
        else
            begin
                if (q == 0)
                    q <= period - 1;
                else
                    q <= q - 1'b1;
            end
    end
endmodule