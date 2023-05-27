import uvm_pkg::*;
`include "uvm_macros.svh"

class dio_driver extends uvm_driver#(dio_seq_item);

    `uvm_component_utils(dio_driver)

    // instantiation of internal objects
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
                dio_pkt = dio_seq_item::type_id::create("dio_pkt");

                `uvm_info("DIO_DRV", "Fetching next dio_pkt to put onto the DUT interface", UVM_LOW)
                seq_item_port.get_next_item(dio_pkt); // blocking

                vif.start_in     = dio_pkt.start_out;
                vif.spi_mode_in  = dio_pkt.spi_mode_out;
                vif.sck_speed_in = dio_pkt.sck_speed_out;
                vif.word_len_in  = dio_pkt.word_len_out;
                vif.IFG_in       = dio_pkt.IFG_out;
                vif.CS_SCK_in    = dio_pkt.CS_SCK_out;
                vif.SCK_CS_in    = dio_pkt.SCK_CS_out;
                vif.mosi_data_in = dio_pkt.mosi_data_out;

                `uvm_info("DIO_DRV", "Transaction finished, ready for another", UVM_LOW)
                seq_item_port.item_done(); // unblocking, ready for another send to the DUT
        end

    endtask : run_phase

endclass: dio_driver