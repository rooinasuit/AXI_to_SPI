package test_seq_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    //
    import clock_seq_pkg::*;
    import dio_seq_pkg::*;
    import spi_slave_seq_pkg::*;
    //
    import env_pkg::*;
    //
    `include "test_base_sequence.sv"
    `include "test_0010_sequence.sv"

endpackage : test_seq_pkg