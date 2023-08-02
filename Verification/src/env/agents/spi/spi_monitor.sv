
class spi_monitor extends uvm_monitor;

    `uvm_component_utils(spi_monitor)

    // instantiation of internal objects
    spi_config spi_cfg;
    virtual spi_interface vif;

    uvm_analysis_port#(spi_seq_item) spi_mtr_port;

    // uvm_verbosity verbosity_v = UVM_HIGH;

    logic MISO_queue_last [$];
    logic MISO_queue [$];

    logic MOSI_queue [$];

    time clk_period_min;
    time clk_period_max;

    // time CS_to_SCK_t;
    // time SCK_to_CS_t;

    time IFG_t;

    // event frame_done_e;

    function new (string name = "spi_monitor", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        spi_mtr_port = new("spi_mtr_port", this);

        if (!uvm_config_db #(spi_config)::get(this, "", "spi_config", spi_cfg)) begin
            `uvm_fatal(get_name(), {"spi config must be set for: ", get_full_name()})
        end

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = spi_cfg.vif;

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        fork
            spi_measure_period();
            spi_bus_watch();
            spi_clkedge_watch();
            spi_capture();
        join_none

    endtask : run_phase

    task spi_measure_period();
        time period_start;
        time period_end;
        time clk_period;
        //
        forever begin
            @(negedge vif.CS_o);
            clk_period_min = 1ms; // to prevent clk_period_min being an x
            clk_period_max = 1ns; // to prevent clk_period_max being an x
            `FIRST_OF
            begin
                forever begin
                    @(posedge vif.SCLK_o);
                    period_start = $realtime;
                    //
                    @(posedge vif.SCLK_o);
                    period_end = $realtime;
                    clk_period = (period_end - period_start);
                    if (clk_period > clk_period_max) begin
                        clk_period_max = clk_period;
                    end
                    if (clk_period < clk_period_min) begin
                        clk_period_min = clk_period;
                    end
                end
            end
            begin
                wait(vif.CS_o == 1);
            end
            `END_FIRST_OF
        end
    endtask : spi_measure_period

    task spi_bus_watch();

        spi_seq_item spi_pkt_in;
        #10ns;
        forever begin
            @(posedge vif.CS_o);
            #20ns
            fork
                begin
                spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                spi_pkt_in.item_type = "obs_item";
                spi_pkt_in.name = "CS_o";
                spi_pkt_in.data = {vif.CS_o};
                spi_pkt_in.obs_timestamp = $realtime;
                spi_mtr_port.write(spi_pkt_in);
                end
                begin
                spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                spi_pkt_in.item_type = "obs_item";
                spi_pkt_in.name = "SCLK_o";
                spi_pkt_in.data = {vif.SCLK_o};
                spi_pkt_in.obs_timestamp = $realtime;
                spi_mtr_port.write(spi_pkt_in);
                end
                begin
                spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                spi_pkt_in.item_type = "obs_item";
                spi_pkt_in.name = "MOSI_o";
                spi_pkt_in.data = {vif.MOSI_o};
                spi_pkt_in.obs_timestamp = $realtime;
                spi_mtr_port.write(spi_pkt_in);
                end
            join
            wait(vif.CS_o == 0);
        end
    endtask : spi_bus_watch

    task spi_clkedge_watch();
        int prev_val;
        int curr_val;

        spi_seq_item spi_pkt_in;
        
        forever begin
        wait(vif.CS_o == 1);
        `FIRST_OF
        forever begin
            prev_val = vif.SCLK_o;
            @(vif.SCLK_o);
                curr_val = vif.SCLK_o;
                if (curr_val != prev_val) begin
                    case (curr_val)
                    0: begin
                        spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                        spi_pkt_in.item_type = "obs_item";
                        spi_pkt_in.name  = "SCLK_neg";
                        spi_pkt_in.obs_timestamp = $realtime;
                        spi_mtr_port.write(spi_pkt_in);
                    end
                    1: begin
                        spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                        spi_pkt_in.item_type = "obs_item";
                        spi_pkt_in.name  = "SCLK_pos";
                        spi_pkt_in.obs_timestamp = $realtime;
                        spi_mtr_port.write(spi_pkt_in);
                    end
                    endcase
                end
        end
        begin
            wait(vif.CS_o == 0);
        end
        `END_FIRST_OF
        end
    endtask : spi_clkedge_watch

    task spi_capture();
        time neg_CS_t;
        time pos_CS_t;
        time first_SPI_t;
        time last_SPI_t;
        //
        spi_seq_item spi_pkt_in;
        logic [1:0] spi_mode;
        forever begin
            @(negedge vif.CS_o);
            MOSI_queue.delete();
            MISO_queue.delete();
            // MOSI
            spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
            spi_pkt_in.item_type = "obs_item";
            spi_pkt_in.name  = "MOSI_frame";
            spi_pkt_in.obs_timestamp = $realtime;
            //
            neg_CS_t = $realtime;
            spi_mode = spi_cfg.spi_mode;
            case(spi_mode)
                0: begin
                    @(posedge vif.SCLK_o);
                    MISO_queue.push_back(vif.MISO_i);
                    MOSI_queue.push_back(vif.MOSI_o);
                    first_SPI_t = $realtime;
                    `FIRST_OF
                    begin
                        forever begin
                            @(posedge vif.SCLK_o);
                            MISO_queue.push_back(vif.MISO_i);
                            MOSI_queue.push_back(vif.MOSI_o);
                            @(negedge vif.SCLK_o);
                            last_SPI_t = $realtime;
                        end
                    end
                    begin
                        wait(vif.CS_o == 1);
                    end
                    `END_FIRST_OF
                end
                1: begin
                    @(posedge vif.SCLK_o);
                    first_SPI_t = $realtime;
                    `FIRST_OF
                    begin
                        forever begin
                            @(negedge vif.SCLK_o);
                            MISO_queue.push_back(vif.MISO_i);
                            MOSI_queue.push_back(vif.MOSI_o);
                            last_SPI_t = $realtime;
                        end
                    end
                    begin
                        wait(vif.CS_o == 1);
                    end
                    `END_FIRST_OF
                end
                2: begin
                    @(negedge vif.SCLK_o);
                    first_SPI_t = $realtime;
                    `FIRST_OF
                    begin
                        forever begin
                            @(posedge vif.SCLK_o);
                            MISO_queue.push_back(vif.MISO_i);
                            MOSI_queue.push_back(vif.MOSI_o);
                            last_SPI_t = $realtime;
                        end
                    end
                    begin
                        wait(vif.CS_o == 1);
                    end
                    `END_FIRST_OF
                end
                3: begin
                    @(negedge vif.SCLK_o);
                    MISO_queue.push_back(vif.MISO_i);
                    MOSI_queue.push_back(vif.MOSI_o);
                    first_SPI_t = $realtime;
                    `FIRST_OF
                    begin
                        forever begin
                            @(negedge vif.SCLK_o);
                            MISO_queue.push_back(vif.MISO_i);
                            MOSI_queue.push_back(vif.MOSI_o);
                            @(posedge vif.SCLK_o);
                            last_SPI_t = $realtime;
                        end
                    end
                    begin
                        wait(vif.CS_o == 1);
                    end
                    `END_FIRST_OF
                end
            endcase
            pos_CS_t = $realtime;
            fork
            // MOSI
            begin
            spi_pkt_in.data = MOSI_queue;
            spi_pkt_in.clk_period_min = clk_period_min;
            spi_pkt_in.clk_period_max = clk_period_max;
            spi_pkt_in.CS_to_SCK = first_SPI_t - neg_CS_t;
            spi_pkt_in.SCK_to_CS = pos_CS_t - last_SPI_t;
            spi_mtr_port.write(spi_pkt_in);
            end
            begin
            // MISO
            // if(MISO_queue !== MISO_queue_last) begin
            spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
            spi_pkt_in.item_type = "obs_item";
            spi_pkt_in.name = "MISO_frame";
            spi_pkt_in.data = MISO_queue;
            spi_mtr_port.write(spi_pkt_in);
            // end
            // MISO_queue_last = MISO_queue;
            end
            join
            //
            // ->frame_done_e;
        end
    endtask : spi_capture

endclass: spi_monitor
