
class test_0010_1_sequence extends test_base_sequence;

    `uvm_object_utils(test_0010_1_sequence)

    function new (string name = "test_0010_1_sequence");
        super.new(name);
    endfunction : new

    //////////////////////////////////////////////////////////
    // No need to set value [0] on anything other than      //
    // start_out just after RST deassertion                 //
    // due to the other signals being set to [0] on default //
    //////////////////////////////////////////////////////////

    task body();
        reset_io();
        #10ns;
        drive_clock_period(10); // ns
        drive_clock_state(1);
        //
        drive_io("RST", 1);
        #10ns;
        drive_io("RST", 0);
        //
        drive_io("spi_mode", 0);
        //
        drive_io("sck_speed", 3);
        //
        drive_io("word_len", 2);
        //
        drive_io("IFG", 5);
        drive_io("CS_SCK", 15);
        drive_io("SCK_CS", 10);
        //
        drive_io("mosi_data", 32'hfa55);
        drive_spi("MISO", {1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1}); // wysylane od lewej do prawej :(
        //
        #10ns;
        drive_io("start", 1);
        #10ns;
        drive_io("start", 0);
        //
        wait_spi_ready(20ns);
        #1000ns;
        // drive_clock_state(0);
    endtask : body

endclass : test_0010_1_sequence