import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class dio_seq_item extends uvm_sequence_item;

    // requested inputs
    bit start_in;
    //
    bit [1:0] spi_mode_in;
    bit [1:0] sck_speed_in;
    bit [1:0] word_len_in;
    //
    bit [7:0] IFG_in;
    bit [7:0] CS_SCK_in;
    bit [7:0] SCK_CS_in;
    //
    rand bit [31:0] mosi_data_in;

    // received outputs
    bit busy_out;
    //
    bit [31:0] miso_data_out;

    `uvm_object_utils_begin(dio_seq_item)
        `uvm_field_int(start_in, UVM_DEFAULT)
        `uvm_field_int(spi_mode_in, UVM_DEFAULT)
        `uvm_field_int(sck_speed_in, UVM_DEFAULT)
        `uvm_field_int(word_len_in, UVM_DEFAULT)
        `uvm_field_int(IFG_in, UVM_DEFAULT)
        `uvm_field_int(CS_SCK_in, UVM_DEFAULT)
        `uvm_field_int(SCK_CS_in, UVM_DEFAULT)
        `uvm_field_int(mosi_data_in, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "dio_seq_item");
        super.new(name);
    endfunction : new

    // constraint status_chk {start_in != busy_out;}
    constraint true_timing_params {IFG_in    > 0;
                                   CS_SCK_in > 0;
                                   SCK_CS_in > 0;}
endclass : dio_seq_item

tutaj zrobic tylko 2 pola:
name,
value.