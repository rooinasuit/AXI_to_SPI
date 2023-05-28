import uvm_pkg::*;
`include "uvm_macros.svh"

class base_test_sequence extends uvm_sequence;

    `uvm_object_utils(base_test_sequence)
    // `uvm_declare_p_sequencer(virtual_sequencer)

    virtual_sequencer v_sqr;

    clock_sequencer     clk_sqr;
    dio_sequencer       dio_sqr;
    spi_slave_sequencer slv_sqr;

    function new (string name = "base_test_sequence");
        super.new(name);
    endfunction : new

    task body();

        if(!$cast(v_sqr, m_sequencer)) begin
            `uvm_error(get_full_name(), "Virtual sequencer pointer cast failed");
        end
        clk_sqr = v_sqr.clk_sqr;
        dio_sqr = v_sqr.dio_sqr;
        slv_sqr = v_sqr.slv_sqr;

    endtask : body

endclass : base_test_sequence

