
class dio_driver extends uvm_driver#(dio_seq_item);

    `uvm_component_utils(dio_driver)

    // instantiation of internal objects
    dio_config dio_cfg;
    virtual dio_interface vif;
    dio_seq_item dio_pkt;

    function new(string name = "dio_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(!uvm_config_db#(virtual dio_interface)::get(this, "", "d_vif", vif)) begin
            `uvm_error("DIO_DRV", {"virtual interface must be set for: ", get_full_name(), "vif"})
        end

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            create_handle();
            dio_send();
            transaction_done();
        end

    endtask : run_phase

    task dio_send();
        case (dio_pkt.name)
            "RST": vif.RST = dio_pkt.value;
            "start_out": vif.start_in = dio_pkt.value;

            "spi_mode_out":  vif.spi_mode_in = dio_pkt.value;
            "sck_speed_out": vif.sck_speed_in = dio_pkt.value;
            "word_len_out":  vif.word_len_in = dio_pkt.value;

            "IFG_out":    vif.IFG_in = dio_pkt.value;
            "CS_SCK_out": vif.CS_SCK_in = dio_pkt.value;
            "SCK_CS_out": vif.SCK_CS_in = dio_pkt.value;

            "mosi_data_out": vif.mosi_data_in = dio_pkt.value;

            default: vif.RST = 0;
        endcase
        // vif.start_in     = dio_pkt.start_out;
        // vif.spi_mode_in  = dio_pkt.spi_mode_out;
        // vif.sck_speed_in = dio_pkt.sck_speed_out;
        // vif.word_len_in  = dio_pkt.word_len_out;
        // vif.IFG_in       = dio_pkt.IFG_out;
        // vif.CS_SCK_in    = dio_pkt.CS_SCK_out;
        // vif.SCK_CS_in    = dio_pkt.SCK_CS_out;
        // vif.mosi_data_in = dio_pkt.mosi_data_out;
    endtask : dio_send

    task create_handle();
        dio_pkt = dio_seq_item::type_id::create("dio_pkt");
        seq_item_port.get_next_item(dio_pkt); // blocking
        `uvm_info("DIO_DRV", "Fetching next dio_pkt to put onto the DUT interface", UVM_LOW)
        dio_pkt.print();
    endtask : create_handle

    function void transaction_done();
        `uvm_info("DIO_DRV", "Transaction finished, ready for another", UVM_LOW)
        seq_item_port.item_done(); // unblocking, ready for another send to the DUT
    endfunction : transaction_done

endclass: dio_driver

                // dio_pkt = dio_seq_item::type_id::create("dio_pkt");

                // `uvm_info("DIO_DRV", "Fetching next dio_pkt to put onto the DUT interface", UVM_LOW)
                // seq_item_port.get_next_item(dio_pkt); // blocking

                // vif.start_in     = dio_pkt.start_out;
                // vif.spi_mode_in  = dio_pkt.spi_mode_out;
                // vif.sck_speed_in = dio_pkt.sck_speed_out;
                // vif.word_len_in  = dio_pkt.word_len_out;
                // vif.IFG_in       = dio_pkt.IFG_out;
                // vif.CS_SCK_in    = dio_pkt.CS_SCK_out;
                // vif.SCK_CS_in    = dio_pkt.SCK_CS_out;
                // vif.mosi_data_in = dio_pkt.mosi_data_out;

                // `uvm_info("DIO_DRV", "Transaction finished, ready for another", UVM_LOW)
                // seq_item_port.item_done(); // unblocking, ready for another send to the DUT