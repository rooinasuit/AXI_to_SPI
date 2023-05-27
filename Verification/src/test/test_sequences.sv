import uvm_pkg::*;
`include "uvm_macros.svh"

class base_test_sequence extends uvm_sequence;

    `uvm_object_utils(base_test_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    function new (string name = "base_test_sequence");
        super.new(name);
    endfunction : new

    task pre_body();

        // `uvm_info("TEST_1", $sformatf("Creating: example_seq"), UVM_LOW)
        // example_seq = example_sequence::type_id::create("example_seq");

    endtask : pre_body

    task body();

        // example_seq.start(p_sequencer.example_agent_sqr);

    endtask : body

endclass : base_test_sequence

