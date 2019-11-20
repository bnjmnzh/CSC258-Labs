 module car (
    input wire clk,
    input wire tick,    // tick: frequency to check keyboard input
    input wire reset,         // reset: returns to starting position
    input wire left_key, right_key, // if left and right arrow keys pressed
    output reg [8:0] car_xleft,  // car hitbox left edge: 9-bit value for 320x240 resolution
    output reg [8:0] car_xright,  // right edge
    output reg [7:0] car_ytop,  // top edge: 8-bit value for 320x240 resolution
    output reg [7:0] car_ybottom   // bottom edge
    );

    localparam move_speed = 10; // pixels to move per left/right key
    localparam car_height = 30; // car is 30 pixels high
    localparam car_width = 15;

    assign car_xright = car_xleft + car_width;  // left: centre minus half horizontal size
    assign car_ybottom = 5;
    assign car_ytop = car_height + car_bottom;

    always @(posedge clk)
    begin
    if (reset)
        car_xleft <= 100;
    else if (tick)
        begin

	if (right_key && left_key)
            car_xl <= car_xl;  // nothing happens
        else if (right_key && (car_xr < 300) // checks car wont move off screen
            car_xl <= car_xl + move_speed; // move right
        else if (left_key & (car_xl > 20)) // checks car wont move off screen
            car_xl <= car_xl - move_speed; // move left 

        end
    end
endmodule
