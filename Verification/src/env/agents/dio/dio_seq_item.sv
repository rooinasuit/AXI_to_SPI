
class dio_seq_item extends uvm_sequence_item;

    string name;
    int value;

    `uvm_object_utils_begin(dio_seq_item)
        `uvm_field_string(name, UVM_DEFAULT)
        `uvm_field_int(value, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "dio_seq_item");
        super.new(name);
    endfunction : new

endclass : dio_seq_item
