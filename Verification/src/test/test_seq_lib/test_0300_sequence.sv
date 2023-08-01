
class test_0300_sequence extends test_base_sequence;

    `uvm_object_utils(test_0300_sequence)

    function new (string name = "test_0300_sequence");
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
        config_dio_params(0, 3, 2, 255, 0, 0, 0);
        define_test_step("setting up dio params - control frame");
        //
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        define_test_step("testing for INTERFRAME state");
        // CASE 1
        #(50*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);

        #(10*clock_cycle);
        drive_io("NRST", 0);
        #(clock_cycle);
        drive_io("NRST", 1);

        config_dio_params(0, 3, 2, 0, 255, 255, 0);
        define_test_step("setting up dio params");
        define_test_step("testing for PRE_TRANS state");
        // CASE 2
        #(50*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);

        #(50*clock_cycle);
        drive_io("NRST", 0);
        #(clock_cycle);
        drive_io("NRST", 1);

        config_dio_params(0, 3, 2, 0, 0, 255, 0);
        define_test_step("setting up dio params");
        define_test_step("testing for TRANSACTION state");
        // CASE 2
        #(50*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);

        #(50*clock_cycle);
        drive_io("NRST", 0);
        #(clock_cycle);
        drive_io("NRST", 1);

        config_dio_params(0, 3, 2, 0, 0, 255, 0);
        define_test_step("setting up dio params");
        define_test_step("testing for FINISH state");
        // CASE 2
        #(50*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);

        #(8*16*clock_cycle + 50*clock_cycle);
        drive_io("NRST", 0);
        #(clock_cycle);
        drive_io("NRST", 1);
        //
        drive_clock_state(0);
    endtask : body

endclass : test_0300_sequence