module top(
    input wire clk_100MHz,
    input wire sw0,     // input w
    input wire btnc,    // scan/enter
    input wire btnd,    // reset

    output wire led_y,
    output wire led_hb,
    output wire [6:0] seg,
    output wire [7:0] an
);

    wire enter_p;
    wire rst_l;
    wire y;
    wire [1:0] st;

    // Debouncer tombol enter
    debouncer db_e (
        .clk(clk_100MHz),
        .btn_in(btnc),
        .btn_pulse(enter_p),
        .btn_level()
    );

    // Debouncer tombol reset
    debouncer db_r (
        .clk(clk_100MHz),
        .btn_in(btnd),
        .btn_pulse(),
        .btn_level(rst_l)
    );

    // Heartbeat LED
    clock_divider hb (
        .clk_100MHz(clk_100MHz),
        .reset(rst_l),
        .ce_2s(),
        .led_hb(led_hb)
    );

    // FSM Moore
    fsm_moore_tol fsm (
        .clk(clk_100MHz),
        .reset(rst_l),
        .ce(enter_p),
        .w(sw0),
        .y(y),
        .state_display(st)
    );

    // Seven segment display
    display disp (
        .clk(clk_100MHz),
        .w_in(sw0),
        .y_out(y),
        .state(st),
        .seg(seg),
        .an(an)
    );

    assign led_y = y;

endmodule