
import scb_pkg::*;

`uvm_analysis_imp_decl(_dio_monitor_imp)
`uvm_analysis_imp_decl(_spi_monitor_imp)

class tb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(tb_scoreboard)

    ref_model rfm;
    tb_checker chk;

    dio_seq_item dio_pkt_mtr2scb;
    spi_seq_item spi_pkt_mtr2scb;

    uvm_analysis_imp_dio_monitor_imp#(dio_seq_item, tb_scoreboard) dio_mtr_imp;
    uvm_analysis_imp_spi_monitor_imp#(spi_seq_item, tb_scoreboard) spi_mtr_imp;

    function new(string name = "tb_scoreboard", uvm_component parent = null);
        super.new(name,parent);

        dio_mtr_imp = new("dio_mtr_imp", this);
        spi_mtr_imp = new("spi_mtr_imp", this);

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

        // `uvm_info("SCB", "Connecting import: dio_mtr_imp -> dio_mtr_in (RFM)", UVM_LOW)
        // dio_fifo_imp.connect(rfm.dio_mtr_rfm);
        // dio_fifo_imp.connect(chk.dio_mtr_cmp);

        // `uvm_info("SCB", "Connecting import: slv_mtr_imp -> slv_mtr_in (RFM)", UVM_LOW)
        // spi_fifo_imp.connect(rfm.spi_mtr_rfm);
        // spi_fifo_imp.connect(chk.spi_mtr_cmp);

    endfunction : connect_phase

    function void write_dio_monitor_imp(dio_seq_item dio_pkt_in);

        dio_pkt_mtr2scb = dio_seq_item::type_id::create("dio_pkt_mtr2scb", this);
        dio_pkt_mtr2scb.copy(dio_pkt_in);
        `uvm_info("SCB", $sformatf("Data received from DIO_MTR: "), UVM_LOW)
        dio_pkt_mtr2scb.print();

    endfunction : write_dio_monitor_imp

    function void write_spi_monitor_imp(spi_seq_item spi_pkt_in);

        spi_pkt_mtr2scb = spi_seq_item::type_id::create("spi_pkt_mtr2scb", this);
        spi_pkt_mtr2scb.copy(spi_pkt_in);
        `uvm_info("SCB", $sformatf("Data received from SPI_MTR: "), UVM_LOW)
        spi_pkt_mtr2scb.print();

    endfunction : write_spi_monitor_imp

endclass : tb_scoreboard
