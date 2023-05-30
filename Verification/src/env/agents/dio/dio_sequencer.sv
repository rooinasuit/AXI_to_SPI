
class dio_sequencer extends uvm_sequencer#(dio_seq_item);

    `uvm_component_utils(dio_sequencer)

    function new(string name = "dio_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

endclass : dio_sequencer