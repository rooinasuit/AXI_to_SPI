
class clock_base_sequence extends uvm_sequence#(clock_seq_item);

    `uvm_object_utils(clock_base_sequence)

    clock_seq_item clk_pkt;

    function new (string name = "clock_base_sequence");
        super.new(name);
    endfunction : new

    task body();

    endtask : body

    task clock_state(bit clock_enable);
        clk_pkt.name  = "clock_enable";
        clk_pkt.value = clock_enable;
    endtask : clock_state

    task clock_period(int period);
        clk_pkt.name  = "period";
        clk_pkt.value = period;
    endtask : clock_period

endclass : clock_base_sequence