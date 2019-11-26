module control(clock, reset, done, erase, en_vga, en_datapath, can_move, state);
    input clock, reset, done;
    output reg en_vga, en_datapath, erase, can_move;
	 output [2:0] state;
    reg [2:0] curr, next;

    localparam  PLOT = 3'b000,
				    PLOT_WAIT = 3'b001,
                ERASE = 3'b010;


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
            PLOT_WAIT: next = done ? PLOT_WAIT : ERASE ;
            ERASE: next = done ? PLOT : ERASE ;
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
				can_move = 1;
				end
            PLOT_WAIT:
            begin
            en_vga = 0;
            en_datapath = 0;
            erase = 0;
				can_move = 1;	 
            end
            ERASE:
            begin
            en_vga = 1;
            en_datapath = 1;
            erase = 1;
            can_move = 0;
				end
        endcase
    end
	 assign state = curr; 
endmodule 