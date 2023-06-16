
// `uvm_analysis_imp_decl(_dio_monitor_imp)
// `uvm_analysis_imp_decl(_slv_monitor_imp)

class ref_model extends uvm_component;

    `uvm_component_utils(ref_model)

    // clock_seq_item clk_pkt_received; //
    // dio_seq_item dio_pkt_mtr2scb;
    // spi_slave_seq_item slv_pkt_mtr2scb;

    // uvm_analysis_imp_dio_monitor_imp#(dio_seq_item, ref_model) dio_mtr_in; // dio_pkt_in
    // uvm_analysis_imp_slv_monitor_imp#(spi_slave_seq_item, ref_model) slv_mtr_in; // slv_pkt_in

    function new(string name = "ref_model", uvm_component parent);
        super.new(name,parent);

        // dio_mtr_in = new("dio_mtr_in", this);
        // slv_mtr_in = new("slv_mtr_in", this);

    endfunction : new

    // function void write_dio_monitor_imp(dio_seq_item dio_pkt_in);

    //     dio_pkt_mtr2scb = dio_seq_item::type_id::create("dio_pkt_mtr2scb", this);
    //     dio_pkt_mtr2scb.copy(dio_pkt_in);
    //     `uvm_info("SCB", $sformatf("Data received from DIO_MTR: "), UVM_LOW)
    //     dio_pkt_mtr2scb.print();

    // endfunction : write_dio_monitor_imp

    // function void write_slv_monitor_imp(spi_slave_seq_item slv_pkt_in);

    //     slv_pkt_mtr2scb = spi_slave_seq_item::type_id::create("slv_pkt_mtr2scb", this);
    //     slv_pkt_mtr2scb.copy(slv_pkt_in);
    //     `uvm_info("SCB", $sformatf("Data received from SLV_MTR: "), UVM_LOW)
    //     slv_pkt_mtr2scb.print();

    // endfunction : write_slv_monitor_imp

endclass: ref_model
