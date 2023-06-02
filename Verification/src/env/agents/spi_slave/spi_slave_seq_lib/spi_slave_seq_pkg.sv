package spi_slave_seq_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    //
    import spi_slave_pkg::*;
    //
    `include "spi_slave_base_sequence.sv"
    `include "spi_slave_MISO_sequence.sv"
    `include "spi_slave_MISO_random_sequence.sv"

endpackage : spi_slave_seq_pkg