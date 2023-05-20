import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

`uvm_analysis_imp_decl(_dio_monitor_imp)
`uvm_analysis_imp_decl(_slv_monitor_imp)

class tb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(tb_scoreboard)

    ref_model rfm;
    dio_seq_item dio_pkt_received;
    spi_slave_seq_item slv_pkt_received;

    uvm_analysis_imp_dio_monitor_imp#(dio_seq_item, tb_scoreboard) dio_in;
    uvm_analysis_imp_slv_monitor_imp#(spi_slave_seq_item, tb_scoreboard) slv_in;

    function new(string name = "tb_scoreboard", uvm_component parent = null);
        super.new(name,parent);

        dio_in = new("dio_in", this);
        slv_in = new("slv_in", this);

    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("SCB", "Creating RFM handle", UVM_LOW)
        rfm = ref_model::type_id::create("ref_model", this);

    endfunction : build_phase

    // function void connect_phase(uvm_phase phase);
    //     super.connect_phase(phase);

    //     // `uvm_info("SCB", "Connecting import: dio_mon_imp -> dio_in (RFM)", UVM_LOW)
    //     // dio_mon_imp.connect(rfm.dio_in);

    //     // `uvm_info("SCB", "Connecting import: slv_mon_imp -> slv_in (RFM)", UVM_LOW)
    //     // slv_mon_imp.connect(rfm.slv_in);

    // endfunction : connect_phase

    function void write_dio_monitor_imp(dio_seq_item dio_pkt_in);

        dio_pkt_received = dio_seq_item::type_id::create("dio_pkt_received", this);
        dio_pkt_received.copy(dio_pkt_in);
        `uvm_info("SCB", $sformatf("Data received from DIO_MTR: "), UVM_LOW)
        dio_pkt_received.print();

    endfunction : write_dio_monitor_imp

    function void write_slv_monitor_imp(spi_slave_seq_item slv_pkt_in);

        slv_pkt_received = spi_slave_seq_item::type_id::create("slv_pkt_received", this);
        slv_pkt_received.copy(slv_pkt_in);
        `uvm_info("SCB", $sformatf("Data received from SLV_MTR: "), UVM_LOW)
        slv_pkt_received.print();

    endfunction : write_slv_monitor_imp

endclass : tb_scoreboard