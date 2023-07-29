
class spi_seq_item extends uvm_sequence_item;

    string item_type;

    string name;

    logic data [$];

    time CS_to_SCK;
    time SCK_to_CS;

    time obs_timestamp; // make those equeal to $time or $realtime
    time exp_timestamp_min;
    time exp_timestamp_max;

    time clk_period_min; // do for observed and expected
    time clk_period_max; // do for observed and expected

    // measure freq

    `uvm_object_utils_begin(spi_seq_item)
        `uvm_field_string(item_type, UVM_DEFAULT)
        `uvm_field_string(name, UVM_DEFAULT)
        `uvm_field_queue_int(data, UVM_BIN)
        `uvm_field_int(CS_to_SCK, UVM_TIME)
        `uvm_field_int(SCK_to_CS, UVM_TIME)
        `uvm_field_int(obs_timestamp, UVM_TIME)
        `uvm_field_int(exp_timestamp_min, UVM_TIME)
        `uvm_field_int(exp_timestamp_max, UVM_TIME)
        `uvm_field_int(clk_period_min, UVM_TIME)
        `uvm_field_int(clk_period_max, UVM_TIME)
    `uvm_object_utils_end

    function new (string name = "spi_seq_item");
        super.new(name);
    endfunction : new

    function bit compare_packet(spi_seq_item item);

        spi_seq_item obs_item;
        spi_seq_item exp_item;

        int result_cnt;

        bit res;

        if(this.item_type == "obs_item") begin
            obs_item = this;
            exp_item = item;
        end
        else if(this.item_type == "exp_item") begin
            obs_item = item;
            exp_item = this;
        end

        $display("SPI_SEQ_ITEM FIELD COMPARISON");
        $display("=============================================");

        // result_cnt = compare_field(obs_item, exp_item, "name") +
        //              compare_field(obs_item, exp_item, "data") +
        //              compare_field(obs_item, exp_item, "timestamp") +
        //              compare_field(obs_item, exp_item, "clock") +
        //              compare_field(obs_item, exp_item, "timings");

        // res = (result_cnt == 5) ? 1 : 0;

        if(compare_field(obs_item, exp_item, "name") == 1) begin
            case(exp_item.name)
            "MOSI_frame": begin
                result_cnt = compare_field(obs_item, exp_item, "data") +
                             compare_field(obs_item, exp_item, "timestamp") +
                             compare_field(obs_item, exp_item, "clock") +
                             compare_field(obs_item, exp_item, "timings");

                res = (result_cnt == 4) ? 1 : 0;
            end
            "SCLK_pos": begin
                result_cnt = compare_field(obs_item, exp_item, "timestamp");

                res = (result_cnt == 1) ? 1 : 0;
            end
            "SCLK_neg": begin
                result_cnt = compare_field(obs_item, exp_item, "timestamp");

                res = (result_cnt == 1) ? 1 : 0;
            end
            endcase
        end

        return res;

    endfunction : compare_packet

    function bit compare_field(spi_seq_item obs_item, spi_seq_item exp_item, string field_name);

        case(field_name)
        "name": begin
            $display("obs_item | name:%s", obs_item.name);
            $display("exp_item | name:%s", exp_item.name);
            if(obs_item.name == exp_item.name) begin
                $display("COMPARISON OK\n");
                return 1;
            end
            else begin
                $display("ITEM NAME MISMATCH\n");
                return 0;
            end
        end
        "timestamp": begin
            $display("obs_item | obs_timestamp    : %0.1fns", obs_item.obs_timestamp);
            $display("exp_item | exp_timestamp_min: %0.1fns", exp_item.exp_timestamp_min);
            $display("exp_item | exp_timestamp_max: %0.1fns", exp_item.exp_timestamp_max);
            if (exp_item.exp_timestamp_max == 0) begin
                if(obs_item.obs_timestamp >= exp_item.exp_timestamp_min) begin
                    $display("COMPARISON OK\n");
                    return 1;
                end
                else begin
                    $display("INTERFRAME GAP TOO SHORT\n");
                    return 0;
                end
            end
            else begin
                if(obs_item.obs_timestamp <= exp_item.exp_timestamp_max
                && obs_item.obs_timestamp >= exp_item.exp_timestamp_min) begin
                    $display("COMPARISON OK\n");
                    return 1;
                end
                else begin
                    $display("TIME OF OCCURENCE IS OUT OF BOUNDS\n");
                    return 0;
                end
            end
        end
        "data": begin
            $display("obs_item | data:%p", obs_item.data);
            $display("exp_item | data:%p", exp_item.data);
            $display("obs_item | frame length:%0d", obs_item.data.size());
            $display("exp_item | frame length:%0d", exp_item.data.size());
            if(obs_item.data.size() == exp_item.data.size()) begin
                if(obs_item.data == exp_item.data) begin
                    $display("COMPARISON OK\n");
                    return 1;
                end
                else begin
                    $display("SAMPLED DATA DOES NOT MATCH PREDICTION\n");
                    return 0;
                end
            end
            else begin
                $display("SIZE OF SAMPLED DATA (%0d) DOES NOT MATCH PREDICTION (%0d)\n", obs_item.data.size(), exp_item.data.size());
                return 0;
            end
        end
        "clock": begin
            $display("obs_item | clk_period_min : %0.1fns", obs_item.clk_period_min);
            $display("obs_item | clk_period_max : %0.1fns", obs_item.clk_period_max);
            $display("exp_item | clk_period_min : %0.1fns", exp_item.clk_period_min);
            $display("exp_item | clk_period_max : %0.1fns", exp_item.clk_period_max);
            if(obs_item.clk_period_min < exp_item.clk_period_min
            || obs_item.clk_period_max > exp_item.clk_period_max) begin
                $display("SPI CLOCK PERIOD ERROR EXCEEDS 5%% TOLERANCE\n");
                return 0;
            end
            else begin
                $display("COMPARISON OK\n");
                return 1;
            end
        end
        "timings": begin
            $display("obs_item | CS_to_SCK:%0.1fns", obs_item.CS_to_SCK);
            $display("obs_item | SCK_to_CS:%0.1fns", obs_item.SCK_to_CS);
            $display("exp_item | CS_to_SCK:%0.1fns", exp_item.CS_to_SCK);
            $display("exp_item | SCK_to_CS:%0.1fns", exp_item.SCK_to_CS);
            if((obs_item.CS_to_SCK < exp_item.CS_to_SCK*0.95 || obs_item.CS_to_SCK > exp_item.CS_to_SCK*1.05)
            || (obs_item.SCK_to_CS < exp_item.SCK_to_CS*0.95 || obs_item.SCK_to_CS > exp_item.SCK_to_CS*1.05)) begin
                $display("PRE/POST SCLK TIMING ERROR EXCEEDS 5%% TOLERANCE\n");
                return 0;
            end
            else begin
                $display("COMPARISON OK\n");
                return 1;
            end
        end
        default: begin
            `uvm_info(get_name(), $sformatf("%s is not a valid field for comparison in dio_seq_item", field_name), UVM_LOW)
        end
        endcase

    endfunction : compare_field

endclass : spi_seq_item
