
class tb_environment extends uvm_env;

    `uvm_component_utils(tb_environment)

    // instantiation of internal object
    environment_config env_cfg;

    virtual_sequencer v_sqr;

    // clock_agent     clk_agt;
    dio_agent       dio_agt;
    spi_slave_agent slv_agt;

    tb_scoreboard scb;

    function new(string name = "tb_environment", uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(environment_config)::get(this, "", "environment_config", env_cfg)) begin
            `uvm_error("ENV", {"environment config must be set for: ", get_full_name(), " env_cfg"})
        end

        // uvm_config_db#(clock_config)::set(null, "*clk_agt", "clock_config", env_cfg.clk_cfg);
        uvm_config_db#(dio_config)::set(null, "*dio_agt", "dio_config", env_cfg.dio_cfg);
        uvm_config_db#(spi_slave_config)::set(null, "*slv_agt", "spi_slave_config", env_cfg.slv_cfg);

        // `uvm_info("ENV", "Creating CLK_AGT handle", UVM_LOW)
        // clk_agt = clock_agent::type_id::create("clk_agt", this);

        `uvm_info("ENV", "Creating DIO_AGT handle", UVM_LOW)
        dio_agt = dio_agent::type_id::create("dio_agt", this);

        `uvm_info("ENV", "Creating SLV_AGENT handle", UVM_LOW)
        slv_agt = spi_slave_agent::type_id::create("slv_agt", this);

        `uvm_info("ENV", "Creating SCB handle", UVM_LOW)
        scb = tb_scoreboard::type_id::create("scb", this);

        `uvm_info("ENV", "Creating V_SQR handle", UVM_LOW)
        v_sqr = virtual_sequencer::type_id::create("v_sqr", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        `uvm_info("ENV", "Connecting ports: dio_mon_port -> dio_mon_imp", UVM_LOW)
        dio_agt.dio_mtr.dio_mon_port.connect(scb.dio_mon_imp);

        `uvm_info("ENV", "Connecting ports: slv_mon_port -> slv_mon_imp", UVM_LOW)
        slv_agt.slv_mtr.slv_mon_port.connect(scb.slv_mon_imp);

        // `uvm_info("ENV", "Connecting sequencers: clk_sqr -> virtual_sqr", UVM_LOW)
        // v_sqr.clk_sqr = clk_agt.clk_sqr;

        `uvm_info("ENV", "Connecting sequencers: dio_sqr -> virtual_sqr", UVM_LOW)
        v_sqr.dio_sqr = dio_agt.dio_sqr;

        `uvm_info("ENV", "Connecting sequencers: slv_sqr -> virtual_sqr", UVM_LOW)
        v_sqr.slv_sqr = slv_agt.slv_sqr;

    endfunction : connect_phase

endclass: tb_environment
