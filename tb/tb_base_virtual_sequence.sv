import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class base_virtual_sequence extends uvm_sequence;

    `uvm_object_utils(base_virtual_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    base_reset_sequence rst_seq;
    dio_sequence dio_seq;
    spi_slave_sequence slv_seq;

    reset_sequencer rst_sqr;
    dio_sequencer dio_sqr;
    spi_slave_sequencer slv_sqr;

    function new (string name = "virtual_sequence");
        super.new(name);
    endfunction

endclass : base_virtual_sequence