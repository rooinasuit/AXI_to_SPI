import uvm_pkg::*;
`include "uvm_macros.svh"

class clock_base_sequence extends uvm_sequence#(clock_seq_item);

    `uvm_object_utils(clock_base_sequence)

    clock_seq_item clk_pkt;

    function new (string name = "clock_base_sequence");
        super.new(name);
    endfunction : new

    task start_clock(time period);
        
    endtask : start_clock

    task finish_clock();

    endtask : finish_clock

endclass : clock_base_sequence