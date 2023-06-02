package clock_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "clock_seq_item.sv"
    //
    import clock_seq_pkg::*;
    //
    `include "clock_sequencer.sv"
    `include "clock_driver.sv"
    `include "clock_config.sv"
    `include "clock_agent.sv"

endpackage : clock_pkg