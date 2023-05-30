
class clock_sequence_start extends clock_base_sequence;

    `uvm_object_utils(clock_base_sequence)

    clock_seq_item clk_pkt;

    function new (string name = "clock_sequence_start");
        super.new(name);
    endfunction : new

    task start_clock(time period);
        
    endtask : start_clock

    task finish_clock();

    endtask : finish_clock

endclass : clock_sequence_start