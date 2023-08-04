
class test_0270_to_0290 extends test_base;

    `uvm_component_utils(test_0270_to_0290)

    test_0270_to_0290_sequence seq_0270_to_0290;

    function new (string name = "test_0270_to_0290", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        seq_0270_to_0290 = test_0270_to_0290_sequence::type_id::create("seq_0270_to_0290");

        phase.raise_objection(this);
            `uvm_info(get_name(), "starting test 0270_to_0290", UVM_LOW)
            seq_0270_to_0290.start(env.v_sqr);
        phase.drop_objection(this);
    endtask : run_phase

endclass : test_0270_to_0290