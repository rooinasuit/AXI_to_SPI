import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class spi_slave_sequence extends uvm_sequence#(spi_slave_seq_item);

    `uvm_object_utils(spi_slave_sequence)

    spi_slave_seq_item slv_pkt;

    int seq_cnt = 5;

    function new (string name = "spi_slave_sequence");
        super.new(name);
    endfunction : new

    task body();

        repeat(seq_cnt) begin
            slv_pkt = spi_slave_seq_item::type_id::create("slv_pkt");
            start_item(slv_pkt);
            random_val();
            finish_item(slv_pkt);
        end

    endtask : body

    function void random_val();
        slv_pkt.MISO_in = !slv_pkt.MISO_in;
    endfunction : random_val

endclass : spi_slave_sequence