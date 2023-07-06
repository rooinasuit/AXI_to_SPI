
class spi_seq_item extends uvm_sequence_item;

    // driver
    string name;
    int value;

    // monitor - one of us
    // string name_mode0;
    // string name_mode1;
    // string name_mode2;
    // string name_mode3;
    // int value_mode0;
    // int value_mode1;
    // int value_mode2;
    // int value_mode3;

    // time freq
    // min time between rising and falling edges
    // max time between rising and falling edges
    // also get info on d of the spi square wave
    // measure freq and d

    `uvm_object_utils_begin(spi_seq_item)
        `uvm_field_string(name, UVM_DEFAULT)
        `uvm_field_int(value, UVM_DEFAULT)
        // `uvm_field_string(name_mode0, UVM_DEFAULT)
        // `uvm_field_string(name_mode1, UVM_DEFAULT)
        // `uvm_field_string(name_mode2, UVM_DEFAULT)
        // `uvm_field_string(name_mode3, UVM_DEFAULT)
        // `uvm_field_int(value_mode0, UVM_DEFAULT)
        // `uvm_field_int(value_mode1, UVM_DEFAULT)
        // `uvm_field_int(value_mode2, UVM_DEFAULT)
        // `uvm_field_int(value_mode3, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "spi_seq_item");
        super.new(name);
    endfunction : new

endclass : spi_seq_item
