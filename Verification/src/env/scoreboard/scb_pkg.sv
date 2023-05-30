package scb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import clock_pkg::*;
    import dio_pkg::*;
    import spi_slave_pkg::*;

    `include "checker.sv"
    `include "ref_model.sv"
    `include "scoreboard.sv"

    `include "scoreboard_config.sv"

endpackage : scb_pkg