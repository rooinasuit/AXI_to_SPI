
class spi_sequencer extends uvm_sequencer#(spi_seq_item);

    `uvm_component_utils(spi_sequencer)

    spi_config spi_cfg;
    virtual spi_interface vif;

    function new (string name = "spi_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(spi_config)::get(this, "", "spi_config", spi_cfg)) begin
            `uvm_fatal("SPI_SQR", {"spi config must be set for: ", get_full_name(), " spi_cfg"})
        end

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = spi_cfg.vif;

    endfunction : connect_phase

endclass : spi_sequencer