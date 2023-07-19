
class clock_period_sequence extends clock_base_sequence;

    `uvm_object_utils(clock_period_sequence)

    int period;

    function new (string name = "clock_period_sequence");
        super.new(name);
    endfunction : new

    task body();
        clk_pkt = clock_seq_item::type_id::create("clk_pkt");

        start_item(clk_pkt);
            clock_period(period);
        finish_item(clk_pkt);

    endtask : body

endclass : clock_period_sequence