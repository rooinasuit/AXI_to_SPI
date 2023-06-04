class test_0010_1 extends test_base;

    `uvm_component_utils(test_0010_1)

    // constructor
    function new (string name = "test_0010_1", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this); // start time consumption

            // drive_clock(10ns);
            //
            drive_io("start_out", 0);
            drive_io("RST", 1);
            #10ns;
            drive_io("RST", 0);
            drive_io("spi_mode_out", 1);
            drive_io("sck_speed_out", 2);
            drive_io("word_len_out", 2);
            drive_io("IFG_out", 5);
            drive_io("CS_SCK_out", 10);
            drive_io("SCK_CS_out", 15);
            drive_io("mosi_data_out", 32'ha3);
            #100ns;
            drive_io("start_out", 1);
            #10ns;
            drive_io("start_out", 0);
            #1000ns;
            drive_io("RST", 1);
            #10ns;
            drive_io("RST", 0);
            // drive_clock(0);

        phase.drop_objection(this); // end time consumption

    endtask : run_phase

endclass : test_0010_1