module fsm_moore_tol(
    input wire clk,
    input wire reset,
    input wire ce,      // pulse dari tombol enter
    input wire w,       // kartu valid

    output reg y,
    output wire [1:0] state_display
);

    parameter S0 = 2'b00; // IDLE
    parameter S1 = 2'b01; // SCAN / VALIDASI
    parameter S2 = 2'b10; // GATE OPEN
    parameter S3 = 2'b11; // GATE CLOSE

    reg [1:0] curr, next;

    assign state_display = curr;

    always @(posedge clk or posedge reset) begin
        if (reset)
            curr <= S0;
        else if (ce)
            curr <= next;
    end

    always @(*) begin
        next = curr;
        y = 1'b0;

        case (curr)
            S0: begin
                y = 1'b0;
                if (w)
                    next = S1;
                else
                    next = S0;
            end

            S1: begin
                y = 1'b0;
                next = S2;
            end

            S2: begin
                y = 1'b1;
                next = S3;
            end

            S3: begin
                y = 1'b0;
                next = S0;
            end

            default: begin
                y = 1'b0;
                next = S0;
            end
        endcase
    end

endmodule