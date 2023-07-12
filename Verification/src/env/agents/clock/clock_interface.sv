
interface clock_interface();

    // GLOBAL INPUT SIGNALS
    logic GCLK;

    task reset_clock();
        GCLK = 0;
    endtask : reset_clock

endinterface : clock_interface