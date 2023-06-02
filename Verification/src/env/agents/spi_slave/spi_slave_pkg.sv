package spi_slave_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "spi_slave_seq_item.sv"
    //
    `include "spi_slave_base_sequence.sv"
    `include "spi_slave_seq_lib.sv"
    //
    `include "spi_slave_sequencer.sv"
    `include "spi_slave_driver.sv"
    `include "spi_slave_monitor.sv"
    `include "spi_slave_config.sv"
    `include "spi_slave_agent.sv"

endpackage : spi_slave_pkg