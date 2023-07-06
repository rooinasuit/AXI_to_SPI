
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

        dio_seq.name  = port_name;
        dio_seq.value = port_value;

        dio_seq.start(p_sequencer.dio_sqr);
    endtask : drive_io

    task drive_io_random(string port_name, int value_range);
        dio_drive_random_sequence dio_seq_rnd = dio_drive_random_sequence::type_id::create("dio_seq_rnd");

        dio_seq_rnd.name  = port_name;
        dio_seq_rnd.range = value_range;

        dio_seq_rnd.start(p_sequencer.dio_sqr);
    endtask : drive_io_random

    task drive_spi(string name, int value);
        spi_drive_sequence spi_seq = spi_drive_sequence::type_id::create("spi_seq");

        spi_seq.name  = name;
        spi_seq.value = value;

        spi_seq.start(p_sequencer.spi_sqr);
    endtask : drive_spi

    task drive_spi_random(string name);
        spi_drive_random_sequence spi_seq_rnd = spi_drive_random_sequence::type_id::create("spi_seq_rnd");

        spi_seq_rnd.name = name;

        spi_seq_rnd.start(p_sequencer.spi_sqr);
    endtask : drive_spi_random

    task config_spi(string name, int value);
        // environment_config env_cfg = environment_config::type_id::create("env_cfg", this);
        case (name)
        "spi_mode": begin
            p_sequencer.spi_sqr.spi_cfg.spi_mode = value;
        end
        "word_len": begin
            case (value)
            0: p_sequencer.spi_sqr.spi_cfg.word_len = 31;
            1: p_sequencer.spi_sqr.spi_cfg.word_len = 15;
            2: p_sequencer.spi_sqr.spi_cfg.word_len = 7;
            3: p_sequencer.spi_sqr.spi_cfg.word_len = 3;
            endcase
        end
        endcase
    endtask : config_spi

    task wait_spi_ready(time wait_buff);
        @(posedge p_sequencer.spi_sqr.vif.CS_out);
        #wait_buff;
    endtask : wait_spi_ready

endclass : test_base_sequence

