
class test_0030_sequence extends test_base_sequence;

    `uvm_object_utils(test_0030_sequence)

    function new (string name = "test_0030_sequence");
        super.new(name);
    endfunction : new

    //////////////////////////////////////////////////////////
    // No need to set value [0] on anything other than      //
    // start_out just after RST deassertion                 //
    // due to the other signals being set to [0] on default //
    //////////////////////////////////////////////////////////

    task body();
        
    endtask : body

endclass : test_0030_sequence