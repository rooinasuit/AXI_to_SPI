
class spi_drive_sequence extends spi_base_sequence;

    `uvm_object_utils(spi_drive_sequence)

    string name;
    logic value [$];

    function new (string name = "spi_drive_sequence");
        super.new(name);
    endfunction : new

    task body();
        spi_pkt = spi_seq_item::type_id::create("spi_pkt");

        start_item(spi_pkt);
            spi_pkt.name = name;
            spi_pkt.data = value;
        finish_item(spi_pkt);
    endtask : body

endclass : spi_drive_sequence