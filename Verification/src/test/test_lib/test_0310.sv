
class test_0310 extends test_base;

    `uvm_component_utils(test_0310)

    test_0310_sequence seq_0310;

    // constructor
    function new (string name = "test_0310", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        seq_0310 = test_0310_sequence::type_id::create("seq_0310");

        phase.raise_objection(this); // start time consumption
            `uvm_info(get_name(), "starting test 0310", UVM_LOW)
            seq_0310.start(env.v_sqr);
        phase.drop_objection(this); // end time consumption

    endtask : run_phase

endclass : test_0310