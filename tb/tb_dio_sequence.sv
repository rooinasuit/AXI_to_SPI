import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class dio_sequence extends uvm_sequence#(dio_seq_item);

    `uvm_object_utils(dio_sequence)

    dio_seq_item dio_pkt;

    int seq_cnt = 5;

    function new (string name = "dio_sequence");
        super.new(name);
    endfunction : new

    task body();

        repeat(seq_cnt) begin
            dio_pkt = dio_seq_item::type_id::create("dio_pkt");
            start_item(dio_pkt);
            random_val();
            finish_item(dio_pkt);
        end

    endtask : body

    function void random_val();
        dio_pkt.mosi_data_in = $urandom_range(0,100);
    endfunction : random_val

endclass : dio_sequence