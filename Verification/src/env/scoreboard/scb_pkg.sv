package scb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    //
    import clock_pkg::*;
    import dio_pkg::*;
    import spi_pkg::*;
    //
    `include "comparator.sv"
    `include "scoreboard_defines.sv"
    `include "tb_checker.sv"
    //
    `include "ref_model.sv"
    //
    `include "tb_scoreboard.sv"

endpackage : scb_pkg