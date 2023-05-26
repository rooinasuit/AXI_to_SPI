import uvm_pkg::*;
`include "uvm_macros.svh"

import clock_pkg::*;

class clock_agent extends uvm_agent;

    `uvm_component_utils(clock_agent)

    // instantiation of internal objects
    clock_driver clk_drv;

    function new (string name = "clock_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("CLK_AGT", "Creating CLK_DRV handle", UVM_LOW)
        clk_drv = clock_driver::type_id::create("clk_drv", this);

    endfunction : build_phase

endclass : clock_agent