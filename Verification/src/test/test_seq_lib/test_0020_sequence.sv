
class test_0020_sequence extends test_base_sequence;

    `uvm_object_utils(test_0020_sequence)

    function new (string name = "test_0020_sequence");
        super.new(name);
    endfunction : new

    //////////////////////////////////////////////////////////
    // No need to set value [0] on anything other than      //
    // start_out just after RST deassertion                 //
    // due to the other signals being set to [0] on default //
    //////////////////////////////////////////////////////////

    task body();
        reset_io();
        drive_clock_period(10); // ns
        drive_clock_state(1);
        //
        #(clock_cycle);
        drive_io("NRST", 1);
        //
        config_dio_params(0, 0, 3, 20, 0, 0, 0);

        // CASE 1
        // FIRST DUMMY FRAME WITHOUT IFG AFTER RESET
        send_spi({0, 0, 0, 0});
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);
        // HERE IT IS BEING TESTED
        send_spi({0, 0, 0, 0});
        #(5*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);
        //
        drive_clock_state(0);
    endtask : body

endclass : test_0020_sequence