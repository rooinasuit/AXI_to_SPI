import uvm_pkg::*;
`include "uvm_macros.svh"

class clock_seq_item extends uvm_sequence_item;

    // requested inputs
    bit GCLK;

    `uvm_object_utils_begin(clock_seq_item)
        `uvm_field_int(GCLK, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "clock_seq_item");
        super.new(name);
    endfunction : new

endclass : clock_seq_item
