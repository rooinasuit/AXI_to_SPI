
`uvm_analysis_imp_decl(_dio_scb2rfm)
`uvm_analysis_imp_decl(_spi_scb2rfm)

class ref_model extends uvm_component;

    `uvm_component_utils(ref_model)

    uvm_analysis_imp_dio_scb2rfm#(dio_seq_item, ref_model) dio_scb_imp;
    uvm_analysis_imp_spi_scb2rfm#(spi_seq_item, ref_model) spi_scb_imp;

    uvm_analysis_port#(dio_seq_item) dio_pred_port;
    uvm_analysis_port#(spi_seq_item) spi_pred_port;

    function new(string name = "ref_model", uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        dio_scb_imp = new("dio_scb_imp", this);
        spi_scb_imp = new("spi_scb_imp", this);

        dio_pred_port = new("dio_pred_port", this);
        spi_pred_port = new("spi_pred_port", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

    // here we will compare :D

    endtask : run_phase

    function void write_dio_scb2rfm(dio_seq_item dio_pkt_in);

        `uvm_info("CHK", $sformatf("Data received from DIO_MTR: "), UVM_LOW)
        dio_pkt_in.print();

    endfunction : write_dio_scb2rfm

    function void write_spi_scb2rfm(spi_seq_item spi_pkt_in);

        `uvm_info("CHK", $sformatf("Data received from SPI_MTR: "), UVM_LOW)
        spi_pkt_in.print();

    endfunction : write_spi_scb2rfm

endclass: ref_model
