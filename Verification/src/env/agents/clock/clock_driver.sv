
class clock_driver extends uvm_driver#(clock_seq_item);

    `uvm_component_utils(clock_driver)

    // instantiation of internal objects
    clock_config clk_cfg;
    virtual clock_interface vif;
    clock_seq_item clk_pkt;

    int period;
    bit clock_enable;

    function new (string name = "clock_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(clock_config)::get(this, "", "clock_config", clk_cfg)) begin
            `uvm_error("CLK_DRV", {"virtual interface must be set for: ", get_full_name(), " clk_cfg"})
        end

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = clk_cfg.vif;

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            fork
                begin
                    create_handle();
                    case(clk_pkt.name)
                        "period": period = clk_pkt.value;
                        "clock_enable": clock_enable = clk_pkt.value;
                        default: begin
                            period = 0;
                            clock_enable = 0;
                        end
                    endcase
                    transaction_done();
                end
                begin
                    if (clock_enable) begin
                        forever #((period/2)*1ns) vif.GCLK = ~vif.GCLK;
                    end
                end
            join
        end

    endtask : run_phase

    task create_handle();
        `uvm_info("CLK_DRV", "Fetching next clk_pkt", UVM_LOW)
        clk_pkt = clock_seq_item::type_id::create("clk_pkt");
        seq_item_port.get_next_item(clk_pkt); // blocking
        // clk_pkt.print();
    endtask : create_handle

    function void transaction_done();
        `uvm_info("CLK_DRV", "Transaction finished, ready for another", UVM_LOW)
        seq_item_port.item_done(); // unblocking, ready for another send to the DUT
    endfunction : transaction_done

endclass : clock_driver