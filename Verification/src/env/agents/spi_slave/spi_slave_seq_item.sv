
class spi_slave_seq_item extends uvm_sequence_item;

    // // requested inputs
    // bit MISO_out;

    // // received outputs
    // bit MOSI_in;
    // bit SCLK_in;
    // bit CS_in;

    // `uvm_object_utils_begin(spi_slave_seq_item)
    //     `uvm_field_int(MISO_out, UVM_DEFAULT)
    //     `uvm_field_int(MOSI_in, UVM_DEFAULT)
    //     `uvm_field_int(SCLK_in, UVM_DEFAULT)
    //     `uvm_field_int(CS_in, UVM_DEFAULT)
    // `uvm_object_utils_end

    string name;
    int value;

    `uvm_object_utils_begin(spi_slave_seq_item)
        `uvm_field_string(name, UVM_DEFAULT)
        `uvm_field_int(value, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "spi_slave_seq_item");
        super.new(name);
    endfunction : new

endclass : spi_slave_seq_item
