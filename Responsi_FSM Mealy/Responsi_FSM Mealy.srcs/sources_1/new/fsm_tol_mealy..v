module fsm_tol_mealy(

    input wire clk,
    input wire reset,
    input wire ce,
    input wire w,

    output reg y,
    output wire [1:0] state_display
);

    //-----------------------------------
    // STATE
    //-----------------------------------
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;

    reg [1:0] curr;
    reg [1:0] next;

    assign state_display = curr;

    //-----------------------------------
    // SEQUENTIAL
    //-----------------------------------
    always @(posedge clk or posedge reset)
    begin
        if(reset)
            curr <= S0;
        else if(ce)
            curr <= next;
    end

    //-----------------------------------
    // COMBINATIONAL
    //-----------------------------------
    always @(*)
    begin

        next = curr;
        y = 1'b0;

        case(curr)

            //-----------------------------------
            // IDLE
            //-----------------------------------
            S0:
            begin
                if(w)
                    next = S1;
                else
                    next = S0;

                y = 0;
            end

            //-----------------------------------
            // SCAN CARD
            //-----------------------------------
            S1:
            begin
                if(w)
                    next = S1;
                else
                    next = S2;

                y = 0;
            end

            //-----------------------------------
            // VALIDASI
            //-----------------------------------
            S2:
            begin
                if(w)
                    next = S3;
                else
                    next = S0;

                y = 0;
            end

            //-----------------------------------
            // GATE PROCESS
            //-----------------------------------
            S3:
            begin

                if(w)
                begin
                    next = S2;
                    y = 1'b1;
                end
                else
                begin
                    next = S0;
                    y = 1'b0;
                end

            end

            default:
            begin
                next = S0;
                y = 0;
            end

        endcase

    end

endmodule