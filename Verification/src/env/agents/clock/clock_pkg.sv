package clock_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "clock_seq_item.sv"
    `include "clock_base_sequence.sv"
    `include "clock_seq_lib.sv"
    `include "clock_sequencer.sv"
    `include "clock_driver.sv"
    `include "clock_agent.sv"

    `include "clock_config.sv"

endpackage : clock_pkg