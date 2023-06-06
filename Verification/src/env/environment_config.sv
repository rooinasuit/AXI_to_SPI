
class environment_config extends uvm_object;

    `uvm_object_utils(environment_config)

    // clock_config     clk_cfg;
    dio_config       dio_cfg;
    spi_slave_config slv_cfg;

    // bit clock_enable;

    function new (string name = "environment_config");
        super.new(name);
        // clk_cfg = new("clk_cfg");
        dio_cfg = new("dio_cfg");
        slv_cfg = new("slv_cfg");
    endfunction : new

endclass : environment_config