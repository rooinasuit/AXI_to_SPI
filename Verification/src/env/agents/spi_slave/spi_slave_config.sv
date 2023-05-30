
class spi_slave_config extends uvm_object;

    `uvm_object_utils(spi_slave_config)

    function new (string name = "");
        super.new(name);
    endfunction : new

endclass : spi_slave_config