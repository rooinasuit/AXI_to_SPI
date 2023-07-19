
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

        bit res;

        if(this.item_type == "obs_item") begin
            obs_item = this;
            exp_item = item;
        end
        else if(this.item_type == "exp_item") begin
            obs_item = item;
            exp_item = this;
        end

        res = compare_field(obs_item, exp_item, "name") &&
              compare_field(obs_item, exp_item, "value");
            //   compare_field(obs_item, exp_item, "timestamp");
        
        return res;

    endfunction : compare_packet

    function bit compare_field(dio_seq_item obs_item, dio_seq_item exp_item, string field_name);

        case(field_name)
        "name": begin
            if(obs_item.name == exp_item.name) begin
                return 1;
            end
            else begin
                return 0;
            end
        end
        "value": begin
            if(obs_item.value == exp_item.value) begin
                return 1;
            end
            else begin
                return 0;
            end
        end
        "timestamp": begin
            if(obs_item.obs_timestamp <= exp_item.exp_timestamp_max
            && obs_item.obs_timestamp >= exp_item.exp_timestamp_min) begin
                return 1;
            end
            else begin
                return 0;
            end
        end
        default: begin
            `uvm_info(get_name(), $sformatf("%s is not a valid field for comparison in dio_seq_item", field_name), UVM_LOW)
        end
        endcase

    endfunction : compare_field

endclass : dio_seq_item
