
class test_0040_0250_0260 extends test_base;

    `uvm_component_utils(test_0040_0250_0260)

    test_0040_0250_0260_sequence seq_0040_0250_0260;

    // constructor
    function new (string name = "test_0040_0250_0260", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        seq_0040_0250_0260 = test_0040_0250_0260_sequence::type_id::create("seq_0040_0250_0260");

        phase.raise_objection(this); // start time consumption
            `uvm_info(get_name(), "starting test cases for test 0040_0250_0260", UVM_LOW)
            seq_0040_0250_0260.start(env.v_sqr);
        phase.drop_objection(this); // end time consumption

    endtask : run_phase

endclass : test_0040_0250_0260