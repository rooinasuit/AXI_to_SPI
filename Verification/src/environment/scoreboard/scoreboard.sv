import uvm_pkg::*;
`include "uvm_macros.svh"

import scb_pkg::*;

class tb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(tb_scoreboard)

    ref_model rfm;
    tb_checker chk;

    uvm_analysis_port#(dio_seq_item) dio_mon_imp;
    uvm_analysis_port#(spi_slave_seq_item) slv_mon_imp;

    function new(string name = "tb_scoreboard", uvm_component parent = null);
        super.new(name,parent);

        dio_mon_imp = new("dio_mon_imp", this);
        slv_mon_imp = new("slv_mon_imp", this);

    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("SCB", "Creating RFM handle", UVM_LOW)
        rfm = ref_model::type_id::create("rfm", this);

        `uvm_info("SCB", "Creating CHK handle", UVM_LOW)
        chk = tb_checker::type_id::create("chk", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        `uvm_info("SCB", "Connecting import: dio_mon_imp -> dio_in (RFM)", UVM_LOW)
        dio_mon_imp.connect(rfm.dio_in);

        `uvm_info("SCB", "Connecting import: slv_mon_imp -> slv_in (RFM)", UVM_LOW)
        slv_mon_imp.connect(rfm.slv_in);

    endfunction : connect_phase

endclass : tb_scoreboard