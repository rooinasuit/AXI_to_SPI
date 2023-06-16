
class virtual_sequencer extends uvm_sequencer;

    `uvm_component_utils(virtual_sequencer)

    // instantiation of internal objects
    // clock_sequencer clk_sqr;
    dio_sequencer dio_sqr;
    spi_sequencer spi_sqr;

    function new(string name = "virtual_sequencer", uvm_component parent);
        super.new(name,parent);
    endfunction : new

endclass : virtual_sequencer
