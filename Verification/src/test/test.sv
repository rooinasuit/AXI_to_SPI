import uvm_pkg::*;
`include "uvm_macros.svh"

    `include "environment.sv"

class tb_base_test extends uvm_test;

    `uvm_component_utils(tb_base_test)

    // constructor
    function new (string name = "tb_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // uvm_config_db#(virtual dut_interface)::get(null, "*", "vif", itf);
        // uvm_config_db#(virtual dut_interface)::set(null, "*", "vif", itf);

        `uvm_info("TEST", "Creating ENV handle", UVM_LOW)
        env = tb_environment::type_id::create("env", this);

    endfunction : build_phase

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
    base_virtual_sequence v_seq;

    // constructor
    function new (string name = "test_1", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("TEST_1", $sformatf("Creating: v_seq"), UVM_LOW)
        v_seq = base_virtual_sequence::type_id::create("v_seq");

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        env.clk_agt.clk_drv.period = PERIOD;

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this); // start time consumption
        begin
            `uvm_info("TEST_1", "test_1 reporting for duty, generating sequences", UVM_LOW)

            v_seq.start(env.v_sqr);

        end
        phase.drop_objection(this); // end time consumption

    endtask : run_phase

endclass : test_1