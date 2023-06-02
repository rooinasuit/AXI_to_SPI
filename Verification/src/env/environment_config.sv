
class environment_config extends uvm_object;

    `uvm_object_utils(environment_config)

    clock_config     clk_cfg;
    dio_config       dio_cfg;
    spi_slave_config slv_cfg;

    function new (string name = "environment_config");
        super.new(name);
    endfunction : new

endclass : environment_config