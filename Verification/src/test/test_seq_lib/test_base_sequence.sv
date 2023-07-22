
class test_base_sequence extends uvm_sequence;

    `uvm_object_utils(test_base_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    function new (string name = "base_test_sequence");
        super.new(name);
    endfunction : new

    task body();

    endtask : body

    task drive_clock_period(int value);
        clock_period_sequence clk_p_seq = clock_period_sequence::type_id::create("clk_p_seq");

        clk_p_seq.period = value;

        clk_p_seq.start(p_sequencer.clk_sqr);
    endtask : drive_clock_period

    task drive_clock_state(bit value);
        clock_state_sequence clk_s_seq = clock_state_sequence::type_id::create("clk_s_seq");

        clk_s_seq.clock_enable = value;

        clk_s_seq.start(p_sequencer.clk_sqr);
    endtask : drive_clock_state

    task drive_io(string port_name, int port_value);
        dio_drive_sequence dio_seq = dio_drive_sequence::type_id::create("dio_seq");

        dio_seq.name  = port_name;
        dio_seq.value = port_value;

        dio_seq.start(p_sequencer.dio_sqr);
    endtask : drive_io

    task reset_io();
        dio_drive_sequence dio_seq = dio_drive_sequence::type_id::create("dio_seq");

        dio_seq.name  = "reset_all";

        dio_seq.start(p_sequencer.dio_sqr);
    endtask : reset_io

    task drive_spi(string name, logic value [$]);
        spi_drive_sequence spi_seq = spi_drive_sequence::type_id::create("spi_seq");

        spi_seq.name  = name;
        spi_seq.value = value;

        spi_seq.start(p_sequencer.spi_sqr);
    endtask : drive_spi

    task wait_spi_ready(time wait_buff);
        spi_rsp_sequence spi_seq_rsp = spi_rsp_sequence::type_id::create("spi_seq_rsp");

        spi_seq_rsp.name  = "CS";

        spi_seq_rsp.start(p_sequencer.spi_sqr);
        #wait_buff;
    endtask : wait_spi_ready

endclass : test_base_sequence

