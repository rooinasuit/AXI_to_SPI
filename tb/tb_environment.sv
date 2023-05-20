import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class tb_environment extends uvm_env;

    `uvm_component_utils(tb_environment)

    // instantiation of internal object
    virtual_sequencer v_sqr;

    clock_agent     clk_agt;
    reset_agent     rst_agt;
    dio_agent       dio_agt;
    spi_slave_agent slv_agt;

    tb_scoreboard   scb;

    function new(string name = "tb_environment", uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("ENV", "Creating CLK_AGT handle", UVM_LOW)
        clk_agt = clock_agent::type_id::create("clk_agt", this);

        `uvm_info("ENV", "Creating RST_AGT handle", UVM_LOW)
        rst_agt = reset_agent::type_id::create("rst_agt", this);

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

        `uvm_info("ENV", "Connecting ports: dio_mon_port -> dio_in", UVM_LOW)
        dio_agt.dio_mtr.dio_mon_port.connect(scb.dio_in);

        `uvm_info("ENV", "Connecting ports: slv_mon_port -> mon_in", UVM_LOW)
        slv_agt.slv_mtr.slv_mon_port.connect(scb.slv_in);

        // `uvm_info("ENV", "Connecting sequencers: clk_sqr -> virtual_sqr", UVM_LOW)
        // virtual_sqr.clk_sqr = clk_agt.clk_sqr;

        `uvm_info("ENV", "Connecting sequencers: rst_sqr -> virtual_sqr", UVM_LOW)
        v_sqr.rst_sqr = rst_agt.rst_sqr;

        `uvm_info("ENV", "Connecting sequencers: dio_sqr -> virtual_sqr", UVM_LOW)
        v_sqr.dio_sqr = dio_agt.dio_sqr;

        `uvm_info("ENV", "Connecting sequencers: slv_sqr -> virtual_sqr", UVM_LOW)
        v_sqr.slv_sqr = slv_agt.slv_sqr;

    endfunction : connect_phase

endclass: tb_environment