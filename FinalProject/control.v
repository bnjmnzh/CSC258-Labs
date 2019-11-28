module control(clock, reset, done, erase, en_vga, en_datapath, want_to_move, can_move, state);
    input clock, reset, done, want_to_move;
    output reg en_vga, en_datapath, erase, can_move;
	 output [2:0] state;
    reg [2:0] curr, next;

    localparam  PLOT = 0,
				    PLOT_WAIT = 1,
                ERASE = 2,
					 MOVE = 3;


    // active high reset
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
				PLOT_WAIT: next = want_to_move ? ERASE : PLOT_WAIT ;
				ERASE: next = done ? MOVE : ERASE ;
				MOVE: next = PLOT;
				default: next = PLOT;
        endcase
    end

    always @(*)
    begin
        case (curr)
			PLOT: begin
				en_vga = 1;
				en_datapath = 1;
            erase = 0;
				can_move = 0;
			end
         PLOT_WAIT: begin
            en_vga = 0;
            en_datapath = 0;
            erase = 0;
				can_move = 0;	 
         end
			ERASE: begin
            en_vga = 1;
            en_datapath = 1;
            erase = 1;
            can_move = 0;
			end
			MOVE: begin
            en_vga = 0;
            en_datapath = 0;
            erase = 0;
            can_move = 1;
			end
        endcase
    end
	 assign state = curr; 
endmodule 