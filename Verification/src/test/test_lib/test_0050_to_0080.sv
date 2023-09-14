
class test_0050_to_0080 extends test_base;

    `uvm_component_utils(test_0050_to_0080)

    test_0050_to_0080_sequence seq_0050_to_0080;

    function new (string name = "test_0050_to_0080", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        seq_0050_to_0080 = test_0050_to_0080_sequence::type_id::create("seq_0050_to_0080");

        phase.raise_objection(this);
            `uvm_info(get_name(), "starting test 0050_to_0080", UVM_LOW)
            seq_0050_to_0080.start(env.v_sqr);
        phase.drop_objection(this);
    endtask : run_phase

endclass : test_0050_to_0080