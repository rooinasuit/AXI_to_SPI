
class environment_config extends uvm_object;

    `uvm_object_utils(environment_config)

    virtual clock_interface c_vif;
    virtual dio_interface   d_vif;
    virtual spi_interface   s_vif;

    clock_config clk_cfg;
    dio_config   dio_cfg;
    spi_config   spi_cfg;

    // scoreboard_config scb_cfg;

    function new (string name = "environment_config");
        super.new(name);
        clk_cfg = new("clk_cfg");
        dio_cfg = new("dio_cfg");
        spi_cfg = new("spi_cfg");

        // scb_cfg = new("scb_cfg");
    endfunction : new

endclass : environment_config