
class test_base extends uvm_test;

    `uvm_component_utils(test_base)

    clock_config clk_cfg;
    dio_config dio_cfg;
    spi_config spi_cfg;
    environment_config env_cfg;

    tb_environment env;

    // constructor
    function new (string name = "test_base", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env_cfg = environment_config::type_id::create("env_cfg", this);

        `uvm_info(get_name(), "Creating AGT_CFG handles", UVM_LOW)
        clk_cfg = clock_config::type_id::create("clk_cfg", this);
        dio_cfg = dio_config::type_id::create("dio_cfg", this);
        spi_cfg = spi_config::type_id::create("spi_cfg", this);

        uvm_config_db #(environment_config)::set(this, "env", "environment_config", env_cfg);
        `uvm_info(get_name(), "Creating ENV handle", UVM_LOW)
        env = tb_environment::type_id::create("env", this);

        uvm_config_db#(virtual clock_interface)::get(this, "env_cfg", "c_vif", env_cfg.clk_cfg.vif);
        uvm_config_db#(virtual dio_interface)::get(this, "env_cfg", "d_vif", env_cfg.dio_cfg.vif);
        uvm_config_db#(virtual spi_interface)::get(this, "env_cfg", "s_vif", env_cfg.spi_cfg.vif);

    endfunction : build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);

        uvm_top.print_topology();

    endfunction : end_of_elaboration_phase

endclass : test_base
