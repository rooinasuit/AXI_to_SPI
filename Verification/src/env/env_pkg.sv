package env_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // import clock_pkg::*;
    import dio_pkg::*;
    import spi_pkg::*;
    `include "virtual_sequencer.sv"

    import scb_pkg::*;

    `include "environment_config.sv"
    `include "environment.sv"

endpackage : env_pkg