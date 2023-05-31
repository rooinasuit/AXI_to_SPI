
class clock_sequence_start extends clock_base_sequence;

    `uvm_object_utils(clock_sequence_start)

    clock_seq_item clk_pkt;

    int period_in = 1s;

    function new (string name = "clock_sequence_start");
        super.new(name);
    endfunction : new

    // task pre_body();
    //     clk_pkt = clock_seq_item::type_id::create("clk_pkt");
    //     start_item(clk_pkt);
    // endtask : pre_body

    task body();
        start_clock(period_in);
    endtask : body

    // task post_body();
    //     finish_item(clk_pkt);
    // endtask : post_body

endclass : clock_sequence_start