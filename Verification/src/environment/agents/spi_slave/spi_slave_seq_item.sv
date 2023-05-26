import uvm_pkg::*;
`include "uvm_macros.svh"

class spi_slave_seq_item extends uvm_sequence_item;

    // requested inputs
    bit MISO_in;

    // received outputs
    bit MOSI_out;
    bit SCLK_out;
    bit CS_out;

    `uvm_object_utils_begin(spi_slave_seq_item)
        `uvm_field_int(MISO_in, UVM_DEFAULT)
        `uvm_field_int(MOSI_out, UVM_DEFAULT)
        `uvm_field_int(SCLK_out, UVM_DEFAULT)
        `uvm_field_int(CS_out, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "spi_slave_seq_item");
        super.new(name);
    endfunction : new

    // constraint status_chk {start_in != busy_out;}

endclass : spi_slave_seq_item
