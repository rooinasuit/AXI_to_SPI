
class clock_sequencer extends uvm_sequencer#(clock_seq_item);

    `uvm_component_utils(clock_sequencer)

    function new(string name = "clock_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

endclass : clock_sequencer