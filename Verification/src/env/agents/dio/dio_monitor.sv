
import macro_pkg::*;

class dio_monitor extends uvm_monitor;

    `uvm_component_utils(dio_monitor)

    // instantiation of internal objects
    dio_config dio_cfg;
    virtual dio_interface vif;
    dio_seq_item dio_pkt_in;

    uvm_analysis_port#(dio_seq_item) dio_mon_port;

    int pv [11], cv [11];

    function new(string name = "dio_monitor", uvm_component parent = null);
        super.new(name,parent);

        dio_mon_port = new("dio_mon_port", this);

    endfunction : new

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(!uvm_config_db#(virtual dio_interface)::get(this, "", "d_vif", vif)) begin
            `uvm_error("DIO_MTR", {"virtual interface must be set for: ", get_full_name(), "vif"})
        end

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            create_handle();
            dio_capture();
            write_transaction();
        end

    endtask : run_phase

    task dio_capture();
        fork
            `MONITOR_WATCH(vif.RST, "RST", dio_pkt_in.name, dio_pkt_in.value, pv[0], cv[0])
            `MONITOR_WATCH(vif.start_in, "start", dio_pkt_in.name, dio_pkt_in.value, pv[1], cv[1])
            `MONITOR_WATCH(vif.spi_mode_in, "spi_mode", dio_pkt_in.name, dio_pkt_in.value, pv[2], cv[2])
            `MONITOR_WATCH(vif.sck_speed_in, "sck_speed", dio_pkt_in.name, dio_pkt_in.value, pv[3], cv[3])
            `MONITOR_WATCH(vif.word_len_in, "word_len", dio_pkt_in.name, dio_pkt_in.value, pv[4], cv[4])
            `MONITOR_WATCH(vif.IFG_in, "IFG", dio_pkt_in.name, dio_pkt_in.value, pv[5], cv[5])
            `MONITOR_WATCH(vif.CS_SCK_in, "CS_SCK", dio_pkt_in.name, dio_pkt_in.value, pv[6], cv[6])
            `MONITOR_WATCH(vif.SCK_CS_in, "SCK_CS", dio_pkt_in.name, dio_pkt_in.value, pv[7], cv[7])
            `MONITOR_WATCH(vif.mosi_data_in, "mosi_data", dio_pkt_in.name, dio_pkt_in.value, pv[8], cv[8])
            `MONITOR_WATCH(vif.busy_out, "busy", dio_pkt_in.name, dio_pkt_in.value, pv[9], cv[9])
            `MONITOR_WATCH(vif.miso_data_out, "miso_data", dio_pkt_in.name, dio_pkt_in.value, pv[10], cv[10])
        join_any
        disable fork;
    endtask : dio_capture

    task create_handle();
        dio_pkt_in = dio_seq_item::type_id::create("dio_pkt_in");
    endtask : create_handle

    task write_transaction();
        `uvm_info("DIO_MTR", "Writing collected dio_mon_pkt onto dio_mon_port", UVM_LOW)
        dio_mon_port.write(dio_pkt_in);
    endtask : write_transaction

endclass: dio_monitor
