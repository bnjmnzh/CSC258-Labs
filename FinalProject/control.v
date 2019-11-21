module control(clock, resetn, erase, writeEn, enable_x);
    input clock, resetn;
    output reg writeEn, enable_x, erase;
    reg [2:0] curr, next;

    localparam  LOAD_X = 3'b000,
                LOAD_X_WAIT = 3'b001,
                LOAD_Y = 3'b010,
                LOAD_Y_WAIT = 3'b011,
                PLOT = 3'b100,
                ERASE = 3'b101;

    // active low reset
    always @(posedge clock) begin
        if(!resetn)
            curr <= PLOT;
        else
            curr <= next; 
    end
    // State Table
    always @(*)
    begin: state_table
        case (curr)
            PLOT: next = ERASE;
            ERASE: next = PLOT;
            default: next = PLOT;
        endcase
    end
    
    always @(*)
    begin
        writeEn = 0;
        erase = 0;
        case (curr)
            PLOT:
				begin
				writeEn = 1;
				enable_x = 1;
				end
            ERASE: erase = 1;
        endcase
    end
endmodule