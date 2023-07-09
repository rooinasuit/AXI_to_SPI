package test_seq_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    //
    import clock_pkg::*;
    import dio_pkg::*;
    import spi_pkg::*;
    //
    import clock_seq_pkg::*;
    import dio_seq_pkg::*;
    import spi_seq_pkg::*;
    //
    import env_pkg::*;
    //
    `include "test_base_sequence.sv"
    `include "test_0010_1_sequence.sv"

endpackage : test_seq_pkg