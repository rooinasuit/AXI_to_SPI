
class test_0270_to_0290_sequence extends test_base_sequence;

    `uvm_object_utils(test_0270_to_0290_sequence)

    function new (string name = "test_0270_to_0290_sequence");
        super.new(name);
    endfunction : new

    //////////////////////////////////////////////////////////
    // No need to set value [0] on anything other than      //
    // start_out just after RST deassertion                 //
    // due to the other signals being set to [0] on default //
    //////////////////////////////////////////////////////////

    task body();
        reset_io();
        drive_clock_period(clock_cycle); // ns
        drive_clock_state(1);
        //
        #(clock_cycle);
        drive_io("NRST", 1);
        //
        config_dio_params(2, 2, 2, 10, 10, 10, 10);
        define_test_step("setting up dio params");
        send_spi({1,1,1,1,1,1,1,1});
        define_test_step("setting up spi frame");

        // CASE 1
        #(clock_cycle);
        drive_io("start", 1);
        define_test_step("posedge start_i");
        #(clock_cycle);
        drive_io("start", 0);
        define_test_step("negedge start_i");
        //
        #(100*clock_cycle)
        define_test_step("fast-forward 100 global clock cycles into SPI transaction");
        wait_io("SCLK_o", 1);
        #(clock_cycle);
        drive_io("NRST", 0);
        define_test_step("Assert NRST = 0 for 10 clock cycles");
        #(10*clock_cycle);
        drive_io("start", 1);
        define_test_step("Attempt starting SPI transaction");
        define_test_step("posedge start_i");
        #(clock_cycle);
        drive_io("start", 0);
        define_test_step("negedge start_i");
        #(20*clock_cycle)
        drive_io("NRST", 1);
        define_test_step("Release NRST");
        //
        // TESTBENCH DOESNT PRINT OUT A GIVEN I/O IF REASSERTED TO THE SAME VALUE AS BEFORE
        drive_clock_state(0);
    endtask : body

endclass : test_0270_to_0290_sequence