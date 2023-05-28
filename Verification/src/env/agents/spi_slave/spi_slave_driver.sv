import uvm_pkg::*;
`include "uvm_macros.svh"

class spi_slave_driver extends uvm_driver#(spi_slave_seq_item);

    `uvm_component_utils(spi_slave_driver)

    // instantiation of internal objects
    virtual spi_slave_interface vif;
    spi_slave_seq_item slv_pkt;

    function new (string name = "spi_slave_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(!uvm_config_db#(virtual spi_slave_interface)::get(this, "", "s_vif", vif)) begin
            `uvm_error("SPI_DRV", {"virtual interface must be set for: ", get_full_name(), "vif"})
        end

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            // @(posedge vif.GCLK)
                slv_pkt = spi_slave_seq_item::type_id::create("slv_pkt");
                `uvm_info("SLV_DRV", "Fetching next slv_pkt to put onto the DUT interface", UVM_LOW)
                seq_item_port.get_next_item(slv_pkt);

                vif.MISO_in     <= slv_pkt.MISO_in;

                `uvm_info("SLV_DRV", "Transaction finished, ready for another", UVM_LOW)
                seq_item_port.item_done();
        end

    endtask : run_phase

endclass: spi_slave_driver