
class test_base_sequence extends uvm_sequence;

    `uvm_object_utils(test_base_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    clock_period_sequence clk_seq;

    dio_drive_sequence dio_seq_rst;
    dio_drive_sequence dio_seq_nrst;

    dio_drive_sequence dio_seq_params;
    dio_drive_random_sequence dio_seq_params_rnd;

    dio_drive_sequence dio_seq_start;
    dio_drive_sequence dio_seq_nstart;

    spi_slave_MISO_sequence slv_seq;
    spi_slave_MISO_random_sequence slv_seq_rnd;

    function new (string name = "base_test_sequence");
        super.new(name);
    endfunction : new

    task body();

    endtask : body

endclass : test_base_sequence

