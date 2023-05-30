
class clock_driver extends uvm_driver#(clock_seq_item);

    `uvm_component_utils(clock_driver)

    // instantiation of internal objects
    virtual clock_interface vif;
    clock_seq_item clk_pkt;

    // int period = 100ns;

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

        forever begin
            create_handle();
            clock_send();
            transaction_done();
        end

    endtask : run_phase

    task clock_send();
        seq_item_port.get_next_item(clk_pkt); // blocking
        fork
            forever#(clk_pkt.period/2) vif.GCLK = !vif.GCLK;
        join_none
    endtask : clock_send

    function void create_handle();
        `uvm_info("CLK_DRV", "Fetching next clk_pkt to put onto the DUT interface", UVM_LOW)
        clk_pkt = clock_seq_item::type_id::create("clk_pkt");
    endfunction : create_handle

    function void transaction_done();
        `uvm_info("CLK_DRV", "Transaction finished, ready for another", UVM_LOW)
        seq_item_port.item_done(); // unblocking, ready for another send to the DUT
    endfunction : transaction_done

endclass : clock_driver