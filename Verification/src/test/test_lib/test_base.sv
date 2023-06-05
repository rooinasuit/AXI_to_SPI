
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

        // seq_base = test_base_sequence::type_id::create("seq_base");

    endfunction : build_phase

    ////////////////////////////////////

    // task drive_clock(time period);
    //     clock_period_sequence clk_seq = clock_period_sequence::type_id::create("clk_seq");

    //     clk_seq.period = period;
    //     if (period != 0) begin
    //         env_cfg.clock_enable = 1;
    //     end
    //     else begin
    //         env_cfg.clock_enable = 0;
    //     end

    //     clk_seq.start(env.clk_agt.clk_sqr);
    // endtask : drive_clock

    // task drive_io(string port_name, int port_value);
    //     dio_drive_sequence dio_seq = dio_drive_sequence::type_id::create("dio_seq");

    //     dio_seq.name = port_name;
    //     dio_seq.value = port_value;

    //     dio_seq.start(env.dio_agt.dio_sqr);
    // endtask : drive_io

    // task drive_io_random(string port_name, int value_range);
    //     dio_drive_random_sequence dio_seq_rnd = dio_drive_random_sequence::type_id::create("dio_seq_rnd");

    //     dio_seq_rnd.name = port_name;
    //     dio_seq_rnd.range = value_range;

    //     dio_seq_rnd.start(env.dio_agt.dio_sqr);
    // endtask : drive_io_random

    // task drive_spi(int MISO_value);
    //     spi_slave_MISO_sequence slv_seq = spi_slave_MISO_sequence::type_id::create("slv_seq");

    //     slv_seq.value = MISO_value;

    //     slv_seq.start(env.slv_agt.slv_sqr);
    // endtask : drive_spi

    // task drive_spi_random();
    //     spi_slave_MISO_random_sequence slv_seq_rnd = spi_slave_MISO_random_sequence::type_id::create("slv_seq_rnd");

    //     slv_seq_rnd.start(env.slv_agt.slv_sqr);
    // endtask : drive_spi_random

endclass : test_base