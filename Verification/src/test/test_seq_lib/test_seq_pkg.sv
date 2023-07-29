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
    //
    `include "test_0010_0020_sequence.sv"
    `include "test_0025_sequence.sv"
    `include "test_0030_sequence.sv"
    `include "test_0040_0250_0260_sequence.sv"
    `include "test_0050_to_0080_sequence.sv"
    `include "test_0090_to_0160_sequence.sv"
    `include "test_0170_to_0200_sequence.sv"
    `include "test_0210_to_0240_sequence.sv"
    `include "test_0270_to_0290_sequence.sv"

endpackage : test_seq_pkg