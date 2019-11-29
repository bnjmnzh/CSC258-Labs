module control(clock, reset, done, erase, en_vga, want_to_move, can_move, state,
					colour_car, car_x_final, car_y_final, en_car_datapath,
					colour_pedestrian, pedestrian_x_final, pedestrian_y_final, en_pedestrian_datapath,
					x_final, y_final, colour);

	parameter colour_background; 
	
   input clock, reset, done, want_to_move;
	input [2:0] colour_car, colour_pedestrian;
	input [8:0] car_x_final, pedestrian_x_final;
	input [7:0] car_y_final, pedestrian_y_final;
	output reg [2:0] colour;
	output reg [8:0] x_final;
	output reg [7:0] y_final;
	output reg en_vga, erase, can_move, en_car_datapath, en_pedestrian_datapath;
	output [2:0] state;
   reg [2:0] curr, next;

   localparam  PLOT_CAR = 0,
					PLOT_PEDESTRIAN = 1,
				   PLOT_WAIT = 2,
               ERASE_CAR = 3,
					ERASE_PEDESTRIAN = 4,
					MOVE = 5;


    // active high reset
    always @(posedge clock) begin
        if(reset)
            curr <= PLOT_CAR;
        else
            curr <= next; 
    end
	 
    // State Table
    always @(*)
    begin: state_table
        case (curr)
				// draw each object
				PLOT_CAR: next = done ? PLOT_PEDESTRIAN : PLOT_CAR ;
				PLOT_PEDESTRIAN: next = done ? PLOT_WAIT : PLOT_PEDESTRIAN ;
				
				// wait for move signal
				PLOT_WAIT: next = want_to_move ? ERASE_CAR : PLOT_WAIT ;
				
				// erase each object
				ERASE_CAR: next = done ? ERASE_PEDESTRIAN : ERASE_CAR ;
				ERASE_PEDESTRIAN: next = done ? MOVE : ERASE_PEDESTRIAN ;
				
				// move coordinates
				MOVE: next = PLOT_CAR;
				
				default: next = PLOT_CAR;
        endcase
    end

    always @(*)
    begin
        case (curr)
			PLOT_CAR: begin
				en_vga = 1;
				en_car_datapath = 1;
				en_pedestrian_datapath = 0;
            erase = 0;
				can_move = 0;
				
				x_final = car_x_final;
				y_final = car_y_final;
				colour = colour_car;
			end
			PLOT_PEDESTRIAN: begin
				en_vga = 1;
				en_car_datapath = 0;
				en_pedestrian_datapath = 1;
            erase = 0;
				can_move = 0;
				
				x_final = pedestrian_x_final;
				y_final = pedestrian_y_final;
				colour = colour_pedestrian;
			end
         PLOT_WAIT: begin
            en_vga = 0;
				en_car_datapath = 0;
				en_pedestrian_datapath = 0;
            erase = 0;
				can_move = 0;	 
         end
			ERASE_CAR: begin
            en_vga = 1;
				en_car_datapath = 1;
				en_pedestrian_datapath = 0;
            erase = 1;
            can_move = 0;
				
				x_final = car_x_final;
				y_final = car_y_final;
				colour = colour_background;
			end
			ERASE_PEDESTRIAN: begin
				en_vga = 1;
				en_car_datapath = 0;
				en_pedestrian_datapath = 1;
            erase = 1;
				can_move = 0;
				
				x_final = pedestrian_x_final;
				y_final = pedestrian_y_final;
				colour = colour_background;
			end
			MOVE: begin
            en_vga = 0;
				en_car_datapath = 0;
				en_pedestrian_datapath = 0;
            erase = 0;
            can_move = 1;
			end
        endcase
    end
	 assign state = curr; 
endmodule 