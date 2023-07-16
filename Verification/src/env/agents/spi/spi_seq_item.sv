
class spi_seq_item extends uvm_sequence_item;

    string item_type;

    string name;
    int value;

    int obs_time_stamp; // make those equeal to $time or $realtime
    int exp_time_stamp_min;
    int exp_time_stamp_max;

    // min time between rising and falling edges
    // max time between rising and falling edges
    // also get info on d of the spi square wave
    // measure freq and d

    `uvm_object_utils_begin(spi_seq_item)
        `uvm_field_string(item_type, UVM_DEFAULT)
        `uvm_field_string(name, UVM_DEFAULT)
        `uvm_field_int(value, UVM_DEFAULT)
        `uvm_field_int(obs_time_stamp, UVM_DEFAULT)
        `uvm_field_int(exp_time_stamp_min, UVM_DEFAULT)
        `uvm_field_int(exp_time_stamp_max, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "spi_seq_item");
        super.new(name);
    endfunction : new

endclass : spi_seq_item
