
class spi_monitor extends uvm_monitor;

    `uvm_component_utils(spi_monitor)

    // instantiation of internal objects
    spi_config spi_cfg;
    virtual spi_interface vif;

    // DO UNBOUNDED QUEUE FOR COLLECTING AS MANY BITS AS POSSIBLE

    uvm_analysis_port#(spi_seq_item) spi_mtr_port;

    // uvm_verbosity verbosity_v = UVM_HIGH;

    bit trans_end;

    logic MISO_data_o [$];
    logic MOSI_data_i [$];

    logic [1:0] spi_mode; // lets leave monitor with access to it
    // logic [4:0] word_len; // this should not be known

    // logic [31:0] MISO_buff; // replaced with MISO_data_o
    // logic [31:0] MOSI_buff; // replaced with MOSI_data_i

    int clk_freq;
    int clk_duty;

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
            spi_get_ready();
            // spi_measure_freq(2); // how many periods to count from?
            // spi_measure_duty(2); // how many periods to count from?
            spi_to_scb();
        join_none

        spi_capture();

    endtask : run_phase

    task spi_measure_freq(int N);
        begin
        time freq_start;
        time freq_end;
        time clk_period;
        //
        forever begin
            freq_start = $time;
            repeat(N) begin
                @(posedge vif.SCLK_out);
            end
            freq_end = $time;
            
            clk_period = (freq_end - freq_start)/N;
            clk_freq = 1/clk_period;
            `uvm_info(get_name(), $sformatf("spi clock frequency: %06d", clk_freq), UVM_LOW)
        end
        end
    endtask : spi_measure_freq

    task spi_measure_duty(int N);
        begin
        time duty_start;
        time duty_mid;
        time duty_end;
        int duty_single_meas;
        //
        forever begin
            repeat(N) begin
                @(posedge vif.SCLK_out);
                duty_start = $time;
                @(negedge vif.SCLK_out);
                duty_mid = $time;
                @(posedge vif.SCLK_out);
                duty_end = $time;
                duty_single_meas = duty_single_meas + ((duty_end - duty_start)/duty_mid)*100;
            end
            clk_duty = (duty_single_meas)/N; // in %
            // `uvm_info(get_name(), $sformatf("spi clock duty cycle: %06d", clk_duty), UVM_LOW)
        end
        end
    endtask : spi_measure_duty

    task spi_get_ready();
        forever begin
        @(negedge vif.CS_out);
            // bit_count   = 0;
            spi_mode    = spi_cfg.spi_mode;
            //
            `uvm_info(get_name(), $sformatf("loaded spi_mode: %h", spi_mode), UVM_LOW)
        end
    endtask : spi_get_ready

    task spi_capture();
        forever begin
            @(negedge vif.CS_out)
                while(!vif.CS_out) begin
                    case(spi_mode)
                    0: begin
                        @(posedge vif.SCLK_out);
                            MISO_data_o.push_back(vif.MISO_in);
                            MOSI_data_i.push_back(vif.MOSI_out);
                            // bit_count = bit_count + 1;
                    end
                    1: begin
                        @(negedge vif.SCLK_out);
                            MISO_data_o.push_back(vif.MISO_in);
                            MOSI_data_i.push_back(vif.MOSI_out);
                            // bit_count = bit_count + 1;
                    end
                    2: begin
                        @(posedge vif.SCLK_out);
                            MISO_data_o.push_back(vif.MISO_in);
                            MOSI_data_i.push_back(vif.MOSI_out);
                            // bit_count = bit_count + 1;
                    end
                    3: begin
                        @(negedge vif.SCLK_out);
                            MISO_data_o.push_back(vif.MISO_in);
                            MOSI_data_i.push_back(vif.MOSI_out);
                            // bit_count = bit_count + 1;
                    end
                    endcase
                end
        end
    endtask : spi_capture

    task spi_to_scb();
        // begin
        //     spi_seq_item spi_pkt_in;
        //     forever begin
        //         
        //     end
        // end
        //
        begin
            spi_seq_item spi_pkt_in;
            forever begin
            @(negedge vif.CS_out);
                spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                spi_pkt_in.item_type = "obs_item";
                spi_pkt_in.name = "CS_out";
                spi_pkt_in.value = vif.CS_out;
                spi_pkt_in.obs_timestamp = $realtime;
                spi_mtr_port.write(spi_pkt_in);
            @(posedge vif.CS_out);
                fork
                    begin
                    spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                    spi_pkt_in.item_type = "obs_item";
                    spi_pkt_in.name = "CS_out";
                    spi_pkt_in.value = vif.CS_out;
                    spi_pkt_in.obs_timestamp = $realtime;
                    spi_mtr_port.write(spi_pkt_in);
                    end
                    begin
                    spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                    spi_pkt_in.item_type = "obs_item";
                    spi_pkt_in.name = "MISO_frame";
                    spi_pkt_in.data = MISO_data_o;
                    // spi_pkt_in.bit_count = bit_count;
                    spi_pkt_in.obs_timestamp = $realtime;
                    spi_mtr_port.write(spi_pkt_in);
                    MISO_data_o.delete();
                    end
                    //
                    begin
                    spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
                    spi_pkt_in.item_type = "obs_item";
                    spi_pkt_in.name  = "MOSI_frame";
                    spi_pkt_in.data = MOSI_data_i;
                    // spi_pkt_in.bit_count = bit_count;
                    spi_pkt_in.obs_timestamp = $realtime;
                    spi_mtr_port.write(spi_pkt_in);
                    MOSI_data_i.delete();
                    end
                join
            end
        end
    endtask : spi_to_scb

endclass: spi_monitor
