
class clock_seq_item extends uvm_sequence_item;

    // requested inputs:
    time period;

    function new (string name = "clock_seq_item");
        super.new(name);
    endfunction : new

    `uvm_object_utils_begin(clock_seq_item)
        `uvm_field_int(period, UVM_DEFAULT | UVM_TIME)
    `uvm_object_utils_end

endclass : clock_seq_item
