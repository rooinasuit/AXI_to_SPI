
class spi_base_sequence extends uvm_sequence#(spi_seq_item);

    `uvm_object_utils(spi_base_sequence)

    spi_seq_item spi_pkt;

    function new (string name = "spi_base_sequence");
        super.new(name);
    endfunction : new

    task body();

    endtask : body

    task drive_spi(string name, bit value);
        spi_pkt.name  = name;
        spi_pkt.value = value;
    endtask : drive_spi

    task drive_spi_random(string name);
        spi_pkt.name  = name;
        spi_pkt.value = $urandom;
    endtask : drive_spi_random

endclass : spi_base_sequence