
    // import clock_pkg::*;

class test_base_sequence extends uvm_sequence;

    `uvm_object_utils(test_base_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    clock_sequence_start clk_seq_start;
    dio_sequence_reset dio_seq_reset;
    dio_sequence_start dio_seq_start;
    dio_sequence_1 dio_seq_1;

    function new (string name = "base_test_sequence");
        super.new(name);
    endfunction : new

    task pre_body();
        clk_seq_start = clock_sequence_start::type_id::create("clk_seq_start");
        dio_seq_reset = dio_sequence_reset::type_id::create("dio_seq_reset");
        dio_seq_start = dio_sequence_start::type_id::create("dio_seq_start");
        dio_seq_1 = dio_sequence_1::type_id::create("dio_seq_1");
    endtask : pre_body

    // task body();

    // endtask : body

    task post_body();


    endtask : post_body

endclass : test_base_sequence

