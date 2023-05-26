import uvm_pkg::*;
`include "uvm_macros.svh"

// import proj_pkg::*;

// `define D_VIF d_vif.D_PORT.cb

class dio_driver extends uvm_driver#(dio_seq_item);

    `uvm_component_utils(dio_driver)

    // instantiation of internal objects
    virtual dut_interface vif;
    dio_seq_item dio_pkt;

    function new(string name = "dio_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(!uvm_config_db#(virtual dut_interface)::get(this, get_full_name(), "vif", vif)) begin
            `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), "vif"})
        end

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        dio_pkt = dio_seq_item::type_id::create("dio_pkt");
        forever begin
            // @(posedge vif.GCLK)
                `uvm_info("DIO_DRV", "Fetching next dio_pkt to put onto the DUT interface", UVM_LOW)
                seq_item_port.get_next_item(dio_pkt); // blocking

                vif.start_in     = dio_pkt.start_in;
                vif.spi_mode_in  = dio_pkt.spi_mode_in;
                vif.sck_speed_in = dio_pkt.sck_speed_in;
                vif.word_len_in  = dio_pkt.word_len_in;
                vif.IFG_in       = dio_pkt.IFG_in;
                vif.CS_SCK_in    = dio_pkt.CS_SCK_in;
                vif.SCK_CS_in    = dio_pkt.SCK_CS_in;
                vif.mosi_data_in = dio_pkt.mosi_data_in;

                `uvm_info("DIO_DRV", "Transaction finished, ready for another", UVM_LOW)
                seq_item_port.item_done(); // unblocking, ready for another send to the DUT
        end

    endtask : run_phase

endclass: dio_driver