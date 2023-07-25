
class test_0030 extends test_base;

    `uvm_component_utils(test_0030)

    test_0030_sequence seq_0030;

    // constructor
    function new (string name = "test_0030", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        seq_0030 = test_0030_sequence::type_id::create("seq_0030");

        phase.raise_objection(this); // start time consumption
            `uvm_info(get_name(), "starting test cases for test 0030", UVM_LOW)
            seq_0030.start(env.v_sqr);
        phase.drop_objection(this); // end time consumption

    endtask : run_phase

endclass : test_0030