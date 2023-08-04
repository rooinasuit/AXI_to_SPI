
class test_0090_to_0160_sequence extends test_base_sequence;

    `uvm_object_utils(test_0090_to_0160_sequence)

    function new (string name = "test_0090_to_0160_sequence");
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

        // CASE 1.1
        //
        config_dio_params(0, 0, 2, 0, 0, 0, 'b00010001);
        send_spi({1,1,1,0,1,1,1,1});
        #(2*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 1.2
        //
        config_dio_params(1, 0, 2, 0, 0, 0, 'b00010001);
        send_spi({1,1,1,0,1,1,1,1});
        #(2*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 1.3
        //
        config_dio_params(2, 0, 2, 0, 0, 0, 'b00010001);
        send_spi({1,1,1,0,1,1,1,1});
        #(2*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 1.4
        //
        config_dio_params(3, 0, 2, 0, 0, 0, 'b00010001);
        send_spi({1,1,1,0,1,1,1,1});
        #(2*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        drive_clock_state(0);
    endtask : body

endclass : test_0090_to_0160_sequence