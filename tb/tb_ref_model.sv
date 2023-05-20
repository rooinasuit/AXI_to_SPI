import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class ref_model extends uvm_component;

    `uvm_component_utils(ref_model)

    function new(string name = "ref_model", uvm_component parent);
        super.new(name,parent);
    endfunction : new

endclass: ref_model
