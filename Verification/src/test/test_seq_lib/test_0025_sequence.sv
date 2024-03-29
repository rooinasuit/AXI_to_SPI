
class test_0025_sequence extends test_base_sequence;

    `uvm_object_utils(test_0025_sequence)

    function new (string name = "test_0025_sequence");
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
        define_test_step("setting up dio params");
        config_dio_params(0, 0, 3, 100, 0, 0, 0);

        // CASE 1
        define_test_step("first frame without IFG starts");
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);

        wait_io("CS_o", 1);
        define_test_step("first frame without IFG finished");
        #(clock_cycle);
        define_test_step("another frame starts after IFG");
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        #(50*clock_cycle);
        define_test_step("a second start_i posedge occurs here, in the middle of IFG");
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);
        //
        drive_clock_state(0);
    endtask : body

endclass : test_0025_sequence