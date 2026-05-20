module fsm_gerbang(
    input wire clk,
    input wire reset,
    input wire ce,
    input wire card_in,
    output wire gate_open,
    output reg count_pulse,
    output wire [1:0] state
);
    parameter IDLE  = 2'b00;
    parameter SCAN  = 2'b01;
    parameter OPEN  = 2'b10;
    parameter CLOSE = 2'b11;

    reg [1:0] curr, next;

    assign state = curr;
    assign gate_open = (curr == OPEN);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            curr <= IDLE;
            count_pulse <= 1'b0;
        end else begin
            count_pulse <= 1'b0;
            if (ce) begin
                curr <= next;
                // Men-trigger penambahan count ketika beralih dari OPEN ke CLOSE
                if (curr == OPEN && next == CLOSE)
                    count_pulse <= 1'b1;
            end
        end
    end

    always @(*) begin
        case (curr)
            IDLE:  next = card_in ? SCAN : IDLE;
            SCAN:  next = OPEN;
            // Modifikasi: Tetap di OPEN selama kartu masih 1. 
            // Pindah ke CLOSE HANYA jika kartu dicabut / switch diubah ke 0.
            OPEN:  next = (!card_in) ? CLOSE : OPEN; 
            CLOSE: next = IDLE;
            default: next = IDLE;
        endcase
    end
endmodule