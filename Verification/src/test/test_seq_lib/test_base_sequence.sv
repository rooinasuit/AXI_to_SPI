
class test_base_sequence extends uvm_sequence;

    `uvm_object_utils(test_base_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    function new (string name = "base_test_sequence");
        super.new(name);
    endfunction : new

    task body();
        
    endtask : body

    task drive_io(string port_name, int port_value);
        dio_drive_sequence dio_seq = dio_drive_sequence::type_id::create("dio_seq");

        dio_seq.name = port_name;
        dio_seq.value = port_value;

        dio_seq.start(p_sequencer.dio_sqr);
    endtask : drive_io

    task drive_io_random(string port_name, int value_range);
        dio_drive_random_sequence dio_seq_rnd = dio_drive_random_sequence::type_id::create("dio_seq_rnd");

        dio_seq_rnd.name = port_name;
        dio_seq_rnd.range = value_range;

        dio_seq_rnd.start(p_sequencer.dio_sqr);
    endtask : drive_io_random

    task drive_spi(int value);
        spi_drive_sequence spi_seq = spi_drive_sequence::type_id::create("spi_seq");

        spi_seq.value = value;

        spi_seq.start(p_sequencer.spi_sqr);
    endtask : drive_spi

    task drive_spi_random();
        spi_drive_random_sequence spi_seq_rnd = spi_drive_random_sequence::type_id::create("spi_seq_rnd");

        spi_seq_rnd.start(p_sequencer.spi_sqr);
    endtask : drive_spi_random

endclass : test_base_sequence

