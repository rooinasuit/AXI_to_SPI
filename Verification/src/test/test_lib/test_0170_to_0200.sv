
class test_0170_to_0200 extends test_base;

    `uvm_component_utils(test_0170_to_0200)

    test_0170_to_0200_sequence seq_0170_to_0200;

    // constructor
    function new (string name = "test_0170_to_0200", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        seq_0170_to_0200 = test_0170_to_0200_sequence::type_id::create("seq_0170_to_0200");

        phase.raise_objection(this); // start time consumption
            `uvm_info(get_name(), "starting test 0170_to_0200", UVM_LOW)
            seq_0170_to_0200.start(env.v_sqr);
        phase.drop_objection(this); // end time consumption

    endtask : run_phase

endclass : test_0170_to_0200