
class spi_base_sequence extends uvm_sequence#(spi_seq_item);

    `uvm_object_utils(spi_base_sequence)

    spi_seq_item spi_pkt;
    spi_seq_item spi_rsp;

    function new (string name = "spi_base_sequence");
        super.new(name);
    endfunction : new

    task body();

    endtask : body

    task drive_spi(string name, logic value [$]);
        spi_pkt.name  = name;
        spi_pkt.data = value;
    endtask : drive_spi

    task drive_spi_random(string name);
        spi_pkt.name  = name;
        // spi_pkt.data = $urandom;
    endtask : drive_spi_random

    task check_rsp(string name);
        spi_rsp = spi_seq_item::type_id::create("spi_rsp");
        get_response(spi_rsp);
    endtask : check_rsp

endclass : spi_base_sequence