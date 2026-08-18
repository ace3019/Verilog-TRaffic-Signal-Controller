`define TRUE 1'b1
`define FALSE 1'b0

//Delays
`define Y2RDELAY 3    //Yellow to red delay
`define R2GDELAY 2    //Red to green delay

module sig_control
       (hwy, cntry, x, clock, clear);

//I/O ports
output [1:0] hwy, cntry;
//Light output for 3 states of signal
//GREEN, YELLOW, RED;
reg [1:0] hwy, cntry;
//output default signals are registers

input x;
//x=TRUE, indicates that there is car on
//the country road, otherwise FALSE

input clock, clear;

parameter RED = 2'd0,
          YELLOW = 2'd1,
          GREEN = 2'd2;

//State definition
parameter S0 = 3'd0, //GREEN    CNTRY    RED
          S1 = 3'd1, //YELLOW   CNTRY    RED
          S2 = 3'd2, //RED      CNTRY    RED
          S3 = 3'd3, //RED      CNTRY    GREEN
          S4 = 3'd4; //RED      CNTRY    YELLOW

reg [2:0] state;
reg [2:0] next_state;

//state changes only at positive edge of clock
always @(posedge clock)
begin
    if (clear)
        state <= S0; //Controller starts in S0 state
    else
        state <= next_state;
end

//Compute values of state and country signals
always @(state)
begin
    case (state)
        S0: begin
            hwy = GREEN;
            cntry = RED;
        end

        S1: begin
            hwy = YELLOW;
            cntry = RED;
        end

        S2: begin
            hwy = RED;
            cntry = RED;
        end

        S3: begin
            hwy = RED;
            cntry = GREEN;
        end

        S4: begin
            hwy = RED;
            cntry = YELLOW;
        end
    endcase
end

//State machine using case statements
always @(state or x)
begin
    case (state)

        S0: begin
            if (x)
                next_state = S1;
            else
                next_state = S0;
        end

        S1: begin
            repeat (`Y2RDELAY) @(posedge clock);
            next_state = S2;
        end



        `define TRUE 1'b1
`define FALSE 1'b0

//Delays
`define Y2RDELAY 3    //Yellow to red delay
`define R2GDELAY 2    //Red to green delay

module sig_control
       (hwy, cntry, x, clock, clear);

//I/O ports
output [1:0] hwy, cntry;
//Light output for 3 states of signal
//GREEN, YELLOW, RED;
reg [1:0] hwy, cntry;
//output default signals are registers

input x;
//x=TRUE, indicates that there is car on
//the country road, otherwise FALSE

input clock, clear;

parameter RED = 2'd0,
          YELLOW = 2'd1,
          GREEN = 2'd2;

//State definition
parameter S0 = 3'd0, //GREEN    CNTRY    RED
          S1 = 3'd1, //YELLOW   CNTRY    RED
          S2 = 3'd2, //RED      CNTRY    RED
          S3 = 3'd3, //RED      CNTRY    GREEN
          S4 = 3'd4; //RED      CNTRY    YELLOW

reg [2:0] state;
reg [2:0] next_state;

//state changes only at positive edge of clock
always @(posedge clock)
begin
    if (clear)
        state <= S0; //Controller starts in S0 state
    else
        state <= next_state;
end

//Compute values of state and country signals
always @(state)
begin
    case (state)
        S0: begin
            hwy = GREEN;
            cntry = RED;
        end

        S1: begin
            hwy = YELLOW;
            cntry = RED;
        end

        S2: begin
            hwy = RED;
            cntry = RED;
        end

        S3: begin
            hwy = RED;
            cntry = GREEN;
        end

        S4: begin
            hwy = RED;
            cntry = YELLOW;
        end
    endcase
end

//State machine using case statements
always @(state or x)
begin
    case (state)

        S0: begin
            if (x)
                next_state = S1;
            else
                next_state = S0;
        end

        S1: begin
            repeat (`Y2RDELAY) @(posedge clock);
            next_state = S2;
        end
