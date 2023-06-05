
class dio_base_sequence extends uvm_sequence#(dio_seq_item);

    `uvm_object_utils(dio_base_sequence)

    dio_seq_item dio_pkt;

    function new (string name = "dio_base_sequence");
        super.new(name);
    endfunction : new

    task body();

    endtask : body

    task drive_io(string name, int value);
        dio_pkt.name  = name;
        dio_pkt.value = value;
    endtask : drive_io

    task drive_io_random(string name, int range);
        dio_pkt.name  = name;
        dio_pkt.value = {$urandom} % range;
    endtask : drive_io_random

endclass : dio_base_sequence
