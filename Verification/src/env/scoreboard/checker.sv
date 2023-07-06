
class tb_checker extends uvm_component;

    `uvm_component_utils(tb_checker)

    function new(string name = "tb_checker", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

    endfunction : connect_phase

    // various comps
    // comparing values from imports - done with fifos
    // monitor value vs ref_model value on every different type of value
    // instantiate one macro for declaration and one for creation [for every type of value]
    // use get_comparator(), concatenate value name with _comparator
    // let it have write_received() and write_expected()
    // let the comparators be generic
    // do received_comp(seq_item) - it uses the compare function of the seq_item in question - makes the comparator more generic
    // be selective with incoming packets - incoming spi seq item will need to be selected as one of 4 different modes

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

endclass