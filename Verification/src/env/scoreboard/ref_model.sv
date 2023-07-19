
class ref_model extends uvm_component;

    `uvm_component_utils(ref_model)

    uvm_analysis_port#(dio_seq_item) dio_rfm_port;
    uvm_analysis_port#(spi_seq_item) spi_rfm_port;

    int true_sck_speed;
    int true_word_len;
    //
    logic MOSI_value [$];
    logic MISO_value [$];
    // DIO
    `RFM_DECLARE(RST, 1)
    `RFM_DECLARE(start_in, 1)
    `RFM_DECLARE(spi_mode_in, 2)
    `RFM_DECLARE(sck_speed_in, 2)
    `RFM_DECLARE(word_len_in, 2)
    `RFM_DECLARE(IFG_in, 8)
    `RFM_DECLARE(CS_SCK_in, 8)
    `RFM_DECLARE(SCK_CS_in, 8)
    `RFM_DECLARE(mosi_data_in, 32)
    `RFM_DECLARE(miso_data_out, 32)
    // SPI
    `RFM_DECLARE(CS_out, 1)
    // logic [WIDTH-1:0] PORT_NAME_mirror; event PORT_NAME_change_e;

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
            // monitor_cs();
            predict_spi_frames();
        join_none

    endtask : run_phase

    // task monitor_cs();
    //     forever begin
            
            
    //     end
    // endtask : monitor_cs

    function void spi_unpack();
        for(int i=(true_word_len-1); i>=0; i--) begin
            MOSI_value.push_back(mosi_data_in_mirror[i]);
            MISO_value.push_back(miso_data_out_mirror[i]);
        end
    endfunction : spi_unpack

    task predict_spi_frames();//, time timestamp);
        spi_seq_item spi_pkt_exp;
        forever begin
            @(CS_out_change_e);
            if (CS_out_mirror == 1) begin
                spi_unpack();
                fork
                    begin // MOSI
                    spi_pkt_exp = spi_seq_item::type_id::create("spi_pkt_exp");
                    spi_pkt_exp.item_type = "exp_item";
                    spi_pkt_exp.name = "MOSI_frame";
                    spi_pkt_exp.data = MOSI_value;
                    `uvm_info(get_name(), $sformatf("the bit count of MOSI frame is:\n %0d", spi_pkt_exp.data.size()), UVM_LOW)
                    spi_pkt_exp.exp_timestamp_min = $realtime;
                    spi_pkt_exp.exp_timestamp_max = $realtime + 10ns;
                    spi_rfm_port.write(spi_pkt_exp);
                    end
                    begin // MISO
                    spi_pkt_exp = spi_seq_item::type_id::create("spi_pkt_exp");
                    spi_pkt_exp.item_type = "exp_item";
                    spi_pkt_exp.name = "MISO_frame";
                    spi_pkt_exp.data = MISO_value;
                    `uvm_info(get_name(), $sformatf("the bit count of MISO frame is:\n %0d", spi_pkt_exp.data.size()), UVM_LOW)
                    spi_pkt_exp.exp_timestamp_min = $realtime;
                    spi_pkt_exp.exp_timestamp_max = $realtime + 10ns;
                    spi_rfm_port.write(spi_pkt_exp);
                    end
                join
            end
        end
    endtask : predict_spi_frames

    // task predict_dio(string name, int value);
    //     dio_seq_item dio_pkt_exp = dio_seq_item::type_id::create("dio_pkt_exp");
    //     dio_pkt_exp.item_type = "exp_item";
    //     dio_pkt_exp.name = name;
    //     dio_pkt_exp.value = value;

    //     dio_rfm_port.write(dio_pkt_exp);
    // endtask : predict_dio

    function void write_dio(dio_seq_item item);

        `uvm_info(get_name(), $sformatf("Data received from DIO_MTR to predict on: "), UVM_LOW)
        item.print();

        case(item.name)
        "RST": begin
            `RFM_CHECK(item, RST)
        end
        "start_in": begin
            `RFM_CHECK(item, start_in)
        end
        "spi_mode_in": begin
            `RFM_CHECK(item, spi_mode_in)
        end
        "sck_speed_in": begin
            `RFM_CHECK(item, sck_speed_in)
            case(sck_speed_in_mirror)
            0: true_sck_speed = 64;
            1: true_sck_speed = 32;
            2: true_sck_speed = 16;
            3: true_sck_speed = 8;
            endcase
        end
        "word_len_in": begin
            `RFM_CHECK(item, word_len_in)
            case(word_len_in_mirror)
            0: true_word_len = 32;
            1: true_word_len = 16;
            2: true_word_len = 8;
            3: true_word_len = 4;
            endcase
        end
        "IFG_in": begin
            `RFM_CHECK(item, IFG_in)
        end
        "CS_SCK_in": begin
            `RFM_CHECK(item, CS_SCK_in)
        end
        "SCK_CS_in": begin
            `RFM_CHECK(item, SCK_CS_in)
        end
        "mosi_data_in": begin
            `RFM_CHECK(item, mosi_data_in)
        end
        "miso_data_out": begin
            `RFM_CHECK(item, miso_data_out)
        end
        default: begin
            `uvm_info(get_name(), $sformatf("Wrong %p name supplied: %s", item.get_name(), item.name), UVM_LOW)
        end
        endcase

    endfunction : write_dio

    function void write_spi(spi_seq_item item);

        `uvm_info(get_name(), $sformatf("Data received from SPI_MTR to predict on: "), UVM_LOW)
        item.print();

        case (item.name)
        "CS_out": begin
            `RFM_CHECK(item, CS_out)
        end
        default: begin
            `uvm_info(get_name(), $sformatf("Wrong %p name supplied: %s", item.get_name(), item.name), UVM_LOW)
        end
        endcase

    endfunction : write_spi

endclass: ref_model
