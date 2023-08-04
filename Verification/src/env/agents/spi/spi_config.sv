
class spi_config extends uvm_object;

    `uvm_object_utils(spi_config)

    virtual spi_interface vif;
    //
    logic [1:0] spi_mode;

    function new (string name = "spi_config");
        super.new(name);
    endfunction : new

endclass : spi_config