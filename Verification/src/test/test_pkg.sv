package test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import clock_pkg::*;
    import dio_pkg::*;
    import spi_slave_pkg::*;

    // `include "virtual_sequencer.sv"

    import env_pkg::*;

    `include "test_base_sequence.sv"
    `include "test_seq_lib.sv"
    `include "test_base.sv"

endpackage : test_pkg