
class ref_model extends uvm_component;

    `uvm_component_utils(ref_model)

    function new(string name = "ref_model", uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

    // here we will compare :D

    endtask : run_phase

    task predict_spi(int data, time period);

    endtask : predict_spi

    // task predict_dio

    // endtask : predict_dio

    function void write_dio(dio_seq_item dio_pkt_in);

        `uvm_info(get_name(), $sformatf("Data received from DIO_MTR to predict on: "), UVM_LOW)
        dio_pkt_in.print();

    endfunction : write_dio

    function void write_spi(spi_seq_item spi_pkt_in);

        `uvm_info(get_name(), $sformatf("Data received from SPI_MTR to predict on: "), UVM_LOW)
        spi_pkt_in.print();

    endfunction : write_spi

endclass: ref_model
