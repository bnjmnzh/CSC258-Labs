module morse(SW, KEY, LEDR, CLOCK_50);
    input[1:0] KEY;
    input[2:0] SW;
    input CLOCK_50;
    output[1:0] LEDR;
    wire[15:0] table_out;
    wire rate_out;
    wire shifter_enable;
    wire[31:0] period;

    lutable u0(
        .letter(SW[2:0]),
        .morse(table_out)
    );

    ratedivider u1(
        .clock(CLOCK_50),
        .enable(KEY[1]),
        .reset_n(KEY[0]),
        .q(rate_out)
    );

    shifter u2(
        .enable(rate_out),
        .reset(KEY[0]),
        .data(table_out),
        .out(LEDR[0]),
        .CLOCK_50(CLOCK_50)
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

module shifter(reset, enable, data, out, CLOCK_50);
    input enable, reset, CLOCK_50;
    input[15:0] data;
    output out;
    reg[15:0] s;

    always @(posedge CLOCK_50)
    begin
        if (reset == 1'b0)
            s = data;
        else if (enable == 1'b1)
            s = s  << 1;
    end
    assign out = s[15];
endmodule

module ratedivider(clock, enable, reset_n, q);
    input clock, reset_n, enable;
    output q;
    reg[27:0] count;

    always @(posedge clock)
    begin
        if (reset_n == 1'b0)
            count <= 28'd24999999;
        else
            begin
                if (count == 0)
                    count <= 28'd24999999;
                else
                    count <= count - 1'b1;
            end
    end
    assign q = (count == 0) ? 1 : 0;
endmodule