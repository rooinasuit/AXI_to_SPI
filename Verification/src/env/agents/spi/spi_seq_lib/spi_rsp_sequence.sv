
class spi_rsp_sequence extends spi_base_sequence;

    `uvm_object_utils(spi_rsp_sequence)

    string name;
    int value;

    function new (string name = "spi_rsp_sequence");
        super.new(name);
    endfunction : new

    task body();
        spi_pkt = spi_seq_item::type_id::create("spi_pkt");

        start_item(spi_pkt);
            drive_spi(name, value);
        finish_item(spi_pkt);
        check_rsp(name);
    endtask : body

endclass : spi_rsp_sequence