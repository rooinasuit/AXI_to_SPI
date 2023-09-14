
class clock_driver extends uvm_driver#(clock_seq_item);

    `uvm_component_utils(clock_driver)

    clock_config clk_cfg;
    virtual clock_interface vif;
    //
    int period;
    bit clock_enable;

    function new (string name = "clock_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(clock_config)::get(this, "", "clock_config", clk_cfg)) begin
            `uvm_error(get_name(), {"clock config must be set for: ", get_full_name()})
        end
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = clk_cfg.vif;
    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        vif.GCLK = 0;
        fork
            get_and_drive();
            drive_clock();
        join
    endtask : run_phase

    task get_and_drive();
        forever begin
            clock_seq_item clk_pkt = clock_seq_item::type_id::create("clk_pkt");
            seq_item_port.get_next_item(clk_pkt);
            case(clk_pkt.name)
                "period": period = clk_pkt.value;
                "clock_enable": clock_enable = clk_pkt.value;
                default: begin
                    period = 0;
                    clock_enable = 0;
                end
            endcase
            seq_item_port.item_done();
        end
    endtask : get_and_drive

    task drive_clock();
        forever begin
            wait(clock_enable);
            fork
                begin
                    wait(!clock_enable);
                    wait(!vif.GCLK);
                end
                begin
                    `uvm_info(get_name(), $sformatf("period is: %0d", period), UVM_LOW)
                    forever #((period/2)*1ns) vif.GCLK = ~vif.GCLK;
                end
            join_any
            disable fork;
        end
    endtask : drive_clock

endclass : clock_driver