
class test_base extends uvm_test;

    `uvm_component_utils(test_base)

    // clock_config     clk_cfg;
    dio_config       dio_cfg;
    spi_slave_config slv_cfg;
    environment_config env_cfg;

    tb_environment env;

    // constructor
    function new (string name = "test_base", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("TEST", "Creating AGT_CFG handles", UVM_LOW)
        // clk_cfg = clock_config::type_id::create("clk_cfg", this);
        dio_cfg = dio_config::type_id::create("dio_cfg", this);
        slv_cfg = spi_slave_config::type_id::create("slv_cfg", this);

        env_cfg = environment_config::type_id::create("env_cfg", this);

        `uvm_info("TEST", "Creating ENV handle", UVM_LOW)
        env = tb_environment::type_id::create("env", this);

        uvm_config_db #(environment_config)::set(this, "*", "environment_config", env_cfg);

    endfunction : build_phase

endclass : test_base