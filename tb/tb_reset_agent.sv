import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class reset_agent extends uvm_agent;

    `uvm_component_utils(reset_agent)

    reset_sequencer rst_sqr;
    reset_driver rst_drv;

    function new (string name = "reset_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("RST_AGT", "Creating RST_SQR handle", UVM_LOW)
        rst_sqr = reset_sequencer::type_id::create("rst_sqr", this);

        `uvm_info("RST_AGT", "Creating RST_DRV handle", UVM_LOW)
        rst_drv = reset_driver::type_id::create("rst_drv", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        `uvm_info("RST_AGT", "Connecting export: reset_seq_item (RST_DRV)", UVM_LOW)
        rst_drv.seq_item_port.connect(rst_sqr.seq_item_export);

    endfunction: connect_phase

endclass : reset_agent