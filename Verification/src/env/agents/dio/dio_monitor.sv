
class dio_monitor extends uvm_monitor;

    `uvm_component_utils(dio_monitor)

    // instantiation of internal objects
    dio_config dio_cfg;
    virtual dio_interface vif;

    uvm_analysis_port#(dio_seq_item) dio_mtr_port;

    function new(string name = "dio_monitor", uvm_component parent = null);
        super.new(name,parent);

    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        dio_mtr_port = new("dio_mtr_port", this);

        if (!uvm_config_db #(dio_config)::get(this, "", "dio_config", dio_cfg)) begin
            `uvm_fatal(get_name(), {"clock config must be set for: ", get_full_name()})
        end

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = dio_cfg.vif;

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        dio_capture();

    endtask : run_phase

    task dio_capture();
        dio_seq_item dio_pkt_in;
        fork
            `MONITOR_WATCH(NRST, dio)
            `MONITOR_WATCH(start_i, dio)
            `MONITOR_WATCH(spi_mode_i, dio)
            `MONITOR_WATCH(sck_speed_i, dio)
            `MONITOR_WATCH(word_len_i, dio)
            `MONITOR_WATCH(IFG_i, dio)
            `MONITOR_WATCH(CS_SCK_i, dio)
            `MONITOR_WATCH(SCK_CS_i, dio)
            `MONITOR_WATCH(mosi_data_i, dio)
            `MONITOR_WATCH(busy_o, dio)
            `MONITOR_WATCH(miso_data_o, dio)
            `MONITOR_WATCH(CS_o, dio)
        join_none
    endtask : dio_capture

endclass: dio_monitor
