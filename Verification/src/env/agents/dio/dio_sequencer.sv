
class dio_sequencer extends uvm_sequencer#(dio_seq_item);

    `uvm_component_utils(dio_sequencer)

    dio_config dio_cfg;
    virtual dio_interface vif;

    function new(string name = "dio_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(dio_config)::get(this, "", "dio_config", dio_cfg)) begin
            `uvm_fatal("DIO_SQR", {"dio config must be set for: ", get_full_name(), " dio_cfg"})
        end

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = dio_cfg.vif;

    endfunction : connect_phase

endclass : dio_sequencer