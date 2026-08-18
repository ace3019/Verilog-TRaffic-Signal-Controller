
//Stimulus Module
module stimulus;

reg CAR_ON_CNTRY_RD, CNTRY_SIG;

reg [2:0] MAIN_SIG;
//TRUE if indicates that there is car on
//the country road

reg CLOCK, CLEAR;

//Instantiate signal controller
sig_control SC1(MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD,
                CLOCK, CLEAR);

//Set up monitor
initial
    $monitor($time, " Main_Sig = %b Country_Sig = %b Car_on_cntry = %b",
             MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD);

//Set up clock
initial
begin
    CLOCK = `FALSE;
    forever #5 CLOCK = ~CLOCK;
end

//Control clear signal
initial
begin
    CLEAR = `TRUE;
    #5 @(negedge CLOCK);
    CLEAR = `FALSE;
end

//apply stimulus
initial
begin
    CAR_ON_CNTRY_RD = `FALSE;

    repeat(20) @(negedge CLOCK);
    CAR_ON_CNTRY_RD = `TRUE;

    repeat(10) @(negedge CLOCK);
    CAR_ON_CNTRY_RD = `FALSE;

    repeat(20) @(negedge CLOCK);
    CAR_ON_CNTRY_RD = `TRUE;

    repeat(10) @(negedge CLOCK);
    CAR_ON_CNTRY_RD = `FALSE;

    repeat(20) @(negedge CLOCK);
    CAR_ON_CNTRY_RD = `TRUE;

    repeat(10) @(negedge CLOCK);
    CAR_ON_CNTRY_RD = `FALSE;

    repeat(20) @(negedge CLOCK);
    $stop;
end

endmodule
