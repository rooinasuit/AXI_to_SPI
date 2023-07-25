package test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    //
    import clock_pkg::*;
    import dio_pkg::*;
    import spi_pkg::*;
    //
    import scb_pkg::*;
    //
    import env_pkg::*;
    //
    import clock_seq_pkg::*;
    import dio_seq_pkg::*;
    import spi_seq_pkg::*;
    import test_seq_pkg::*;
    //
    `include "test_base.sv"
    `include "test_0010.sv"
    `include "test_0020.sv"
    // `include "test_0030.sv"
    `include "test_0040.sv"

endpackage : test_pkg