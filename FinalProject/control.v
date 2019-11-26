module control(clock, reset, done, erase, want_move, en_vga, en_datapath, can_move);
    input clock, reset, done, want_move;
    output reg en_vga, en_datapath, erase, can_move;
    reg [2:0] curr, next;

    localparam  PLOT = 3'b000,
				    PLOT_WAIT = 3'b001,
                ERASE = 3'b010,
					 MOVE = 3'b011;
					 

    // active low reset
    always @(posedge clock) begin
        if(reset)
            curr <= PLOT;
        else
            curr <= next; 
    end

    // State Table
    always @(*)
    begin: state_table
        case (curr)
			PLOT: next = done ? PLOT_WAIT : PLOT ;
            PLOT_WAIT: next = want_move ? ERASE : PLOT_WAIT ;
            ERASE: next = done ? PLOT : ERASE ;
			MOVE: next = PLOT;
            default: next = PLOT;
        endcase
    end
    
    always @(*)
    begin
        case (curr)
            PLOT:
	        begin
			en_vga = 1;
			en_datapath = 1;
            erase = 0;
			can_move = 0;
			end
            PLOT_WAIT:
            begin
            en_vga = 0;
            en_datapath = 0;
            erase = 0;
			can_move = 0;	 
            end
            ERASE:
            begin
            en_vga = 1;
            en_datapath = 1;
            erase = 1;
            can_move = 0;
			end
			MOVE: can_move = 1;
        endcase
    end
endmodule