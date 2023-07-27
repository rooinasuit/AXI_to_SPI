
class test_0010_0020 extends test_base;

    `uvm_component_utils(test_0010_0020)

    test_0010_0020_sequence seq_0010_0020;

    // constructor
    function new (string name = "test_0010_0020", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        seq_0010_0020 = test_0010_0020_sequence::type_id::create("seq_0010_0020");

        phase.raise_objection(this); // start time consumption
            `uvm_info(get_name(), "starting test 0010_0020", UVM_LOW)
            seq_0010_0020.start(env.v_sqr);
        phase.drop_objection(this); // end time consumption

    endtask : run_phase

endclass : test_0010_0020