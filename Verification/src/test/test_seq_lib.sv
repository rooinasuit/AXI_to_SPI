
// class test_sequence_1 extends test_base_sequence;

//     `uvm_object_utils(test_sequence_1)

//     function new (string name = "test_sequence_1");
//         super.new(name);
//     endfunction : new

//     task body();
//         // clk_seq_start = clock_sequence_start::type_id::create("clk_seq_start");
//         clk_seq_start.period_in = 1ns;
//         // dio_seq_start.start(p_sequencer, this);
//         // dio_seq_1.start(p_sequencer, this);
//         clk_seq_start.start(p_sequencer.clk_sqr, this);

//         dio_seq_reset.start(p_sequencer.dio_sqr, this);
//         #100;
//         // fork
//         dio_seq_start.start(p_sequencer.dio_sqr, this);
//         dio_seq_1.start(p_sequencer.dio_sqr, this);
//         // join
//     endtask : body

// endclass : test_sequence_1