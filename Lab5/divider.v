module divider(CLOCK_50, SW, KEY, HEX0);
    input[1:0] SW;
    input CLOCK_50;
    input[1:0] KEY;
    output[6:0] HEX0;

    wire rateddivider_out;
    wire[3:0] displayCounter_out;
    reg [27:0] period;

    // Speed
    always @(*)
    begin
        case(SW[1:0])
            2'b00: period = 0;
            2'b01: period = 28'd49999999;
            2'b10: period = 28'd99999999;
            2'b11: period = 28'd199999999;
            default: period <= 0;
        endcase
    end

    rateddivider u0(
        .CLOCK_50(CLOCK_50),
        .reset_n(KEY[0]),
        .period(period),
        .cout(rateddivider_out)
    );

    displayCounter u1(
        .CLOCK_50(CLOCK_50),
        .reset_n(KEY[0]),
        .enable(rateddivider_out),
        .q(displayCounter_out)
    );

    HEX u2(
        .S(displayCounter_out),
        .H(HEX0)
    );
endmodule

module rateddivider(period, reset_n, CLOCK_50, cout);
    input CLOCK_50, reset_n;
    input[27:0] period;
    output cout;

    reg[27:0] count;

    always @(posedge CLOCK_50)
    begin
        if (reset_n == 1'b0)
            count <= period;
        else
            begin 
                if (count == 0)
                    count <= period;
                else
                    count <= count - 1'b1;
            end
    end
    assign q = (count == 0) ? 1 : 0;
endmodule

module displayCounter(CLOCK_50, reset_n, enable, q);
    input CLOCK_50, reset_n, enable;
    output reg [3:0] q;
    
    always @(posedge CLOCK_50)
    begin
        if(reset_n == 1'b0)
            q <= 0;
        else if (enable == 1'b1)
            q <= q + 1'b1;
    end
endmodule

module SevenSegmentDecoder(in, out);
	input[3:0]in;
	output reg [6:0]out;
	
	always @*
		case(in)
			4'b0000 : out = ~7'b0111111; //0
			4'b0001 : out = ~7'b0000110; //1
			4'b0010 : out = ~7'b1011011; //2
			4'b0011 : out = ~7'b1001111; //3
			4'b0100 : out = ~7'b1100110; //4
			4'b0101 : out = ~7'b1101101; //5 
			4'b0110 : out = ~7'b1111101; //6
			4'b0111 : out = ~7'b0000111; //7
			4'b1000 : out = ~7'b1111111; //8
			4'b1001 : out = ~7'b1101111; //9
			4'b1010 : out = ~7'b1110111; //A
			4'b1011 : out = ~7'b1111100; //b
			4'b1100 : out = ~7'b0111001; //C
			4'b1101 : out = ~7'b1011110; //d
			4'b1110 : out = ~7'b1111001; //E
			4'b1111 : out = ~7'b1110001; //F
		endcase
endmodule 
