import uvm_pkg::*;
`include "uvm_macros.svh"

// import proj_pkg::*;

class clock_driver extends uvm_driver;

    `uvm_component_utils(clock_driver)

    // instantiation of internal objects
    virtual dut_interface vif;

    int period;

    function new (string name = "clock_driver", uvm_component parent = null);
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

        fork
            forever#(period/2) vif.GCLK = !vif.GCLK;
        join_none

    endtask : run_phase

endclass : clock_driver