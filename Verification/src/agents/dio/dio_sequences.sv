import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class base_dio_sequence extends uvm_sequence#(dio_seq_item);

    `uvm_object_utils(base_dio_sequence)

    dio_seq_item dio_pkt;

    function new (string name = "base_dio_sequence");
        super.new(name);
    endfunction : new

    task drive_io(string name, bit value);

        case (name)
        "start_in": dio_pkt.start_in = value;

        "spi_mode_in":  dio_pkt.spi_mode_in = value;
        "sck_speed_in": dio_pkt.sck_speed_in = value;
        "word_len_in":  dio_pkt.word_len_in = value;

        "IFG_in":    dio_pkt.IFG_in = value;
        "CS_SCK_in": dio_pkt.CS_SCK_in = value;
        "SCK_CS_in": dio_pkt.SCK_CS_in = value;

        "mosi_data_in": dio_pkt.mosi_data_in = value;

        default: dio_pkt.start_in = 0;
        endcase

    endtask : drive_io

    task drive_io_random(string name, int range);

        case (name)
        "start_in": dio_pkt.start_in = {$random} % range;

        "spi_mode_in":  dio_pkt.spi_mode_in = {$random} % range;
        "sck_speed_in": dio_pkt.sck_speed_in = {$random} % range;
        "word_len_in":  dio_pkt.word_len_in = {$random} % range;

        "IFG_in":    dio_pkt.IFG_in = {$random} % range;
        "CS_SCK_in": dio_pkt.CS_SCK_in = {$random} % range;
        "SCK_CS_in": dio_pkt.SCK_CS_in = {$random} % range;

        "mosi_data_in": dio_pkt.mosi_data_in = {$random} % range;

        default: dio_pkt.start_in = 0;
        endcase

    endtask : drive_io_random

endclass : base_dio_sequence

class dio_sequence_start extends base_dio_sequence;

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
            drive_io("start_in", 1);
            finish_item(dio_pkt);

        end

    endtask : body

endclass : dio_sequence_start

class dio_sequence_1 extends base_dio_sequence;

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
            drive_io("spi_mode_in", 2'd3);
            drive_io("sck_speed_in", 2'd3);
            drive_io("word_len_in", 2'd3);
            drive_io_random("mosi_data_in", 100);
            finish_item(dio_pkt);

        end

    endtask : body

endclass : dio_sequence_1
