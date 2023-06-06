
class dio_driver extends uvm_driver#(dio_seq_item);

    `uvm_component_utils(dio_driver)

    // instantiation of internal objects
    virtual dio_interface vif;
    dio_seq_item dio_pkt;

    uvm_analysis_port#(dio_seq_item) dio_drv_port;

    int spi_mode;

    function new(string name = "dio_driver", uvm_component parent = null);
        super.new(name,parent);

        dio_drv_port = new("dio_drv_port", this);

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

            "spi_mode_out": begin 
                vif.spi_mode_in = dio_pkt.value;
                spi_mode = dio_pkt.value;
            end
            "sck_speed_out": vif.sck_speed_in = dio_pkt.value;
            "word_len_out":  vif.word_len_in = dio_pkt.value;

            "IFG_out":    vif.IFG_in = dio_pkt.value;
            "CS_SCK_out": vif.CS_SCK_in = dio_pkt.value;
            "SCK_CS_out": vif.SCK_CS_in = dio_pkt.value;

            "mosi_data_out": vif.mosi_data_in = dio_pkt.value;

            default: vif.RST = 0;
        endcase
    endtask : dio_send

    task create_handle();
        dio_pkt = dio_seq_item::type_id::create("dio_pkt");
        seq_item_port.get_next_item(dio_pkt); // blocking
        `uvm_info("DIO_DRV", "Fetching next dio_pkt to put onto the DUT interface", UVM_LOW)
    endtask : create_handle

    function void transaction_done();
        `uvm_info("DIO_DRV", "Transaction finished, ready for another", UVM_LOW)
        dio_drv_port.write(dio_pkt);
        seq_item_port.item_done(); // unblocking, ready for another send to the DUT
    endfunction : transaction_done

endclass: dio_driver