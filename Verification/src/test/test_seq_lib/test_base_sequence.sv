
class test_base_sequence extends uvm_sequence;

    `uvm_object_utils(test_base_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    time clock_cycle = 10ns;

    function new (string name = "base_test_sequence");
        super.new(name);
    endfunction : new

    task body();

    endtask : body

    task config_dio_params(logic [1:0] spi_mode = 0, logic [1:0] sck_speed = 0, logic [1:0] word_len = 0,
                        logic [7:0] IFG = 0, logic [7:0] CS_SCK = 0, logic [7:0] SCK_CS = 0,
                        logic [31:0] mosi_data = 0);

        drive_io("spi_mode", spi_mode);
        drive_io("sck_speed", sck_speed);
        drive_io("word_len", word_len);
        drive_io("IFG", IFG);
        drive_io("CS_SCK", CS_SCK);
        drive_io("SCK_CS", SCK_CS);
        drive_io("mosi_data", mosi_data);

    endtask : config_dio_params

    task send_spi(logic MISO [$] = {0});

        drive_spi("MISO", MISO);

    endtask : send_spi

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

    task wait_io(string name, int value);
        case(name)
            "busy_o": begin
                if (value == 1) begin
                    @(posedge p_sequencer.dio_sqr.vif.busy_o);
                end
                else if (value == 0) begin
                    @(negedge p_sequencer.dio_sqr.vif.busy_o);
                end
            end
            // "miso_data_o": begin
            //     @(p_sequencer.dio_sqr.vif.miso_data_o == value);
            // end
            "CS_o": begin // borrowed from spi intf
                if (value == 1) begin
                    @(posedge p_sequencer.dio_sqr.vif.CS_o);
                end
                else if (value == 0) begin
                    @(negedge p_sequencer.dio_sqr.vif.CS_o);
                end
            end
            // "NRST": begin
            //     @(p_sequencer.dio_sqr.vif.NRST == value);
            // end
            // "start_i": begin
            //     @(p_sequencer.dio_sqr.vif.start_i == value);
            // end
            // "spi_mode_i": begin
            //     @(p_sequencer.dio_sqr.vif.spi_mode_i == value);
            // end
            // "sck_speed_i": begin
            //     @(p_sequencer.dio_sqr.vif.sck_speed_i == value);
            // end
            // "word_len_i": begin
            //     @(p_sequencer.dio_sqr.vif.word_len_i == value);
            // end
            // "IFG_i": begin
            //     @(p_sequencer.dio_sqr.vif.IFG_i == value);
            // end
            // "CS_SCK_i": begin
            //     @(p_sequencer.dio_sqr.vif.CS_SCK_i == value);
            // end
            // "SCK_CS_i": begin
            //     @(p_sequencer.dio_sqr.vif.SCK_CS_i == value);
            // end
            // "mosi_data_i": begin
            //     @(p_sequencer.dio_sqr.vif.mosi_data_i == value);
            // end
            default: begin
                `uvm_error(get_name(), $sformatf("%s is not a valid port name", name))
            end
        endcase
    endtask : wait_io
    // task wait_spi_busy(time wait_buff);
    //     spi_rsp_sequence spi_seq_rsp = spi_rsp_sequence::type_id::create("spi_seq_rsp");

    //     spi_seq_rsp.name  = "CS_busy";

    //     spi_seq_rsp.start(p_sequencer.spi_sqr);
    //     #wait_buff;
    // endtask : wait_spi_busy

    // task wait_spi_ready(time wait_buff);
    //     spi_rsp_sequence spi_seq_rsp = spi_rsp_sequence::type_id::create("spi_seq_rsp");

    //     spi_seq_rsp.name  = "CS_ready";

    //     spi_seq_rsp.start(p_sequencer.spi_sqr);
    //     #wait_buff;
    // endtask : wait_spi_ready

endclass : test_base_sequence

