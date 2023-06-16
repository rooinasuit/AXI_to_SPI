
class dio_driver extends uvm_driver#(dio_seq_item);

    `uvm_component_utils(dio_driver)

    // instantiation of internal objects
    dio_config dio_cfg;
    virtual dio_interface vif;
    dio_seq_item dio_pkt;

    function new(string name = "dio_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(dio_config)::get(this, "", "dio_config", dio_cfg)) begin
            `uvm_fatal("DIO_DRV", {"dio config must be set for: ", get_full_name(), " dio_cfg"})
        end

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = dio_cfg.vif;

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

            dio_reset();
            dio_drive();

    endtask : run_phase

    task dio_reset();
            vif.RST = 0;
            vif.start_in = 0;

            vif.spi_mode_in = 0;
            vif.sck_speed_in = 0;
            vif.word_len_in = 0;

            vif.IFG_in = 0;
            vif.CS_SCK_in = 0;
            vif.SCK_CS_in = 0;

            vif.mosi_data_in = 0;
    endtask : dio_reset

    task dio_drive();
        forever begin
            dio_pkt = dio_seq_item::type_id::create("dio_pkt");
            seq_item_port.get_next_item(dio_pkt); // blocking
            case (dio_pkt.name)
                "RST": vif.RST = dio_pkt.value;
                "start_out": vif.start_in = dio_pkt.value;

                "spi_mode_out": vif.spi_mode_in = dio_pkt.value;
                "sck_speed_out": vif.sck_speed_in = dio_pkt.value;
                "word_len_out":  vif.word_len_in = dio_pkt.value;

                "IFG_out":    vif.IFG_in = dio_pkt.value;
                "CS_SCK_out": vif.CS_SCK_in = dio_pkt.value;
                "SCK_CS_out": vif.SCK_CS_in = dio_pkt.value;

                "mosi_data_out": vif.mosi_data_in = dio_pkt.value;

                default: vif.RST = 0;
            endcase
            seq_item_port.item_done(); // unblocking, ready for another send to the DUT
        end
    endtask : dio_drive

    // task create_handle();

    //     `uvm_info("DIO_DRV", "Fetching next dio_pkt to put onto the DUT interface", UVM_LOW)
    // endtask : create_handle

    // function void transaction_done();
    //     `uvm_info("DIO_DRV", "Transaction finished, ready for another", UVM_LOW)
    // endfunction : transaction_done

endclass: dio_driver