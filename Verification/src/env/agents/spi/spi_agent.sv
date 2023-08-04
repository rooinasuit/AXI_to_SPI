
class spi_agent extends uvm_agent;

    `uvm_component_utils(spi_agent)

    // instantiation of internal objects
    spi_config spi_cfg;

    spi_sequencer spi_sqr;
    spi_monitor   spi_mtr;
    spi_driver    spi_drv;

    uvm_analysis_port#(spi_seq_item) spi_mtr_port;

    function new (string name = "spi_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        spi_mtr_port = new("spi_mtr_port", this);

        if (!uvm_config_db #(spi_config)::get(this, "", "spi_config", spi_cfg)) begin
            `uvm_fatal(get_name(), {"spi config must be set for: ", get_full_name()})
        end

        uvm_config_db#(spi_config)::set(this, "spi_sqr", "spi_config", spi_cfg);
        `uvm_info(get_name(), "Creating SPI_SQR handle", UVM_LOW)
        spi_sqr = spi_sequencer::type_id::create("spi_sqr", this);

        uvm_config_db#(spi_config)::set(this, "spi_drv", "spi_config", spi_cfg);
        `uvm_info(get_name(), "Creating SPI_DRV handle", UVM_LOW)
        spi_drv = spi_driver::type_id::create("spi_drv", this);

        uvm_config_db#(spi_config)::set(this, "spi_mtr", "spi_config", spi_cfg);
        `uvm_info(get_name(), "Creating SPI_MTR handle", UVM_LOW)
        spi_mtr = spi_monitor::type_id::create("spi_mtr", this);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        `uvm_info(get_name(), "Connecting exports: spi_seq_item (SPI_DRV)", UVM_LOW)
        spi_drv.seq_item_port.connect(spi_sqr.seq_item_export);
    endfunction : connect_phase

endclass: spi_agent