
class dio_drive_random_sequence extends dio_base_sequence;

    `uvm_object_utils(dio_drive_random_sequence)

    string name;
    int range;

    function new (string name = "dio_drive_random_sequence");
        super.new(name);
    endfunction : new

    task body();
        dio_pkt = dio_seq_item::type_id::create("dio_pkt");

        start_item(dio_pkt);
            drive_io_random(name, range);
        finish_item(dio_pkt);
    endtask : body

endclass : dio_drive_random_sequence

