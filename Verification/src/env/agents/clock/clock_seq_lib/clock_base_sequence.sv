
class clock_base_sequence extends uvm_sequence#(clock_seq_item);

    `uvm_object_utils(clock_base_sequence)

    clock_seq_item clk_pkt;

    function new (string name = "clock_base_sequence");
        super.new(name);
    endfunction : new

    task body();
        //
    endtask : body

endclass : clock_base_sequence