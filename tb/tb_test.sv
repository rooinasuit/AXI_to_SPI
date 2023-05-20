import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class tb_base_test extends uvm_test;

    `uvm_component_utils(tb_base_test)

    // constructor
    function new (string name = "tb_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this); // start time consumption
        begin
            `uvm_info("TEST_BASE", "tb_base_test reporting for duty", UVM_LOW)
        end
        phase.drop_objection(this); // end time consumption

    endtask : run_phase

endclass : tb_base_test

class test_1 extends tb_base_test;

    int PERIOD = 10ns; // 100MHz - as planned pre project

    `uvm_component_utils(test_1)

    // instantiation of internal objects
    tb_environment env;

    // base_reset_sequence rst_seq_1; // NEED TO INSTANTIATE A SEQUENCE EXTENDED FROM THIS ONE
    dio_sequence dio_seq_1;
    spi_slave_sequence slv_seq_1;

    // constructor
    function new (string name = "test_1", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("TEST", "Creating ENV handle", UVM_LOW)
        env = tb_environment::type_id::create("env", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        env.clk_agt.clk_drv.period = PERIOD;

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this); // start time consumption
        begin
            `uvm_info("TEST_1", "test_1 reporting for duty", UVM_LOW)

            // `uvm_info("TEST_1", $sformatf("Creating: rst_seq_1"), UVM_LOW)
            // rst_seq_1 = reset_sequence::type_id::create("rst_seq_1");
            // rst_seq_1.start(env.rst_agt.rst_sqr);

            `uvm_info("TEST_1", $sformatf("Creating: dio_seq_1"), UVM_LOW)
            dio_seq_1 = dio_sequence::type_id::create("dio_seq_1");
            dio_seq_1.start(env.dio_agt.dio_sqr);

            `uvm_info("TEST_1", $sformatf("Creating: slv_seq_1"), UVM_LOW)
            slv_seq_1 = spi_slave_sequence::type_id::create("slv_seq_1");
            slv_seq_1.start(env.slv_agt.slv_sqr);
        end
        phase.drop_objection(this); // end time consumption

    endtask : run_phase

endclass : test_1