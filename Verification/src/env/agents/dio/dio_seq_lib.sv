
class dio_sequence_start extends dio_base_sequence;

    `uvm_object_utils(dio_sequence_start)

    function new (string name = "dio_sequence");
        super.new(name);
    endfunction : new

    // task pre_body();

    //     dio_pkt = dio_seq_item::type_id::create("dio_pkt");

    // endtask : pre_body

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

    // task pre_body();

    //     dio_pkt = dio_seq_item::type_id::create("dio_pkt");

    // endtask : pre_body

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