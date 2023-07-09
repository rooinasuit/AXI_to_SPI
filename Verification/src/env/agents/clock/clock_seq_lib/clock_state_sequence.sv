
class clock_state_sequence extends clock_base_sequence;

    `uvm_object_utils(clock_state_sequence)

    bit clock_enable;

    function new (string name = "clock_state_sequence");
        super.new(name);
    endfunction : new

    task body();
        clk_pkt = clock_seq_item::type_id::create("clk_pkt");

        start_item(clk_pkt);
            clock_state(clock_enable);
        finish_item(clk_pkt);
    endtask : body

endclass : clock_state_sequence