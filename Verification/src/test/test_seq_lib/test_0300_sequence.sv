
class test_0300_sequence extends test_base_sequence;

    `uvm_object_utils(test_0300_sequence)

    function new (string name = "test_0300_sequence");
        super.new(name);
    endfunction : new

    task body();
        reset_io();
        drive_clock_period(clock_cycle); // ns
        drive_clock_state(1);
        //
        #(clock_cycle);
        drive_io("NRST", 1);
        //
        config_dio_params(0, 0, 0, 0, 0, 0, 0);
        send_spi({1,1,1,1,1,1,1,1,
                  1,1,1,1,1,1,1,1,
                  1,1,1,1,1,1,1,1,
                  1,1,1,1,1,1,1,1});
        // CASE 1
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);
        //
        send_spi({0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0});
        // CASE 1
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

endclass : test_0300_sequence