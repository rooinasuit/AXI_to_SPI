
class clock_agent extends uvm_agent;

    `uvm_component_utils(clock_agent)

    // instantiation of internal objects
    clock_sequencer clk_sqr;
    clock_driver    clk_drv;

    function new (string name = "clock_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("CLK_AGT", "Creating CLK_SQR handle", UVM_LOW)
        clk_sqr = clock_sequencer::type_id::create("clk_sqr", this);

        `uvm_info("CLK_AGT", "Creating CLK_DRV handle", UVM_LOW)
        clk_drv = clock_driver::type_id::create("clk_drv", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        `uvm_info("CLK_AGT", "Connecting export: clock_seq_item (CLK_DRV)", UVM_LOW)
        clk_drv.seq_item_port.connect(clk_sqr.seq_item_export);

    endfunction : connect_phase

endclass : clock_agent