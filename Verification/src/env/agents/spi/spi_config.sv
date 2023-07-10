
class spi_config extends uvm_object;

    `uvm_object_utils(spi_config)

    logic [1:0] spi_mode;
    logic [5:0] sck_speed;
    logic [4:0] word_len;
    virtual spi_interface vif;

    function new (string name = "spi_config");
        super.new(name);
    endfunction : new

endclass : spi_config