
class test_0210_to_0240 extends test_base;

    `uvm_component_utils(test_0210_to_0240)

    test_0210_to_0240_sequence seq_0210_to_0240;

    // constructor
    function new (string name = "test_0210_to_0240", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        seq_0210_to_0240 = test_0210_to_0240_sequence::type_id::create("seq_0210_to_0240");

        phase.raise_objection(this); // start time consumption
            `uvm_info(get_name(), "starting test 0210_to_0240", UVM_LOW)
            seq_0210_to_0240.start(env.v_sqr);
        phase.drop_objection(this); // end time consumption

    endtask : run_phase

endclass : test_0210_to_0240