module top(
    input wire clk_100MHz,
    input wire sw0,
    input wire btnc,
    input wire btnd,

    output wire led_y,
    output wire led_hb,

    output wire [6:0] seg,
    output wire [7:0] an
);

    wire enter_p;
    wire rst_l;
    wire y;
    wire [1:0] st;

    //-----------------------------------
    // DEBOUNCER ENTER
    //-----------------------------------
    debouncer db_enter(
        .clk(clk_100MHz),
        .btn_in(btnc),
        .btn_pulse(enter_p),
        .btn_level()
    );

    //-----------------------------------
    // DEBOUNCER RESET
    //-----------------------------------
    debouncer db_reset(
        .clk(clk_100MHz),
        .btn_in(btnd),
        .btn_pulse(),
        .btn_level(rst_l)
    );

    //-----------------------------------
    // CLOCK DIVIDER
    //-----------------------------------
    clock_divider hb(
        .clk_100MHz(clk_100MHz),
        .reset(rst_l),
        .ce_2s(),
        .led_hb(led_hb)
    );

    //-----------------------------------
    // FSM MEALY
    //-----------------------------------
    fsm_tol_mealy fsm(
        .clk(clk_100MHz),
        .reset(rst_l),
        .ce(enter_p),
        .w(sw0),
        .y(y),
        .state_display(st)
    );

    //-----------------------------------
    // DISPLAY
    //-----------------------------------
    display disp(
        .clk(clk_100MHz),
        .w_in(sw0),
        .y_out(y),
        .state(st),
        .seg(seg),
        .an(an)
    );

    assign led_y = y;

endmodule