module control(clock, resetn, done, erase, writeEn, enable_x);
    input clock, resetn, done;
    output reg writeEn, enable_x, erase;
    reg [2:0] curr, next;

    localparam  PLOT = 3'b000,
					 PLOT_WAIT = 3'b001,
                ERASE = 3'b010;
					 

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
            PLOT: next = PLOT_WAIT;
				PLOT_WAIT: next = done ? ERASE : PLOT_WAIT ;
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
				PLOT_WAIT:
				begin
				writeEn = 1;
				enable_x = 1;
				end
            ERASE: erase = 1;
        endcase
    end
endmodule