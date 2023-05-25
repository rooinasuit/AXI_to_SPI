import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class spi_slave_agent extends uvm_agent;

    `uvm_component_utils(spi_slave_agent)

    // instantiation of internal objects
    spi_slave_sequencer slv_sqr;
    spi_slave_monitor   slv_mtr;
    spi_slave_driver    slv_drv;

    uvm_analysis_port#(spi_slave_seq_item) slv_mon_port;

    function new (string name = "spi_slave_agent", uvm_component parent = null);
        super.new(name,parent);

        slv_mon_port = new("slv_mon_port", this);

    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("SLV_AGT", "Creating SLV_SQR handle", UVM_LOW)
        slv_sqr = spi_slave_sequencer::type_id::create("slv_sqr", this);

        `uvm_info("SLV_AGT", "Creating SLV_DRV handle", UVM_LOW)
        slv_drv = spi_slave_driver::type_id::create("slv_drv", this);

        `uvm_info("SLV_AGT", "Creating SLV_MTR handle", UVM_LOW)
        slv_mtr = spi_slave_monitor::type_id::create("slv_mtr", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        `uvm_info("SLV_AGT", "Connecting export: spi_slave_seq_item (SLV_DRV)", UVM_LOW)
        slv_drv.seq_item_port.connect(slv_sqr.seq_item_export);

    endfunction : connect_phase

endclass: spi_slave_agent