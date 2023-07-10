
`uvm_analysis_imp_decl(_dio_scb2chk)
`uvm_analysis_imp_decl(_spi_scb2chk)

class tb_checker extends uvm_component;

    `uvm_component_utils(tb_checker)

    uvm_analysis_imp_dio_scb2chk#(dio_seq_item, tb_checker) dio_scb_imp;
    uvm_analysis_imp_spi_scb2chk#(spi_seq_item, tb_checker) spi_scb_imp;

    function new(string name = "tb_checker", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        dio_scb_imp = new("dio_scb_imp", this);
        spi_scb_imp = new("spi_scb_imp", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

    // here we will compare :D

    endtask : run_phase

    // function void check_phase(uvm_phase phase);
    //     super.check_phase(phase);

    // endfunction : check_phase

    // various comps
    // comparing values from imports - done with fifos
    // monitor value vs ref_model value on every different type of value
    // instantiate one macro for declaration and one for creation [for every type of value]
    // use get_comparator(), concatenate value name with _comparator
    // let it have write_received() and write_expected()
    // let the comparators be generic
    // do received_comp(seq_item) - it uses the compare function of the seq_item in question - makes the comparator more generic
    // be selective with incoming packets - incoming spi seq item will need to be selected as one of 4 different modes

    function void write_dio_scb2chk(dio_seq_item dio_pkt_in);

        `uvm_info("CHK", $sformatf("Data received from DIO_MTR: "), UVM_LOW)
        dio_pkt_in.print();

    endfunction : write_dio_scb2chk

    function void write_spi_scb2chk(spi_seq_item spi_pkt_in);

        `uvm_info("CHK", $sformatf("Data received from SPI_MTR: "), UVM_LOW)
        spi_pkt_in.print();

    endfunction : write_spi_scb2chk

endclass