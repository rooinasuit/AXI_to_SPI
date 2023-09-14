
class clock_seq_item extends uvm_sequence_item;

    string name;
    int value;

    function new (string name = "clock_seq_item");
        super.new(name);
    endfunction : new

    `uvm_object_utils_begin(clock_seq_item)
        `uvm_field_string(name, UVM_DEFAULT)
        `uvm_field_int(value, UVM_DEFAULT)
    `uvm_object_utils_end

endclass : clock_seq_item
