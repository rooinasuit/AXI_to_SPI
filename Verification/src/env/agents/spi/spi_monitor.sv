
class spi_monitor extends uvm_monitor;

    `uvm_component_utils(spi_monitor)

    // instantiation of internal objects
    spi_config spi_cfg;
    virtual spi_interface vif;

    uvm_analysis_port#(spi_seq_item) spi_mtr_port;

    // uvm_verbosity verbosity_v = UVM_HIGH;

    logic MISO_queue [$];
    logic MOSI_queue [$];

    time clk_period_min;
    time clk_period_max;

    // time CS_to_SCK_t;
    // time SCK_to_CS_t;

    time IFG_t;

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
            spi_measure_IFG();
            spi_measure_period();
            spi_capture();
        join_none

    endtask : run_phase

    task spi_measure_IFG();
        time IFG_start_t;
        time IFG_end_t;
        //
        spi_seq_item spi_pkt_in;
        forever begin
            @(posedge vif.CS_o);
                //
                IFG_start_t = $realtime;
                //
                spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                spi_pkt_in.item_type = "obs_item";
                spi_pkt_in.name = "min_IFG";
            @(negedge vif.CS_o);
                //
                IFG_end_t = $realtime;
                IFG_t = IFG_end_t - IFG_start_t;
                //
                spi_pkt_in.obs_timestamp = IFG_t;
                spi_mtr_port.write(spi_pkt_in);
        end
    endtask : spi_measure_IFG

    task spi_measure_period();
        time period_start;
        time period_end;
        time clk_period;
        //
        clk_period_min = 1ms; // to prevent clk_period_min being an x
        clk_period_max = 1ns; // to prevent clk_period_max being an x
        forever begin
            @(negedge vif.CS_o);
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
            // MOSI
            spi_pkt_in.data = MOSI_queue;
            spi_pkt_in.clk_period_min = clk_period_min;
            spi_pkt_in.clk_period_max = clk_period_max;
            spi_pkt_in.CS_to_SCK = first_SPI_t - neg_CS_t;
            spi_pkt_in.SCK_to_CS = pos_CS_t - last_SPI_t;
            spi_mtr_port.write(spi_pkt_in);
            // MISO
            spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
            spi_pkt_in.item_type = "obs_item";
            spi_pkt_in.name = "MISO_frame";
            spi_pkt_in.data = MISO_queue;
            spi_mtr_port.write(spi_pkt_in);
        end
    endtask : spi_capture

endclass: spi_monitor
