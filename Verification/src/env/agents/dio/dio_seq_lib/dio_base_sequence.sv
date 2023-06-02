
class dio_base_sequence extends uvm_sequence#(dio_seq_item);

    `uvm_object_utils(dio_base_sequence)

    dio_seq_item dio_pkt;

    function new (string name = "dio_base_sequence");
        super.new(name);
    endfunction : new

    task body();

    endtask : body

    task drive_io(string name, int value);
        case (name)
            "RST": dio_pkt.RST = value;
            "start_out": dio_pkt.start_out = value;

            "spi_mode_out":  dio_pkt.spi_mode_out = value;
            "sck_speed_out": dio_pkt.sck_speed_out = value;
            "word_len_out":  dio_pkt.word_len_out = value;

            "IFG_out":    dio_pkt.IFG_out = value;
            "CS_SCK_out": dio_pkt.CS_SCK_out = value;
            "SCK_CS_out": dio_pkt.SCK_CS_out = value;

            "mosi_data_out": dio_pkt.mosi_data_out = value;

            default: begin
                dio_pkt.start_out = 0;
                dio_pkt.spi_mode_out = 0;
                dio_pkt.sck_speed_out = 0;
                dio_pkt.word_len_out = 0;
                dio_pkt.IFG_out = 0;
                dio_pkt.CS_SCK_out = 0;
                dio_pkt.SCK_CS_out = 0;
                dio_pkt.mosi_data_out = 0;
            end
        endcase
    endtask : drive_io

    task drive_io_random(string name, int range);
        case (name)
            "spi_mode_out":  dio_pkt.spi_mode_out = {$urandom} % range;
            "sck_speed_out": dio_pkt.sck_speed_out = {$urandom} % range;
            "word_len_out":  dio_pkt.word_len_out = {$urandom} % range;

            "IFG_out":    dio_pkt.IFG_out = {$urandom} % range;
            "CS_SCK_out": dio_pkt.CS_SCK_out = {$urandom} % range;
            "SCK_CS_out": dio_pkt.SCK_CS_out = {$urandom} % range;

            "mosi_data_out": dio_pkt.mosi_data_out = {$urandom} % range;

            default: begin
                dio_pkt.spi_mode_out = 0;
                dio_pkt.sck_speed_out = 0;
                dio_pkt.word_len_out = 0;
                dio_pkt.IFG_out = 0;
                dio_pkt.CS_SCK_out = 0;
                dio_pkt.SCK_CS_out = 0;
                dio_pkt.mosi_data_out = 0;
            end
        endcase
    endtask : drive_io_random

endclass : dio_base_sequence
