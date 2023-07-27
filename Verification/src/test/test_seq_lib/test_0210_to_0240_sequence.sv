
class test_0210_to_0240_sequence extends test_base_sequence;

    `uvm_object_utils(test_0210_to_0240_sequence)

    function new (string name = "test_0210_to_0240_sequence");
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

        // CASE 1.1
        //
        config_dio_params(0, 0, 0, 0, 0, 0, 'haaaaaaaa);
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 1.2
        //
        config_dio_params(0, 1, 0, 0, 0, 0, 'haaaaaaaa);
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 1.3
        //
        config_dio_params(0, 2, 0, 0, 0, 0, 'haaaaaaaa);
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 1.4
        //
        config_dio_params(0, 3, 0, 0, 0, 0, 'haaaaaaaa);
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        drive_clock_state(0);
    endtask : body

endclass : test_0210_to_0240_sequence