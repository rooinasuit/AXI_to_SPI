
class tb_environment extends uvm_env;

    `uvm_component_utils(tb_environment)

    // instantiation of internal object
    environment_config env_cfg;

    virtual_sequencer v_sqr;

    clock_agent clk_agt;
    dio_agent   dio_agt;
    spi_agent   spi_agt;

    tb_scoreboard scb;

    function new(string name = "tb_environment", uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(environment_config)::get(this, "", "environment_config", env_cfg)) begin
            `uvm_error("ENV", {"environment config must be set for: ", get_full_name(), " env_cfg"})
        end

        uvm_config_db#(clock_config)::set(this, "*clk_agt", "clock_config", env_cfg.clk_cfg);
        uvm_config_db#(dio_config)::set(this, "*dio_agt", "dio_config", env_cfg.dio_cfg);
        uvm_config_db#(spi_config)::set(this, "*spi_agt", "spi_config", env_cfg.spi_cfg);

        `uvm_info("ENV", "Creating CLK_AGT handle", UVM_LOW)
        clk_agt = clock_agent::type_id::create("clk_agt", this);

        `uvm_info("ENV", "Creating DIO_AGT handle", UVM_LOW)
        dio_agt = dio_agent::type_id::create("dio_agt", this);

        `uvm_info("ENV", "Creating SPI_AGENT handle", UVM_LOW)
        spi_agt = spi_agent::type_id::create("spi_agt", this);

        `uvm_info("ENV", "Creating SCB handle", UVM_LOW)
        scb = tb_scoreboard::type_id::create("scb", this);

        `uvm_info("ENV", "Creating V_SQR handle", UVM_LOW)
        v_sqr = virtual_sequencer::type_id::create("v_sqr", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        `uvm_info("ENV", "Connecting ports: dio_mtr_port -> dio_mtr_imp", UVM_LOW)
        dio_agt.dio_mtr.dio_mtr_port.connect(scb.dio_mtr_imp);

        `uvm_info("ENV", "Connecting ports: slv_mtr_port -> slv_mtr_imp", UVM_LOW)
        spi_agt.spi_mtr.spi_mtr_port.connect(scb.spi_mtr_imp);

        `uvm_info("ENV", "Connecting sequencers: clk_sqr -> virtual_sqr", UVM_LOW)
        v_sqr.clk_sqr = clk_agt.clk_sqr;

        `uvm_info("ENV", "Connecting sequencers: dio_sqr -> virtual_sqr", UVM_LOW)
        v_sqr.dio_sqr = dio_agt.dio_sqr;

        `uvm_info("ENV", "Connecting sequencers: slv_sqr -> virtual_sqr", UVM_LOW)
        v_sqr.spi_sqr = spi_agt.spi_sqr;

        env_cfg.clk_cfg = clk_agt.clk_cfg;
        env_cfg.dio_cfg = dio_agt.dio_cfg;
        env_cfg.spi_cfg = spi_agt.spi_cfg;

    endfunction : connect_phase

endclass: tb_environment
