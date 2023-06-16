
class spi_drive_random_sequence extends spi_base_sequence;

    `uvm_object_utils(spi_drive_random_sequence)

    string name;

    function new (string name = "spi_drive_random_sequence");
        super.new(name);
    endfunction : new

    task body();
        spi_pkt = spi_seq_item::type_id::create("spi_pkt");

        start_item(spi_pkt);
            drive_spi_random(name);
        finish_item(spi_pkt);
    endtask : body

endclass : spi_drive_random_sequence