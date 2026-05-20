module counter_kendaraan(
    input wire clk,
    input wire reset,
    input wire count_pulse,
    output reg [15:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 16'd0;
        else if (count_pulse) begin
            if (count >= 16'd9999)
                count <= 16'd0;
            else
                count <= count + 1;
        end
    end
endmodule