
class dio_drive_sequence extends dio_base_sequence;

    `uvm_object_utils(dio_drive_sequence)

    string name;
    int value;

    function new (string name = "dio_drive_sequence");
        super.new(name);
    endfunction : new

    task body();
        dio_pkt = dio_seq_item::type_id::create("dio_pkt");

        start_item(dio_pkt);
            dio_pkt.name  = name;
            dio_pkt.value = value;
        finish_item(dio_pkt);
    endtask : body

endclass : dio_drive_sequence