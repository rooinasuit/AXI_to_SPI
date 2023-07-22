
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

    time neg_CS_t;
    time pos_CS_t;
    time first_SPI_t;
    time last_SPI_t;

    time CS_to_SCK_t;
    time SCK_to_CS_t;

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
            spi_to_scb();
        join_none

    endtask : run_phase

    task spi_measure_IFG();
        time IFG_start_t;
        time IFG_end_t;
        forever begin
            wait(vif.CS_o == 0);
                IFG_start_t = $realtime;
            wait(vif.CS_o == 1);
                IFG_end_t = $realtime;
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
            wait(vif.CS_o == 0);
            while(vif.CS_o == 0) begin
                @(posedge vif.SCLK_o)
                period_start = $realtime;
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
    endtask : spi_measure_period

    task spi_capture();
        //
        logic [1:0] spi_mode;
        forever begin
            @(negedge vif.CS_o);
                neg_CS_t = $realtime;
                spi_mode = spi_cfg.spi_mode;
                MOSI_queue.delete();
                MISO_queue.delete();
                case(spi_mode)
                0: begin
                    @(posedge vif.SCLK_o);
                    MISO_queue.push_back(vif.MISO_i);
                    MOSI_queue.push_back(vif.MOSI_o);
                    first_SPI_t = $realtime;
                    while(vif.CS_o === 0) begin
                        @(posedge vif.SCLK_o);
                        MISO_queue.push_back(vif.MISO_i);
                        MOSI_queue.push_back(vif.MOSI_o);
                        @(negedge vif.SCLK_o);
                        last_SPI_t = $realtime;
                    end
                end
                1: begin
                    @(posedge vif.SCLK_o);
                    first_SPI_t = $realtime;
                    while(vif.CS_o === 0) begin
                        @(negedge vif.SCLK_o);
                        MISO_queue.push_back(vif.MISO_i);
                        MOSI_queue.push_back(vif.MOSI_o);
                        last_SPI_t = $realtime;
                    end
                end
                2: begin
                    @(negedge vif.SCLK_o);
                    first_SPI_t = $realtime;
                    while(vif.CS_o === 0) begin
                        @(posedge vif.SCLK_o);
                        MISO_queue.push_back(vif.MISO_i);
                        MOSI_queue.push_back(vif.MOSI_o);
                        last_SPI_t = $realtime;
                    end
                end
                3: begin
                    @(negedge vif.SCLK_o);
                    MISO_queue.push_back(vif.MISO_i);
                    MOSI_queue.push_back(vif.MOSI_o);
                    first_SPI_t = $realtime;
                    while(vif.CS_o === 0) begin
                        @(negedge vif.SCLK_o);
                        MISO_queue.push_back(vif.MISO_i);
                        MOSI_queue.push_back(vif.MOSI_o);
                        @(posedge vif.SCLK_o);
                        last_SPI_t = $realtime;
                    end
                end
                endcase
            //
            // $display("cs_sck %0.1f", SCK_to_CS_t);
            // $display("sck_cs %0.1f", CS_to_SCK_t);
        end
    endtask : spi_capture

    task spi_to_scb();
        forever begin
            fork
                get_miso();
                get_mosi();
            join
        end
    endtask : spi_to_scb

    task get_IFG();
        @(posedge vif.CS_o);
    endtask : get_IFG

    task get_miso();
        begin
            spi_seq_item spi_pkt_in;
            @(negedge vif.CS_o);
                spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                spi_pkt_in.item_type = "obs_item";
                spi_pkt_in.name = "MISO_frame";
            @(posedge vif.CS_o);
                spi_pkt_in.data = MISO_queue;
                spi_mtr_port.write(spi_pkt_in);
        end
    endtask : get_miso

    task get_mosi();
        begin
            spi_seq_item spi_pkt_in;
            @(negedge vif.CS_o);
                spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                spi_pkt_in.item_type = "obs_item";
                spi_pkt_in.name  = "MOSI_frame";
                spi_pkt_in.obs_timestamp = $realtime;
            @(posedge vif.CS_o);
                pos_CS_t = $realtime;
                SCK_to_CS_t = pos_CS_t - last_SPI_t;
                CS_to_SCK_t = first_SPI_t - neg_CS_t;
                spi_pkt_in.data = MOSI_queue;
                spi_pkt_in.clk_period_min = clk_period_min;
                spi_pkt_in.clk_period_max = clk_period_max;
                spi_pkt_in.CS_to_SCK = CS_to_SCK_t;
                spi_pkt_in.SCK_to_CS = SCK_to_CS_t;
                spi_mtr_port.write(spi_pkt_in);
        end
    endtask : get_mosi

endclass: spi_monitor
