`timescale 1ns/1ps

module traffic_signal_controller_tb;
    reg clock = 0;
    reg clear = 1;
    reg car_on_country_rd = 0;
    wire [2:0] hwy;
    wire [2:0] cntry;

    localparam [2:0] RED = 3'b100, YELLOW = 3'b010, GREEN = 3'b001;

    traffic_signal_controller #(.YELLOW_CYCLES(2), .ALL_RED_CYCLES(1)) dut (
        .clock(clock), .clear(clear), .car_on_country_rd(car_on_country_rd),
        .hwy(hwy), .cntry(cntry)
    );

    always #5 clock = ~clock;

    task expect_lights;
        input [2:0] expected_hwy;
        input [2:0] expected_cntry;
        input [8*48-1:0] label;
        begin
            #1;
            if ((hwy !== expected_hwy) || (cntry !== expected_cntry)) begin
                $display("FAIL: %0s: hwy=%b cntry=%b", label, hwy, cntry);
                $finish(1);
            end
            $display("PASS: %0s", label);
        end
    endtask

    initial begin
        $dumpfile("build/traffic_signal.vcd");
        $dumpvars(0, traffic_signal_controller_tb);

        @(posedge clock); #1; clear = 0;
        expect_lights(GREEN, RED, "reset selects main-road green");

        car_on_country_rd = 1;
        @(posedge clock);
        expect_lights(YELLOW, RED, "car starts main-road yellow");
        @(posedge clock);
        expect_lights(YELLOW, RED, "yellow holds for configured duration");
        @(posedge clock);
        expect_lights(RED, RED, "all-red handoff interval");
        @(posedge clock);
        expect_lights(RED, GREEN, "country road receives green");

        car_on_country_rd = 0;
        @(posedge clock);
        expect_lights(RED, YELLOW, "country road changes to yellow");
        @(posedge clock);
        expect_lights(RED, YELLOW, "country yellow holds for duration");
        @(posedge clock);
        expect_lights(GREEN, RED, "controller returns to main-road green");

        $display("All traffic-controller tests passed.");
        $finish;
    end
endmodule
