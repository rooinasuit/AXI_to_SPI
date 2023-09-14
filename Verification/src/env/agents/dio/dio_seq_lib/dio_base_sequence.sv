
class dio_base_sequence extends uvm_sequence#(dio_seq_item);

    `uvm_object_utils(dio_base_sequence)

    dio_seq_item dio_pkt;

    function new (string name = "dio_base_sequence");
        super.new(name);
    endfunction : new

    task body();
        //
    endtask : body

endclass : dio_base_sequence
