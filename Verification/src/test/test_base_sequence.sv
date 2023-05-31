
    // import clock_pkg::*;

class test_base_sequence extends uvm_sequence;

    `uvm_object_utils(test_base_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    clock_sequence_start clk_seq_start;

    function new (string name = "base_test_sequence");
        super.new(name);
    endfunction : new

    task pre_body();
        clk_seq_start = clock_sequence_start::type_id::create("clk_seq_start");
    endtask : pre_body

    // task body();

    // endtask : body

    task post_body();
        // finish_item(clk_seq_start);
        clk_seq_start.start(p_sequencer, this);
    endtask : post_body

endclass : test_base_sequence

