
class clock_sequencer extends uvm_sequencer#(clock_seq_item);

    `uvm_component_utils(clock_sequencer)

    clock_config clk_cfg;

    virtual clock_interface vif;

    function new(string name = "clock_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(clock_config)::get(this, "", "clock_config", clk_cfg)) begin
            `uvm_fatal(get_name(), {"clock config must be set for: ", get_full_name()})
        end
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = clk_cfg.vif;
    endfunction : connect_phase

endclass : clock_sequencer
