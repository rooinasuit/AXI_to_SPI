
class dio_driver extends uvm_driver#(dio_seq_item);

    `uvm_component_utils(dio_driver)

    dio_config dio_cfg;

    virtual dio_interface vif;

    function new(string name = "dio_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(dio_config)::get(this, "", "dio_config", dio_cfg)) begin
            `uvm_fatal(get_name(), {"dio config must be set for: ", get_full_name()})
        end
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = dio_cfg.vif;
    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            dio_transaction();
        end
    endtask : run_phase

    task reset_io();
            vif.NRST = 0;
            vif.start_i = 0;

            vif.spi_mode_i = 0;
            vif.sck_speed_i = 0;
            vif.word_len_i = 0;

            vif.IFG_i = 0;
            vif.CS_SCK_i = 0;
            vif.SCK_CS_i = 0;

            vif.mosi_data_i = 0;
    endtask : reset_io

    task dio_transaction();
        dio_seq_item dio_pkt = dio_seq_item::type_id::create("dio_pkt");
        seq_item_port.get_next_item(dio_pkt);
        case (dio_pkt.name)
            "NRST": vif.NRST = dio_pkt.value;
            "start": vif.start_i = dio_pkt.value;

            "spi_mode": vif.spi_mode_i = dio_pkt.value;
            "sck_speed": vif.sck_speed_i = dio_pkt.value;
            "word_len":  vif.word_len_i = dio_pkt.value;

            "IFG":    vif.IFG_i = dio_pkt.value;
            "CS_SCK": vif.CS_SCK_i = dio_pkt.value;
            "SCK_CS": vif.SCK_CS_i = dio_pkt.value;

            "mosi_data": vif.mosi_data_i = dio_pkt.value;

            "reset_all" : reset_io();
            default: vif.NRST = 0;
        endcase
        seq_item_port.item_done();
    endtask : dio_transaction

endclass: dio_driver