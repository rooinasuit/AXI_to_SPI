
class spi_slave_base_sequence extends uvm_sequence#(spi_slave_seq_item);

    `uvm_object_utils(spi_slave_base_sequence)

    spi_slave_seq_item slv_pkt;

    function new (string name = "spi_slave_base_sequence");
        super.new(name);
    endfunction : new

    task body();

    endtask : body

    task drive_spi(string name, bit value);
        slv_pkt.name  = name;
        slv_pkt.value = value;
    endtask : drive_spi

    task drive_spi_random(string name);
        slv_pkt.name  = name;
        slv_pkt.value = {$urandom} % 2;
    endtask : drive_spi_random

endclass : spi_slave_base_sequence