
class clock_seq_item extends uvm_sequence_item;

    `uvm_object_utils(clock_seq_item)

    // requested inputs:
    logic GCLK;

    function new (string name = "clock_seq_item");
        super.new(name);
    endfunction : new

endclass : clock_seq_item
