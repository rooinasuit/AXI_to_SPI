package test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    //
    import dio_pkg::*;
    import spi_slave_pkg::*;
    //
    import env_pkg::*;
    //
    import dio_seq_pkg::*;
    import spi_slave_seq_pkg::*;
    `include "test_base_sequence.sv"
    `include "test_0010_sequence.sv"
    //
    `include "test_base.sv"
    `include "test_0010_1.sv"

endpackage : test_pkg