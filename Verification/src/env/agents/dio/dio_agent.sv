
class dio_agent extends uvm_agent;

    `uvm_component_utils(dio_agent)

    // instantiation of internal objects
    dio_config dio_cfg;

    dio_sequencer dio_sqr;
    dio_driver    dio_drv;
    dio_monitor   dio_mtr;

    uvm_analysis_port#(dio_seq_item) dio_mon_port;
    
    function new (string name = "dio_agent", uvm_component parent = null);
        super.new(name,parent);

        dio_mon_port = new("dio_mon_port", this);

    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(dio_config)::get(this, "", "dio_config", dio_cfg)) begin
            `uvm_fatal("DIO_AGT", {"clock config must be set for: ", get_full_name(), " dio_cfg"})
        end

        `uvm_info("DIO_AGT", "Creating DIO_SQR handle", UVM_LOW)
        dio_sqr = dio_sequencer::type_id::create("dio_sqr", this);

        `uvm_info("DIO_AGT", "Creating DIO_DRV handle", UVM_LOW)
        dio_drv = dio_driver::type_id::create("dio_drv", this);

        `uvm_info("DIO_AGT", "Creating DIO_MTR handle", UVM_LOW)
        dio_mtr = dio_monitor::type_id::create("dio_mtr", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        `uvm_info("DIO_AGT", "Connecting export: dio_seq_item (DIO_DRV)", UVM_LOW)
        dio_drv.seq_item_port.connect(dio_sqr.seq_item_export);

    endfunction : connect_phase

endclass: dio_agent