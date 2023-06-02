
import macro_pkg::*;

class dio_monitor extends uvm_monitor;

    `uvm_component_utils(dio_monitor)

    // instantiation of internal objects
    virtual dio_interface vif;
    dio_seq_item dio_pkt_in;

    uvm_analysis_port#(dio_seq_item) dio_mon_port;

    // logic old_port_val;
    // logic new_port_val;

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
        `MONITOR_WATCH_VARS
        fork
        `MONITOR_WATCH(dio_pkt_in.RST,           vif.RST,           create_handle, write_transaction)
        `MONITOR_WATCH(dio_pkt_in.start_out,     vif.start_in,      create_handle, write_transaction)
        `MONITOR_WATCH(dio_pkt_in.spi_mode_out,  vif.spi_mode_in,   create_handle, write_transaction)
        `MONITOR_WATCH(dio_pkt_in.sck_speed_out, vif.sck_speed_in,  create_handle, write_transaction)
        `MONITOR_WATCH(dio_pkt_in.word_len_out,  vif.word_len_in,   create_handle, write_transaction)
        `MONITOR_WATCH(dio_pkt_in.IFG_out,       vif.IFG_in,        create_handle, write_transaction)
        `MONITOR_WATCH(dio_pkt_in.CS_SCK_out,    vif.CS_SCK_in,     create_handle, write_transaction)
        `MONITOR_WATCH(dio_pkt_in.SCK_CS_out,    vif.SCK_CS_in,     create_handle, write_transaction)
        `MONITOR_WATCH(dio_pkt_in.mosi_data_out, vif.mosi_data_in,  create_handle, write_transaction)
        `MONITOR_WATCH(dio_pkt_in.busy_in,       vif.busy_out,      create_handle, write_transaction)
        `MONITOR_WATCH(dio_pkt_in.miso_data_in,  vif.miso_data_out, create_handle, write_transaction)
        join
    endtask : dio_capture

    task create_handle();
        `uvm_info("DIO_MTR", "Fetching dio_pkt_in from the DUT", UVM_LOW)
        dio_pkt_in = dio_seq_item::type_id::create("dio_pkt_in");
    endtask : create_handle

    task write_transaction();
        `uvm_info("DIO_MTR", "Writing collected dio_mon_pkt onto dio_mon_port", UVM_LOW)
        dio_mon_port.write(dio_pkt_in);
    endtask : write_transaction

endclass: dio_monitor
