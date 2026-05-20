module display(
    input wire clk,
    input wire w_in,
    input wire y_out,
    input wire [1:0] state,
    output reg [6:0] seg,
    output reg [7:0] an
);

    reg [16:0] scan;
    wire [2:0] sel;

    assign sel = scan[16:14];

    always @(posedge clk) begin
        scan <= scan + 1;
    end

    always @(*) begin
        an = 8'b11111111;
        an[sel] = 1'b0;

        case (sel)
            3'd7: seg = 7'b1100011; // w
            3'd6: seg = (w_in) ? 7'b1111001 : 7'b1000000; // 1 / 0
            3'd5: seg = 7'b0010001; // y
            3'd4: seg = (y_out) ? 7'b1111001 : 7'b1000000; // 1 / 0
            3'd3: seg = 7'b0010010; // S
            3'd2: seg = 7'b0000111; // t
            3'd1: begin
                // state MSB
                case (state[1])
                    1'b0: seg = 7'b1000000;
                    1'b1: seg = 7'b1111001;
                endcase
            end
            3'd0: begin
                // state LSB
                case (state[0])
                    1'b0: seg = 7'b1000000;
                    1'b1: seg = 7'b1111001;
                endcase
            end
            default: seg = 7'b1111111;
        endcase
    end

endmodule