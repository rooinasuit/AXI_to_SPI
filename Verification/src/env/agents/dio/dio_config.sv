
class dio_config extends uvm_object;

    `uvm_object_utils(dio_config)

    virtual dio_interface vif;

    int monitor_watch_cnt = 15;

    function new (string name = "dio_config");
        super.new(name);
    endfunction : new

endclass : dio_config