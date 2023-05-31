
class dio_base_sequence extends uvm_sequence#(dio_seq_item);

    `uvm_object_utils(dio_base_sequence)

    dio_seq_item dio_pkt;

    function new (string name = "dio_base_sequence");
        super.new(name);
    endfunction : new

    task pre_body();
        dio_pkt = dio_seq_item::type_id::create("dio_pkt");
    endtask : pre_body

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
