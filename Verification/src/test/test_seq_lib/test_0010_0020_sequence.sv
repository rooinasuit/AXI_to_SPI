
class test_0010_0020_sequence extends test_base_sequence;

    `uvm_object_utils(test_0010_0020_sequence)

    function new (string name = "test_0010_0020_sequence");
        super.new(name);
    endfunction : new

    task body();
        reset_io();
        drive_clock_period(clock_cycle); // ns
        drive_clock_state(1);
        //
        #(2*clock_cycle);
        drive_io("NRST", 1);
        //
        config_dio_params(0, 0, 3, 255, 0, 0, 0);
        define_test_step("setting up dio params -> IFG = 255");

        define_test_step("decoy frame");
        //
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 3.1.1
        //
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 3.1.2
        //
        #(11*clock_cycle);
        drive_io("start", 1);
        #(10*clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);

        // CASE 3.1.3
        //
        #(11*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        wait_io("CS_o", 1);
        #(10*clock_cycle);
        drive_io("start", 0);
        //

        config_dio_params(0, 0, 3, 0, 0, 0, 0);
        define_test_step("setting up dio params -> IFG = 0");

        define_test_step("decoy frame");
        //
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 3.2.1
        //
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 3.2.2
        //
        #(11*clock_cycle);
        drive_io("start", 1);
        #(10*clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);

        // CASE 3.2.3
        //
        #(11*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        wait_io("CS_o", 1);
        #(10*clock_cycle);
        drive_io("start", 0);
        //
        drive_clock_state(0);
    endtask : body

endclass : test_0010_0020_sequence