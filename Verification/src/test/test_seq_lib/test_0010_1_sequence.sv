
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
        reset_clock();
        reset_io();
        reset_spi();
        #10ns;
        drive_clock_period(30); // ns
        drive_clock_state(1);
        //
        drive_io("RST", 1);
        #30ns;
        drive_io("RST", 0);
        //
        drive_io("spi_mode_out", 1);
        //
        drive_io("word_len_out", 2);
        //
        drive_io("sck_speed_out", 2);
        //
        drive_io("IFG_out", 5);
        drive_io("CS_SCK_out", 15);
        drive_io("SCK_CS_out", 10);
        //
        drive_io("mosi_data_out", 32'h55);
        drive_spi("MISO", 32'hab);
        //
        #30ns;
        drive_io("start_out", 1);
        #30ns;
        drive_io("start_out", 0);
        //
        wait_spi_ready(20ns);
        #100ns;
        drive_io("start_out", 1);
        #30ns;
        drive_io("start_out", 0);

        wait_spi_ready(20ns);
        #1000ns;
        drive_clock_state(0);
    endtask : body

endclass : test_0010_1_sequence