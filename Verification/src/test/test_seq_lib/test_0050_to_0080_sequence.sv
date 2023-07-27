
class test_0050_to_0080_sequence extends test_base_sequence;

    `uvm_object_utils(test_0050_to_0080_sequence)

    function new (string name = "test_0050_to_0080_sequence");
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

        // CASE 1
        //
        config_dio_params(0, 0, 3, 50, 30, 30, 0);
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        // #(clock_cycle);
        //

        // CASE 1
        //
        config_dio_params(1, 0, 3, 50, 30, 30, 0);
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        // #(clock_cycle);
        //

        // CASE 1
        //
        config_dio_params(2, 0, 3, 50, 30, 30, 0);
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        // #(clock_cycle);
        //

        // CASE 1
        //
        config_dio_params(3, 0, 3, 50, 30, 30, 0);
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);
        //
        drive_clock_state(0);
    endtask : body

endclass : test_0050_to_0080_sequence
