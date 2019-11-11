module control(clock, resetn, load, go, controlX, controlY, controlC, writeEn, enable_x);
    input clock, resetn, load, go;
    output reg controlC, controlX, controlY, writeEn, enable_x;
    reg [2:0] curr, next;

    localparam  LOAD_X = 3'b000,
                LOAD_X_WAIT = 3'b001,
                LOAD_Y = 3'b010,
                LOAD_Y_WAIT = 3'b011,
                PLOT = 3'b100;

    // active low reset
    always @(posedge clock) begin
        if(!resetn)
            curr <= LOAD_X;
        else
            curr <= next; 
    end
    // State Table
    always @(*)
    begin: state_table
        case (curr)
            LOAD_X: next = load ? LOAD_X_WAIT : LOAD_X; // load load if load is high, otherwise load from LOAD_X
            LOAD_X_WAIT: next = load ? LOAD_X_WAIT : LOAD_Y; //load load if load is high, otherwise load from LOAD_Y
            LOAD_Y: next = go ? LOAD_Y_WAIT : LOAD_Y; // load go if go is high, otherwise load from LOAD_Y
            LOAD_Y_WAIT: next = go ? LOAD_Y_WAIT :  PLOT; // load go if go is high, eitherwise load PLOT
            PLOT: next = load ? LOAD_X : PLOT; // load load if load is high, otherwise load PLOT
            default: next = LOAD_X;
        endcase
    end
    
    always @(*)
    begin
        controlX = 1'b0;
        controlY = 1'b0;
        controlC = 1'b0;
        writeEn = 0;
        case (curr)
            LOAD_X: begin
                controlX = 1;
                enable_x = 1;
                end
            LOAD_X_WAIT: controlX = 1;
            LOAD_Y: 
                begin
                    controlX = 0;
                    controlY = 1;
                    controlC = 1;
                end
            LOAD_Y_WAIT:
                begin
                    controlX = 0;
                    controlY = 1;
                    controlC = 1;
                end
            PLOT: writeEn = 1;
        endcase
    end
endmodule