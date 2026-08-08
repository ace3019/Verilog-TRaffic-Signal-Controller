`timescale 1ns/1ps

// Two-road traffic signal controller.
// clear is synchronous and active high. car_on_country_rd is sampled each clock.
module traffic_signal_controller #(
    parameter integer YELLOW_CYCLES  = 3,
    parameter integer ALL_RED_CYCLES = 2
) (
    input  wire       clock,
    input  wire       clear,
    input  wire       car_on_country_rd,
    output reg  [2:0] hwy,
    output reg  [2:0] cntry
);

    localparam [2:0] RED    = 3'b100;
    localparam [2:0] YELLOW = 3'b010;
    localparam [2:0] GREEN  = 3'b001;

    localparam [2:0] S0_MAIN_GREEN          = 3'd0;
    localparam [2:0] S1_MAIN_YELLOW         = 3'd1;
    localparam [2:0] S2_ALL_RED_TO_COUNTRY  = 3'd2;
    localparam [2:0] S3_COUNTRY_GREEN       = 3'd3;
    localparam [2:0] S4_COUNTRY_YELLOW      = 3'd4;

    reg [2:0] state;
    integer phase_count;

    // State transition and phase timer. Timer is used only for timed phases.
    always @(posedge clock) begin
        if (clear) begin
            state       <= S0_MAIN_GREEN;
            phase_count <= 0;
        end else begin
            case (state)
                S0_MAIN_GREEN: begin
                    phase_count <= 0;
                    if (car_on_country_rd)
                        state <= S1_MAIN_YELLOW;
                end
                S1_MAIN_YELLOW: begin
                    if (phase_count >= YELLOW_CYCLES - 1) begin
                        state       <= S2_ALL_RED_TO_COUNTRY;
                        phase_count <= 0;
                    end else
                        phase_count <= phase_count + 1;
                end
                S2_ALL_RED_TO_COUNTRY: begin
                    if (phase_count >= ALL_RED_CYCLES - 1) begin
                        state       <= S3_COUNTRY_GREEN;
                        phase_count <= 0;
                    end else
                        phase_count <= phase_count + 1;
                end
                S3_COUNTRY_GREEN: begin
                    phase_count <= 0;
                    if (!car_on_country_rd)
                        state <= S4_COUNTRY_YELLOW;
                end
                S4_COUNTRY_YELLOW: begin
                    if (phase_count >= YELLOW_CYCLES - 1) begin
                        state       <= S0_MAIN_GREEN;
                        phase_count <= 0;
                    end else
                        phase_count <= phase_count + 1;
                end
                default: begin
                    state       <= S0_MAIN_GREEN;
                    phase_count <= 0;
                end
            endcase
        end
    end

    // Moore-style output decoder. Defaults leave both directions red on recovery.
    always @(*) begin
        hwy   = RED;
        cntry = RED;
        case (state)
            S0_MAIN_GREEN:    hwy = GREEN;
            S1_MAIN_YELLOW:   hwy = YELLOW;
            S3_COUNTRY_GREEN: cntry = GREEN;
            S4_COUNTRY_YELLOW: cntry = YELLOW;
            default: begin end
        endcase
    end

endmodule
