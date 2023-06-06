
class spi_slave_config extends uvm_object;

    `uvm_object_utils(spi_slave_config)

    int spi_mode;

    virtual spi_slave_interface vif;

    function new (string name = "spi_slave_config");
        super.new(name);
    endfunction : new

endclass : spi_slave_config