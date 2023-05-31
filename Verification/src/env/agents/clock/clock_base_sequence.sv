
class clock_base_sequence extends uvm_sequence#(clock_seq_item);

    `uvm_object_utils(clock_base_sequence)

    clock_seq_item clk_pkt;

    function new (string name = "clock_base_sequence");
        super.new(name);
    endfunction : new

    task start_clock(int period_in);
        clk_pkt = clock_seq_item::type_id::create("clk_pkt");
        start_item(clk_pkt);
        clk_pkt.period = period_in;
        finish_item(clk_pkt);
    endtask : start_clock

    task finish_clock();
        clk_pkt.period = 0;
    endtask : finish_clock

endclass : clock_base_sequence