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

endclass : base_reset_sequence

class reset_seq_assert extends base_reset_sequence;

    `uvm_object_utils(reset_seq_assert)

    function new (string name = "reset_seq_assert");
        super.new(name);
    endfunction : new

    task pre_body();

        rst_pkt = reset_seq_item::type_id::create("rst_pkt");

    endtask : pre_body

    task body();

        start_item(rst_pkt);
        assert_reset();
        finish_item(rst_pkt);

    endtask : body

endclass : reset_seq_assert

class reset_seq_deassert extends base_reset_sequence;

    `uvm_object_utils(reset_seq_deassert)

    function new (string name = "reset_seq_deassert");
        super.new(name);
    endfunction : new

    task pre_body();

        rst_pkt = reset_seq_item::type_id::create("rst_pkt");

    endtask : pre_body

    task body();

            start_item(rst_pkt);
            deassert_reset();
            finish_item(rst_pkt);

    endtask : body

endclass : reset_seq_deassert