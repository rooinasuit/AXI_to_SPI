
class clock_driver extends uvm_driver;

    `uvm_component_utils(clock_driver)

    // instantiation of internal objects
    virtual clock_interface vif;

    int period = 100ns;

    function new (string name = "clock_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(!uvm_config_db#(virtual clock_interface)::get(this, "", "c_vif", vif)) begin
            `uvm_error("CLK_DRV", {"virtual interface must be set for: ", get_full_name(), "vif"})
        end

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        fork
            forever#(period/2) vif.GCLK = !vif.GCLK;
        join_none

    endtask : run_phase

endclass : clock_driver