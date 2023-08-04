
class test_0300 extends test_base;

    `uvm_component_utils(test_0300)

    test_0300_sequence seq_0300;

    function new (string name = "test_0300", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        seq_0300 = test_0300_sequence::type_id::create("seq_0300");

        phase.raise_objection(this);
            `uvm_info(get_name(), "starting test 0300", UVM_LOW)
            seq_0300.start(env.v_sqr);
        phase.drop_objection(this);
    endtask : run_phase

endclass : test_0300