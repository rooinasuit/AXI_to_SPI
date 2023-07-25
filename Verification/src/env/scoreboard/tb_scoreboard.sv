
import scb_pkg::*;

`uvm_analysis_imp_decl(_dio_monitor_imp)
`uvm_analysis_imp_decl(_spi_monitor_imp)

class tb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(tb_scoreboard)

    // not necessarily everything will be utilized in rfm

    string dio_items_to_rfm [] = {"NRST",
                                  "start_i",
                                  "spi_mode_i",
                                  "sck_speed_i",
                                  "word_len_i",
                                  "IFG_i",
                                  "CS_SCK_i",
                                  "SCK_CS_i",
                                  "mosi_data_i",
                                  "CS_o"};

    string dio_items_to_chk [] = {"miso_data_o",
                                  "busy_o"};

    string spi_items_to_rfm [] = {"MISO_frame"};

    string spi_items_to_chk [] = {"MOSI_frame",
                                  "min_IFG"};
                                //   "MISO_frame"};

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

        `uvm_info(get_name(), "Connecting ports: dio_rfm_port -> dio_rfm_imp", UVM_LOW)
        rfm.dio_rfm_port.connect(chk.dio_rfm_imp);

        `uvm_info(get_name(), "Connecting ports: spi_rfm_port -> spi_rfm_imp", UVM_LOW)
        rfm.spi_rfm_port.connect(chk.spi_rfm_imp);

    endfunction : connect_phase

    function void write_dio_monitor_imp(dio_seq_item item);

        if(item.name inside {dio_items_to_rfm}) begin
            rfm.write_dio(item);
        end
        else if(item.name inside {dio_items_to_chk}) begin
            chk.write_dio_observed(item);
        end

        if (item.name == "spi_mode_i") begin
            spi_cfg.spi_mode = item.value;
            // `uvm_info(get_name(), $sformatf("value of spi_mode in spi_cfg: %d", spi_cfg.spi_mode), UVM_LOW)
        end

    endfunction : write_dio_monitor_imp

    function void write_spi_monitor_imp(spi_seq_item item);

        item.print();

        if(item.name inside {spi_items_to_rfm}) begin
            rfm.write_spi(item);
        end
        else if(item.name inside {spi_items_to_chk}) begin
            chk.write_spi_observed(item);
        end

    endfunction : write_spi_monitor_imp

endclass : tb_scoreboard
