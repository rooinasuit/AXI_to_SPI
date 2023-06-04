
class clock_config extends uvm_object;

    `uvm_object_utils(clock_config)

    virtual clock_interface vif;

    bit clock_enable = 0;

    function new (string name = "clock_config");
        super.new(name);
    endfunction : new

endclass : clock_config