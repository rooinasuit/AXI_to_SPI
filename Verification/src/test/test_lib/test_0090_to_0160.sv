
class test_0090_to_0160 extends test_base;

    `uvm_component_utils(test_0090_to_0160)

    test_0090_to_0160_sequence seq_0090_to_0160;

    function new (string name = "test_0090_to_0160", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        seq_0090_to_0160 = test_0090_to_0160_sequence::type_id::create("seq_0090_to_0160");

        phase.raise_objection(this);
            `uvm_info(get_name(), "starting test 0090_to_0160", UVM_LOW)
            seq_0090_to_0160.start(env.v_sqr);
        phase.drop_objection(this);
    endtask : run_phase

endclass : test_0090_to_0160