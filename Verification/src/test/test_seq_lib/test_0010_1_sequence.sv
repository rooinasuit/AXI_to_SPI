
class test_0010_sequence extends test_base_sequence;

    `uvm_object_utils(test_0010_sequence)

    function new (string name = "test_0010_sequence");
        super.new(name);
    endfunction : new

    //////////////////////////////////////////////////////////
    // No need to set value [0] on anything other than      //
    // start_out just after RST deassertion                 //
    // due to the other signals being set to [0] on default //
    //////////////////////////////////////////////////////////

    task body();
        // drive_clock(10ns);
        //
        drive_io("RST", 1);
        #10ns;
        drive_io("RST", 0);
        drive_io("spi_mode_out", 0);
        drive_io("sck_speed_out", 3);
        drive_io("word_len_out", 2);
        drive_io("IFG_out", 5);
        drive_io("CS_SCK_out", 10);
        drive_io("SCK_CS_out", 15);
        drive_io("mosi_data_out", 32'haa);
        #10ns;
        drive_io("start_out", 0);
        #10ns;
        drive_io("start_out", 1);
        #10ns;
        drive_io("start_out", 0);
        #1000ns;
        drive_io("RST", 1);
        #10ns;
        drive_io("RST", 0);
        // drive_clock(0);
    endtask : body

endclass : test_0010_sequence