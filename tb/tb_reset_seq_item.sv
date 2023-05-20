import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class reset_seq_item extends uvm_sequence_item;

    // requested inputs
    bit RST;

    `uvm_object_utils_begin(reset_seq_item)
        `uvm_field_int(RST, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "reset_seq_item");
        super.new(name);
    endfunction : new

endclass : reset_seq_item