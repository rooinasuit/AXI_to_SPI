
class clock_driver extends uvm_driver#(clock_seq_item);

    `uvm_component_utils(clock_driver)

    // instantiation of internal objects
    clock_config clk_cfg;
    virtual clock_interface vif;
    clock_seq_item clk_pkt;

    bit clock_enable = 1;

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

        // if (clock_enable) begin
        //     fork
        //         proc_start_clk[clk_name] = process::self();
        //         forever#(clk_pkt.period/2) vif.GCLK = ~vif.GCLK;
        //     join_none
        // end
        vif.GCLK = 0;
        // forever begin
            create_handle();
            // clock_send();
                        fork
                forever#(clk_pkt.period/2) vif.GCLK <= ~vif.GCLK;
                @(posedge vif.GCLK) `uvm_info("info3", "vif clock works",UVM_LOW)
            join_none
            transaction_done();
        // end

    endtask : run_phase

    task clock_send();
        // if (clock_enable) begin
            fork
                forever#(clk_pkt.period/2) vif.GCLK <= ~vif.GCLK;
                @(posedge vif.GCLK) `uvm_info("info3", "vif clock works",UVM_LOW)
            join_none
        // end
        // #1000ns clock_enable = 0;
    endtask : clock_send

    task create_handle();
        `uvm_info("CLK_DRV", "Fetching next clk_pkt to put onto the DUT interface", UVM_LOW)
        clk_pkt = clock_seq_item::type_id::create("clk_pkt");
        seq_item_port.get_next_item(clk_pkt); // blocking
        clk_pkt.print();
    endtask : create_handle

    function void transaction_done();
        `uvm_info("CLK_DRV", "Transaction finished, ready for another", UVM_LOW)
        seq_item_port.item_done(); // unblocking, ready for another send to the DUT
    endfunction : transaction_done

endclass : clock_driver