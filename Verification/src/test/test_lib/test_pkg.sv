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
    //
    `include "test_0010_0020.sv"
    `include "test_0025.sv"
    `include "test_0030.sv"
    `include "test_0040_0250_0260.sv"
    `include "test_0050_to_0080.sv"
    `include "test_0090_to_0160.sv"
    `include "test_0170_to_0200.sv"
    `include "test_0210_to_0240.sv"
    `include "test_0270_to_0290.sv"
    `include "test_0300.sv"
    `include "test_0310.sv"

endpackage : test_pkg