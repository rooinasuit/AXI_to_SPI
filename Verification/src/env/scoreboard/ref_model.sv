
class ref_model extends uvm_component;

    `uvm_component_utils(ref_model)

    function new(string name = "ref_model", uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

    endfunction : connect_phase

endclass: ref_model
