package spi_seq_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    //
    import spi_pkg::*;
    //
    `include "spi_base_sequence.sv"
    `include "spi_drive_sequence.sv"
    `include "spi_drive_random_sequence.sv"
    `include "spi_rsp_sequence.sv"

endpackage : spi_seq_pkg