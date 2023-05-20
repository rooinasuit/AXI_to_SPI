import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class base_virtual_sequence extends uvm_sequence;

    `uvm_object_utils(base_virtual_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    reset_seq_assert rst_seq_1;
    reset_seq_deassert rst_seq_0;

    dio_sequence dio_seq_1;
    spi_slave_sequence slv_seq_1;

    function new (string name = "virtual_sequence");
        super.new(name);
    endfunction

    task pre_body();

        `uvm_info("TEST_1", $sformatf("Creating: rst_seq_1"), UVM_LOW)
        rst_seq_1 = reset_seq_assert::type_id::create("rst_seq_1");

        `uvm_info("TEST_1", $sformatf("Creating: rst_seq_0"), UVM_LOW)
        rst_seq_0 = reset_seq_deassert::type_id::create("rst_seq_0");

        `uvm_info("TEST_1", $sformatf("Creating: dio_seq_1"), UVM_LOW)
        dio_seq_1 = dio_sequence::type_id::create("dio_seq_1");

        `uvm_info("TEST_1", $sformatf("Creating: slv_seq_1"), UVM_LOW)
        slv_seq_1 = spi_slave_sequence::type_id::create("slv_seq_1");

    endtask : pre_body

    task body();

        rst_seq_1.start(p_sequencer.rst_sqr);
        rst_seq_0.start(p_sequencer.rst_sqr);
        fork
        dio_seq_1.start(p_sequencer.dio_sqr);
        slv_seq_1.start(p_sequencer.slv_sqr);
        join

    endtask : body

endclass : base_virtual_sequence