
class test_0010_sequence extends test_base_sequence;

    `uvm_object_utils(test_0010_sequence)

    function new (string name = "test_0010_sequence");
        super.new(name);
    endfunction : new

    task body();
        clk_seq = clock_period_sequence::type_id::create("clk_seq");
        dio_seq_rst = dio_drive_sequence::type_id::create("dio_seq_rst"); // 1.1
        dio_seq_nrst = dio_drive_sequence::type_id::create("dio_seq_nrst"); // 1.2
        dio_seq_params = dio_drive_sequence::type_id::create("dio_seq_params"); // 2
        dio_seq_start = dio_drive_sequence::type_id::create("dio_seq_start"); // 3.1
        dio_seq_nstart = dio_drive_sequence::type_id::create("dio_seq_nstart"); // 3.2
        // spi_slave_MOSI_random_sequence slv_seq_rnd = spi_slave_MOSI_random_sequence::create("slv_seq_rnd");

        clk_seq.start(p_sequencer.clk_sqr, this);
        dio_seq_rst.start(p_sequencer.dio_sqr, this);
        dio_seq_nrst.start(p_sequencer.dio_sqr, this);
        dio_seq_params.start(p_sequencer.dio_sqr, this);
        dio_seq_start.start(p_sequencer.dio_sqr, this);
        //
        dio_seq_nstart.start(p_sequencer.dio_sqr, this);
    endtask : body

endclass : test_0010_sequence