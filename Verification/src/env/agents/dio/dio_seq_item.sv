
class dio_seq_item extends uvm_sequence_item;

    string item_type;

    string name;
    int value;

    int obs_timestamp;
    int exp_timestamp_min;
    int exp_timestamp_max;

    `uvm_object_utils_begin(dio_seq_item)
        `uvm_field_string(item_type, UVM_DEFAULT)
        `uvm_field_string(name, UVM_DEFAULT)
        `uvm_field_int(value, UVM_DEFAULT)
        `uvm_field_int(obs_timestamp, UVM_DEFAULT)
        `uvm_field_int(exp_timestamp_min, UVM_DEFAULT)
        `uvm_field_int(exp_timestamp_max, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "dio_seq_item");
        super.new(name);
    endfunction : new

    function bit compare_packet(dio_seq_item item);

        dio_seq_item obs_item;
        dio_seq_item exp_item;

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

        $display("DIO_SEQ_ITEM FIELD COMPARISON");
        $display("=============================================");
        result_cnt = compare_field(obs_item, exp_item, "name") +
                     compare_field(obs_item, exp_item, "value") +
                     compare_field(obs_item, exp_item, "timestamp");
        
        res = (result_cnt == 3) ? 1 : 0;
        return res;

    endfunction : compare_packet

    function bit compare_field(dio_seq_item obs_item, dio_seq_item exp_item, string field_name);

        case(field_name)
        "name": begin
            $display("obs_item | name:%s", obs_item.name);
            $display("exp_item | name:%s", exp_item.name);
            if(obs_item.name == exp_item.name) begin
                $display("COMPARISON OK\n");
                return 1;
            end
            else begin
                $display("COMPARISON NOK\n");
                return 0;
            end
        end
        "value": begin
            $display("obs_item | value:%0h", obs_item.value);
            $display("exp_item | value:%0h", exp_item.value);
            if(obs_item.value == exp_item.value) begin
                $display("COMPARISON OK\n");
                return 1;
            end
            else begin
                $display("COMPARISON NOK\n");
                return 0;
            end
        end
        "timestamp": begin
            $display("obs_item | obs_timestamp    : %0.1fns", obs_item.obs_timestamp);
            $display("exp_item | exp_timestamp_min: %0.1fns", exp_item.exp_timestamp_min);
            $display("exp_item | exp_timestamp_max: %0.1fns", exp_item.exp_timestamp_max);
            if(obs_item.obs_timestamp <= exp_item.exp_timestamp_max
            && obs_item.obs_timestamp >= exp_item.exp_timestamp_min) begin
                $display("COMPARISON OK\n");
                return 1;
            end
            else begin
                $display("COMPARISON NOK\n");
                return 0;
            end
        end
        default: begin
            `uvm_info(get_name(), $sformatf("%s is not a valid field for comparison in dio_seq_item", field_name), UVM_LOW)
        end
        endcase

    endfunction : compare_field

endclass : dio_seq_item
