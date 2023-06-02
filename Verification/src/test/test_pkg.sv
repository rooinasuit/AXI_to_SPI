package test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    //
    import clock_pkg::*;
    import dio_pkg::*;
    import spi_slave_pkg::*;
    //
    import env_pkg::*;
    //
    // import test_seq_pkg::*;
    import clock_seq_pkg::*;
    import dio_seq_pkg::*;
    import spi_slave_seq_pkg::*;
    //
    `include "test_base.sv"
    `include "test_0010_1.sv"

endpackage : test_pkg