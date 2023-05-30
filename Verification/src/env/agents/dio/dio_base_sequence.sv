
class dio_base_sequence extends uvm_sequence#(dio_seq_item);

    `uvm_object_utils(dio_base_sequence)

    dio_seq_item dio_pkt;

    function new (string name = "dio_base_sequence");
        super.new(name);
    endfunction : new

    task drive_io(string name, bit value);

        case (name)
        "start_out": dio_pkt.start_out = value;

        "spi_mode_out":  dio_pkt.spi_mode_out = value;
        "sck_speed_out": dio_pkt.sck_speed_out = value;
        "word_len_out":  dio_pkt.word_len_out = value;

        "IFG_out":    dio_pkt.IFG_out = value;
        "CS_SCK_out": dio_pkt.CS_SCK_out = value;
        "SCK_CS_out": dio_pkt.SCK_CS_out = value;

        "mosi_data_out": dio_pkt.mosi_data_out = value;

        default: dio_pkt.start_out = 0;
        endcase

    endtask : drive_io

    task drive_io_random(string name, int range);

        case (name)
        "start_out": dio_pkt.start_out = {$random} % range;

        "spi_mode_out":  dio_pkt.spi_mode_out = {$random} % range;
        "sck_speed_out": dio_pkt.sck_speed_out = {$random} % range;
        "word_len_out":  dio_pkt.word_len_out = {$random} % range;

        "IFG_out":    dio_pkt.IFG_out = {$random} % range;
        "CS_SCK_out": dio_pkt.CS_SCK_out = {$random} % range;
        "SCK_CS_out": dio_pkt.SCK_CS_out = {$random} % range;

        "mosi_data_out": dio_pkt.mosi_data_out = {$random} % range;

        default: dio_pkt.start_out = 0;
        endcase

    endtask : drive_io_random

endclass : dio_base_sequence

class dio_sequence_start extends dio_base_sequence;

    `uvm_object_utils(dio_sequence_start)

    function new (string name = "dio_sequence");
        super.new(name);
    endfunction : new

    task pre_body();

        dio_pkt = dio_seq_item::type_id::create("dio_pkt");

    endtask : pre_body

    task body();

        repeat(1) begin

            start_item(dio_pkt);
            drive_io("start_out", 1);
            finish_item(dio_pkt);

        end

    endtask : body

endclass : dio_sequence_start

class dio_sequence_1 extends dio_base_sequence;

    `uvm_object_utils(dio_sequence_1)

    function new (string name = "dio_sequence");
        super.new(name);
    endfunction : new

    task pre_body();

        dio_pkt = dio_seq_item::type_id::create("dio_pkt");

    endtask : pre_body

    task body();

        repeat(1) begin

            start_item(dio_pkt);
            drive_io("spi_mode_out", 2'd3);
            drive_io("sck_speed_out", 2'd3);
            drive_io("word_len_out", 2'd3);
            drive_io_random("mosi_data_out", 100);
            finish_item(dio_pkt);

        end

    endtask : body

endclass : dio_sequence_1
