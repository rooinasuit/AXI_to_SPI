
class spi_base_sequence extends uvm_sequence#(spi_seq_item);

    `uvm_object_utils(spi_base_sequence)

    spi_seq_item spi_pkt;
    spi_seq_item spi_rsp;

    function new (string name = "spi_base_sequence");
        super.new(name);
    endfunction : new

    task body();
        //
    endtask : body

endclass : spi_base_sequence