
class dio_seq_item extends uvm_sequence_item;

    // requested inputs
    bit start_out;
    //
    bit [1:0] spi_mode_out;
    bit [1:0] sck_speed_out;
    bit [1:0] word_len_out;
    //
    bit [7:0] IFG_out;
    bit [7:0] CS_SCK_out;
    bit [7:0] SCK_CS_out;
    //
    rand bit [31:0] mosi_data_out;

    // received outputs
    bit busy_in;
    //
    bit [31:0] miso_data_in;

    `uvm_object_utils_begin(dio_seq_item)
        `uvm_field_int(start_out, UVM_DEFAULT)
        `uvm_field_int(spi_mode_out, UVM_DEFAULT)
        `uvm_field_int(sck_speed_out, UVM_DEFAULT)
        `uvm_field_int(word_len_out, UVM_DEFAULT)
        `uvm_field_int(IFG_out, UVM_DEFAULT)
        `uvm_field_int(CS_SCK_out, UVM_DEFAULT)
        `uvm_field_int(SCK_CS_out, UVM_DEFAULT)
        `uvm_field_int(mosi_data_out, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "dio_seq_item");
        super.new(name);
    endfunction : new

endclass : dio_seq_item
