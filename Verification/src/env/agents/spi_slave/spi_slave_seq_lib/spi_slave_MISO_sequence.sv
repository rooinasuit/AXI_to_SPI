
class spi_slave_MISO_sequence extends spi_slave_base_sequence;

    `uvm_object_utils(spi_slave_MISO_sequence)

    bit value;

    function new (string name = "spi_slave_MISO_sequence");
        super.new(name);
    endfunction : new

    task body();
        slv_pkt = spi_slave_seq_item::type_id::create("slv_pkt");

        start_item(slv_pkt);
            drive_MISO(value);
        finish_item(slv_pkt);
    endtask : body

endclass : spi_slave_MISO_sequence