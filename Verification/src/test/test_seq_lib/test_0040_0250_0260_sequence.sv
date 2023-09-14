
class test_0040_0250_0260_sequence extends test_base_sequence;

    `uvm_object_utils(test_0040_0250_0260_sequence)

    function new (string name = "test_0040_0250_0260_sequence");
        super.new(name);
    endfunction : new

    task body();
        reset_io();
        drive_clock_period(clock_cycle); // ns
        drive_clock_state(1);
        //
        #(clock_cycle);
        drive_io("NRST", 1);

        // CASE 1
        //
        config_dio_params(0, 0, 3, 0, 255, 255, 0);
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 2
        //
        config_dio_params(0, 0, 3, 0, 255, 0, 0);
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 3
        //
        config_dio_params(0, 0, 3, 0, 0, 255, 0);
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 4
        //
        config_dio_params(0, 0, 3, 0, 0, 0, 0);
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

endclass : test_0040_0250_0260_sequence