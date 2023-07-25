
class ref_model extends uvm_component;

    `uvm_component_utils(ref_model)

    uvm_analysis_port#(dio_seq_item) dio_rfm_port;
    uvm_analysis_port#(spi_seq_item) spi_rfm_port;

    int true_sck_speed;
    int true_word_len;
    //
    time global_clock_period = 10ns; // as per requirement
    real clock_precision = 0.05; // as per requirement
    time spi_period_min;
    time spi_period_max;
    // DIO
    `RFM_DECLARE_P(NRST, 1)
    `RFM_DECLARE_P(start_i, 1)
    `RFM_DECLARE_P(spi_mode_i, 2)
    `RFM_DECLARE_P(sck_speed_i, 2)
    `RFM_DECLARE_P(word_len_i, 2)
    `RFM_DECLARE_P(IFG_i, 8)
    `RFM_DECLARE_P(CS_SCK_i, 8)
    `RFM_DECLARE_P(SCK_CS_i, 8)
    `RFM_DECLARE_P(mosi_data_i, 32)
    `RFM_DECLARE_P(CS_o, 1)
    `RFM_DECLARE_UP(MISO_frame, $)
    // logic [WIDTH-1:0] PORT_NAME_mirror; event PORT_NAME_change_e;

    event cs_error_e;

    function new(string name = "ref_model", uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        dio_rfm_port = new("dio_rfm_port", this);
        spi_rfm_port = new("spi_rfm_port", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

    // here we will predict :D
        fork
            predict_busy();
            predict_IFG();
            predict_mosi();
            predict_miso();
            monitor_cs();
        join_none

    endtask : run_phase

    task monitor_cs(); // CS timeout monitor
        // time timeout_threshold;
        forever begin
            wait(CS_o_mirror == 0);
            `FIRST_OF
            begin
                // timeout_threshold = (2*true_sck_speed*true_word_len+(CS_SCK_i_mirror+SCK_CS_i_mirror))*global_clock_period;
                #50us; // absolute worst case scenario
                `uvm_fatal(get_name(), "CS_out is being pulled down for too long")
            end
            begin
                wait(CS_o_mirror == 1);
            end
            `END_FIRST_OF
        end
    endtask : monitor_cs

    task predict_busy();
        forever begin
            @(CS_o_change_e);
            if ($realtime > 20ns) begin
                if (CS_o_mirror == 0) begin
                    predict_dio("busy_o", 1, $realtime, $realtime+10ns);
                end
                else begin
                    predict_dio("busy_o", 0, $realtime, $realtime+10ns);
                end
            end
        end
    endtask : predict_busy

    task predict_IFG();
        @(IFG_i_change_e);
        forever begin
            @(CS_o_change_e);
            if(CS_o_mirror == 0) begin
                predict_spi("min_IFG", , IFG_i_mirror*global_clock_period);
            end
        end
    endtask : predict_IFG

    task predict_mosi();
        logic MOSI_queue [$];
        //
        time spi_clock_period;
        forever begin
            @(start_i_change_e);
            if (start_i_mirror == 1) begin
                @(CS_o_change_e);
                //
                MOSI_queue.delete();
                for(int i=(true_word_len-1); i>=0; i--) begin
                    MOSI_queue.push_back(mosi_data_i_mirror[i]);
                end
                spi_clock_period = 2*(true_sck_speed)*global_clock_period;
                spi_period_min = spi_clock_period*(1-clock_precision);
                spi_period_max = spi_clock_period*(1+clock_precision);
                predict_spi("MOSI_frame", MOSI_queue, $realtime, $realtime+20ns, spi_period_min, spi_period_max,
                CS_SCK_i_mirror*global_clock_period, SCK_CS_i_mirror*global_clock_period);
            end
        end
    endtask : predict_mosi

    task predict_miso();
        forever begin
            @(MISO_frame_change_e);
            predict_dio("miso_data_o", MISO_frame_mirror_packed, $realtime, $realtime+20ns);
        end
    endtask : predict_miso

    task predict_spi(string name = "", logic data [$] = {}, time exp_timestamp_min = 0,
                    time exp_timestamp_max = 0, time clk_period_min = 0, time clk_period_max = 0,
                    time CS_SCK_t = 0, time SCK_CS_t = 0);
        spi_seq_item spi_pkt_exp = spi_seq_item::type_id::create("spi_pkt_exp");
        spi_pkt_exp.item_type = "exp_item";
        spi_pkt_exp.name = name;
        spi_pkt_exp.data = data;
        spi_pkt_exp.exp_timestamp_min = exp_timestamp_min;
        spi_pkt_exp.exp_timestamp_max = exp_timestamp_max;
        spi_pkt_exp.clk_period_min = clk_period_min;
        spi_pkt_exp.clk_period_max = clk_period_max;
        spi_pkt_exp.CS_to_SCK = CS_SCK_t;
        spi_pkt_exp.SCK_to_CS = SCK_CS_t;
        spi_rfm_port.write(spi_pkt_exp);
    endtask : predict_spi

    task predict_dio(string name = "", int value = 0, time exp_timestamp_min = 0, time exp_timestamp_max = 0);
        dio_seq_item dio_pkt_exp = dio_seq_item::type_id::create("dio_pkt_exp");
        dio_pkt_exp.item_type = "exp_item";
        dio_pkt_exp.name = name;
        dio_pkt_exp.value = value;
        dio_pkt_exp.exp_timestamp_min = exp_timestamp_min;
        dio_pkt_exp.exp_timestamp_max = exp_timestamp_max;
        dio_rfm_port.write(dio_pkt_exp);
    endtask : predict_dio

    function void write_dio(dio_seq_item item);

        // `uvm_info(get_name(), $sformatf("Data received from DIO_MTR to predict on: "), UVM_LOW)
        // item.print();

        case(item.name)
        "NRST": begin
            `RFM_CHECK(item, NRST)
        end
        "start_i": begin
            `RFM_CHECK(item, start_i)
        end
        "spi_mode_i": begin
            `RFM_CHECK(item, spi_mode_i)
        end
        "sck_speed_i": begin
            `RFM_CHECK(item, sck_speed_i)
            case(sck_speed_i_mirror)
            0: true_sck_speed = 64;
            1: true_sck_speed = 32;
            2: true_sck_speed = 16;
            3: true_sck_speed = 8;
            endcase
        end
        "word_len_i": begin
            `RFM_CHECK(item, word_len_i)
            case(word_len_i_mirror)
            0: true_word_len = 32;
            1: true_word_len = 16;
            2: true_word_len = 8;
            3: true_word_len = 4;
            endcase
        end
        "IFG_i": begin
            `RFM_CHECK(item, IFG_i)
        end
        "CS_SCK_i": begin
            `RFM_CHECK(item, CS_SCK_i)
        end
        "SCK_CS_i": begin
            `RFM_CHECK(item, SCK_CS_i)
        end
        "mosi_data_i": begin
            `RFM_CHECK(item, mosi_data_i)
        end
        "CS_o": begin
            `RFM_CHECK(item, CS_o)
        end
        default: begin
            `uvm_info(get_name(), $sformatf("Wrong %p name supplied: %s", item.get_name(), item.name), UVM_LOW)
        end
        endcase

    endfunction : write_dio

    function void write_spi(spi_seq_item item);

        // `uvm_info(get_name(), $sformatf("Data received from SPI_MTR to predict on: "), UVM_LOW)
        // item.print();

        case (item.name)
        "MISO_frame": begin
            if (item.data !== MISO_frame_mirror) begin
                MISO_frame_mirror = item.data;
                for(int i=(MISO_frame_mirror.size()-1); i>=0; i--) begin
                    MISO_frame_mirror_packed[i] = MISO_frame_mirror[(MISO_frame_mirror.size()-1)-i];
                end
                ->MISO_frame_change_e;
                `uvm_info(get_name(), ({"\nMISO_frame event called - value has changed"}), UVM_LOW)
            end
        end
        default: begin
            `uvm_info(get_name(), $sformatf("Wrong %p name supplied: %s", item.get_name(), item.name), UVM_LOW)
        end
        endcase

    endfunction : write_spi

endclass: ref_model
