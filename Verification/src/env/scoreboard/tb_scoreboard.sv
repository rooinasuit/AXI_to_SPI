
import scb_pkg::*;

`uvm_analysis_imp_decl(_dio_monitor_imp)
`uvm_analysis_imp_decl(_spi_monitor_imp)

class tb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(tb_scoreboard)

    string dio_items_to_rfm [] = {"RST",
                                  "start_in",
                                  "spi_mode_in",
                                  "sck_speed_in",
                                  "word_len_in",
                                  "IFG_in",
                                  "CS_SCK_in",
                                  "SCK_CS_in",
                                  "mosi_data_in"};

    string dio_items_to_chk [] = {"busy_out",
                                  "miso_data_out"};

    string spi_items_to_rfm [] = {};

    string spi_items_to_chk [] = {
                                  "MISO_frame"};

    spi_config spi_cfg;

    ref_model rfm;
    tb_checker chk;

    uvm_analysis_imp_dio_monitor_imp#(dio_seq_item, tb_scoreboard) dio_mtr_imp;
    uvm_analysis_imp_spi_monitor_imp#(spi_seq_item, tb_scoreboard) spi_mtr_imp;

    function new(string name = "tb_scoreboard", uvm_component parent = null);
        super.new(name,parent);

    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        dio_mtr_imp = new("dio_mtr_imp", this);
        spi_mtr_imp = new("spi_mtr_imp", this);

        if (!uvm_config_db #(spi_config)::get(this, "", "spi_config", spi_cfg)) begin
            `uvm_fatal(get_name(), {"spi config must be set for: ", get_full_name()})
        end

        `uvm_info(get_name(), "Creating RFM handle", UVM_LOW)
        rfm = ref_model::type_id::create("rfm", this);

        `uvm_info(get_name(), "Creating CHK handle", UVM_LOW)
        chk = tb_checker::type_id::create("chk", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

    endfunction : connect_phase

    function void write_dio_monitor_imp(dio_seq_item dio_pkt_in);

        if(dio_pkt_in.name inside {dio_items_to_rfm}) begin
            rfm.write_dio(dio_pkt_in);
        end
        else if(dio_pkt_in.name inside {dio_items_to_chk}) begin
            chk.write_dio_observed(dio_pkt_in);
        end

        case(dio_pkt_in.name)
            "spi_mode_in": begin
                spi_cfg.spi_mode = dio_pkt_in.value;
                `uvm_info(get_name(), $sformatf("value of spi_mode in spi_cfg: %d", spi_cfg.spi_mode), UVM_LOW)
            end
            "sck_speed_in": begin
                spi_cfg.sck_speed = dio_pkt_in.value;
                `uvm_info(get_name(), $sformatf("value of sck_speed in spi_cfg: %d", spi_cfg.sck_speed), UVM_LOW)
            end
            "word_len_in": begin
                case (dio_pkt_in.value)
                    0: spi_cfg.word_len = 31;
                    1: spi_cfg.word_len = 15;
                    2: spi_cfg.word_len = 7;
                    3: spi_cfg.word_len = 3;
                endcase
                `uvm_info(get_name(), $sformatf("value of word_len in spi_cfg: %d(%d)", dio_pkt_in.value, spi_cfg.word_len), UVM_LOW)
            end
        endcase

    endfunction : write_dio_monitor_imp

    function void write_spi_monitor_imp(spi_seq_item spi_pkt_in);

        if(spi_pkt_in.name inside {spi_items_to_rfm}) begin
            rfm.write_spi(spi_pkt_in);
        end
        if(spi_pkt_in.name inside {spi_items_to_chk}) begin
            chk.write_spi_observed(spi_pkt_in);
        end

    endfunction : write_spi_monitor_imp

endclass : tb_scoreboard
