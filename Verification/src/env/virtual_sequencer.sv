import uvm_pkg::*;
`include "uvm_macros.svh"

class virtual_sequencer extends uvm_sequencer;

    `uvm_component_param_utils(virtual_sequencer)

    // instantiation of internal objects
    clock_sequencer clk_sqr;
    dio_sequencer dio_sqr;
    spi_slave_sequencer slv_sqr;

    function new(string name = "virtual_sequencer", uvm_component parent);
        super.new(name,parent);
    endfunction : new

endclass : virtual_sequencer
