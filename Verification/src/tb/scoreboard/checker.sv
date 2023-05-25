import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class tb_checker extends uvm_component;

    `uvm_component_utils(tb_checker)

    function new(string name = "tb_checker", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

endclass