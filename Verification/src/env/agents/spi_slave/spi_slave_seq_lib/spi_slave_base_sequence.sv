
class spi_slave_base_sequence extends uvm_sequence#(spi_slave_seq_item);

    `uvm_object_utils(spi_slave_base_sequence)

    virtual dut_interface vif;
    spi_slave_seq_item slv_pkt;

    int seq_cnt = 100;

    function new (string name = "spi_slave_base_sequence");
        super.new(name);
    endfunction : new

    task body();

        repeat(seq_cnt) begin
            slv_pkt = spi_slave_seq_item::type_id::create("slv_pkt");
            start_item(slv_pkt);
            random_val();
            finish_item(slv_pkt);
        end

    endtask : body

    function void random_val();
        slv_pkt.MISO_out = {$random} % 2;
    endfunction : random_val

endclass : spi_slave_base_sequence