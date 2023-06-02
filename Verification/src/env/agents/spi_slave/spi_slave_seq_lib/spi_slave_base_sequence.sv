
class spi_slave_base_sequence extends uvm_sequence#(spi_slave_seq_item);

    `uvm_object_utils(spi_slave_base_sequence)

    spi_slave_seq_item slv_pkt;

    function new (string name = "spi_slave_base_sequence");
        super.new(name);
    endfunction : new

    task body();

    endtask : body

    task drive_MISO(bit value);
        slv_pkt.MISO_out = value;
    endtask : drive_MISO

    task drive_MISO_random();
        slv_pkt.MISO_out = {$urandom} % 2;
    endtask : drive_MISO_random

endclass : spi_slave_base_sequence