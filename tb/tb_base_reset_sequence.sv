import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class base_reset_sequence extends uvm_sequence#(reset_seq_item);

    `uvm_object_utils(base_reset_sequence)

    reset_seq_item rst_pkt;

    function new (string name = "base_reset_sequence");
        super.new(name);
    endfunction : new

    task assert_reset();
        rst_pkt.RST = 1'b1;
    endtask : assert_reset

    task deassert_reset();
        rst_pkt.RST = 1'b0;
    endtask : deassert_reset

    // task body();

    //     deassert_reset();
    //     initial begin
    //         rst_pkt = reset_seq_item::type_id::create("rst_pkt");
    //         start_item(rst_pkt);
    //         assert_reset();
    //         finish_item(rst_pkt);
    //     end

    // endtask : body

endclass : base_reset_sequence