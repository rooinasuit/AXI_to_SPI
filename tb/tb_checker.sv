import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class scb_checker extends uvm_component;

    `uvm_component_utils(scb_checker)

    function new(string name = "scb_checker", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

endclass