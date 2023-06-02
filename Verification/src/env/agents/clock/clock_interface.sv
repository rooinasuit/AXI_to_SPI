
interface clock_interface();

    // GLOBAL INPUT SIGNALS
    logic GCLK;

    time period;

    always@(period/2) GCLK = !GCLK;

endinterface : clock_interface