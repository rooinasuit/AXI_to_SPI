import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

// `define D_VIF d_vif.D_PORT.cb

class dio_monitor extends uvm_monitor;

    `uvm_component_utils(dio_monitor)

    // instantiation of internal objects
    virtual dut_interface vif;
    dio_seq_item dio_pkt_in;

    uvm_analysis_port#(dio_seq_item) dio_mon_port;

    function new(string name = "dio_monitor", uvm_component parent = null);
        super.new(name,parent);

        dio_mon_port = new("dio_mon_port", this);

    endfunction : new

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(!uvm_config_db#(virtual dut_interface)::get(this, get_full_name(), "vif", vif)) begin
            `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), "vif"})
        end

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        dio_pkt_in = dio_seq_item::type_id::create("dio_pkt_in");
        forever begin
            @ (posedge vif.GCLK)
                `uvm_info("DIO_MTR", "Fetching dio_pkt_in from the DUT", UVM_LOW)

                dio_pkt_in.start_in      = vif.start_in;
                dio_pkt_in.spi_mode_in   = vif.spi_mode_in;
                dio_pkt_in.sck_speed_in  = vif.sck_speed_in;
                dio_pkt_in.word_len_in   = vif.word_len_in;
                dio_pkt_in.IFG_in        = vif.IFG_in;
                dio_pkt_in.CS_SCK_in     = vif.CS_SCK_in;
                dio_pkt_in.SCK_CS_in     = vif.SCK_CS_in;
                dio_pkt_in.mosi_data_in  = vif.mosi_data_in;

                dio_pkt_in.busy_out      = vif.busy_out;
                dio_pkt_in.miso_data_out = vif.miso_data_out;

                `uvm_info("DIO_MTR", "Writing collected dio_mon_pkt onto dio_mon_port", UVM_LOW)
                dio_mon_port.write(dio_pkt_in);
        end

    endtask : run_phase

endclass: dio_monitor