module divider(CLOCK_50, SW, KEY, HEX0);
    input CLOCK_50;
    input[1:0] KEY;
    input[1:0] SW;
    output[6:0] HEX0;
    wire[31:0] rateddivider_out;
    wire[3:0] displayCounter_out;
    wire enable;
    reg [31:0] period;

    assign enable = (rateddivider_out == 0) ? 1 : 0;

    always @(SW)
    begin
        case(SW[1:0])
            2'b00: period <= 1;
            2'b01: period <= 50000000;
            2'b10: period <= 100000000;
            2'b11: period <= 200000000;
            default: period <= 0;
        endcase
    end

    rateddivider u0(
        .clock(CLOCK_50),
        .reset_n(KEY[0]),
        .period(period),
        .q(rateddivider_out)
    );

    displayCounter u1(
        .clock(CLOCK_50),
        .reset_n(KEY[0]),
        .enable(enable),
        .q(displayCounter_out)
    );

    HEX u2(
        .S(displayCounter_out),
        .H(HEX0)
    );
endmodule

module counter(clock, reset_n, reload, display, select);
    output[3:0] display;
    input clock, reset_n, reload;
    input[1:0] select;
    wire[27:0] connection0, connection1;

endmodule

module rateddivider(clock, period, reset_n, q);
    input clock, reset_n;
    input[31:0] period;
    output reg [31:0] q;

    always @(posedge clock)
    begin
        if (reset_n == 1'b0)
            q <= period - 1;
        else
            begin 
                if (q == 0)
                    q <= period -1;
                else
                    q <= q - 1'b1;
            end
    end
endmodule

module displayCounter(clock, reset_n, enable, q);
    input clock, reset_n, enable;
    output reg [3:0] q;
    
    always @(posedge clock)
    begin
        if(reset_n == 1'b0)
            q <= 0;
        else if (enable == 1'b1)
            begin
                if(q == 4'b1111)
                    q <= 0;
                else
                    q <= q + 1'b1;
            end
    end
endmodule

module mux4to1(out,u,v,w,x,switch);
    input [1:0]switch;
    input [27:0]u;
    input [27:0]v;
    input [27:0]w;
    input [27:0]x;
    output [27:0]out;
    reg [27:0] result;

    assign out = result;

    always @(*)
    begin
        case(switch)
            2'b00: //u
                result = u;
            2'b01: //v
                result = v;
            2'b10: //w
                result = w;
            2'b11: //x
                result = x;
        endcase
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
