
class test_0040 extends test_base;

    `uvm_component_utils(test_0040)

    test_0040_sequence seq_0040;

    // constructor
    function new (string name = "test_0040", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        seq_0040 = test_0040_sequence::type_id::create("seq_0040");

        phase.raise_objection(this); // start time consumption
            `uvm_info(get_name(), "starting test cases for test 0040", UVM_LOW)
            seq_0040.start(env.v_sqr);
        phase.drop_objection(this); // end time consumption

    endtask : run_phase

endclass : test_0040