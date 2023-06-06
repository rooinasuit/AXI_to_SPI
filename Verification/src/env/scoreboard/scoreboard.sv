
import scb_pkg::*;

class tb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(tb_scoreboard)

    ref_model rfm;
    tb_checker chk;

    uvm_analysis_port#(dio_seq_item) dio_drv_imp;
    uvm_analysis_port#(dio_seq_item) dio_mtr_imp;

    uvm_analysis_port#(spi_slave_seq_item) slv_drv_imp;
    uvm_analysis_port#(spi_slave_seq_item) slv_mtr_imp;

    function new(string name = "tb_scoreboard", uvm_component parent = null);
        super.new(name,parent);

        dio_drv_imp = new("dio_drv_imp", this);
        dio_mtr_imp = new("dio_mtr_imp", this);

        slv_drv_imp = new("slv_drv_imp", this);
        slv_mtr_imp = new("slv_mtr_imp", this);

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

        `uvm_info("SCB", "Connecting import: dio_drv_imp -> dio_drv_in (RFM)", UVM_LOW)
        dio_drv_imp.connect(rfm.dio_drv_in);

        `uvm_info("SCB", "Connecting import: dio_mtr_imp -> dio_mtr_in (RFM)", UVM_LOW)
        dio_mtr_imp.connect(rfm.dio_mtr_in);

        `uvm_info("SCB", "Connecting import: slv_drv_imp -> slv_drv_in (RFM)", UVM_LOW)
        slv_drv_imp.connect(rfm.slv_drv_in);

        `uvm_info("SCB", "Connecting import: slv_mtr_imp -> slv_mtr_in (RFM)", UVM_LOW)
        slv_mtr_imp.connect(rfm.slv_mtr_in);

    endfunction : connect_phase

endclass : tb_scoreboard