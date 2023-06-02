
class dio_seq_item extends uvm_sequence_item;

    // requested inputs
    logic RST;

    logic start_out;
    //
    logic [1:0] spi_mode_out;
    logic [1:0] sck_speed_out;
    logic [1:0] word_len_out;
    //
    logic [7:0] IFG_out;
    logic [7:0] CS_SCK_out;
    logic [7:0] SCK_CS_out;
    //
    rand logic [31:0] mosi_data_out;

    // received outputs
    logic busy_in;
    //
    logic [31:0] miso_data_in;

    `uvm_object_utils_begin(dio_seq_item)
        `uvm_field_int(RST, UVM_DEFAULT)
        `uvm_field_int(start_out, UVM_DEFAULT)
        `uvm_field_int(spi_mode_out, UVM_DEFAULT)
        `uvm_field_int(sck_speed_out, UVM_DEFAULT)
        `uvm_field_int(word_len_out, UVM_DEFAULT)
        `uvm_field_int(IFG_out, UVM_DEFAULT)
        `uvm_field_int(CS_SCK_out, UVM_DEFAULT)
        `uvm_field_int(SCK_CS_out, UVM_DEFAULT)
        `uvm_field_int(mosi_data_out, UVM_DEFAULT)
        `uvm_field_int(busy_in, UVM_DEFAULT)
        `uvm_field_int(miso_data_in, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "dio_seq_item");
        super.new(name);
    endfunction : new

endclass : dio_seq_item
