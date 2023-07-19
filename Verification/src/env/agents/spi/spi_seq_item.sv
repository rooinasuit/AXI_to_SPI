
class spi_seq_item extends uvm_sequence_item;

    string item_type;

    string name;
    int value;

    logic data [$];

    time CS_to_SCK;
    time SCK_to_CS;

    time obs_timestamp; // make those equeal to $time or $realtime
    time exp_timestamp_min;
    time exp_timestamp_max;

    // min time between rising and falling edges
    // max time between rising and falling edges
    // also get info on d of the spi square wave
    // measure freq and d

    `uvm_object_utils_begin(spi_seq_item)
        `uvm_field_string(item_type, UVM_DEFAULT)
        `uvm_field_string(name, UVM_DEFAULT)
        `uvm_field_int(value, UVM_DEFAULT)
        `uvm_field_queue_int(data, UVM_DEFAULT)
        `uvm_field_int(CS_to_SCK, UVM_DEFAULT)
        `uvm_field_int(SCK_to_CS, UVM_DEFAULT)
        `uvm_field_int(obs_timestamp, UVM_DEFAULT)
        `uvm_field_int(exp_timestamp_min, UVM_DEFAULT)
        `uvm_field_int(exp_timestamp_max, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "spi_seq_item");
        super.new(name);
    endfunction : new

    function bit compare_packet(spi_seq_item item);

        spi_seq_item obs_item;
        spi_seq_item exp_item;

        bit res;

        if(this.item_type == "obs_item") begin
            obs_item = this;
            exp_item = item;
        end
        else if(this.item_type == "exp_item") begin
            obs_item = item;
            exp_item = this;
        end

        `uvm_info(get_name(), $sformatf("values:"), UVM_LOW)
        obs_item.print();
        exp_item.print();

        res = compare_field(obs_item, exp_item, "name") &&
              compare_field(obs_item, exp_item, "value") &&
              compare_field(obs_item, exp_item, "timestamp") &&
              compare_field(obs_item, exp_item, "data");
            //   compare_field(obs_item, exp_item, "timings") &&
        
        return res;

    endfunction : compare_packet

    function bit compare_field(spi_seq_item obs_item, spi_seq_item exp_item, string field_name);

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
        "data": begin
            if(obs_item.data.size() == exp_item.data.size()) begin
                if(obs_item.data == exp_item.data) begin
                    return 1;
                end
                else begin
                    return 0;
                end
            end
            else begin
                return 0;
            end
        end
        "timings": begin
            if((obs_item.CS_to_SCK == exp_item.CS_to_SCK) && (obs_item.SCK_to_CS == exp_item.SCK_to_CS)) begin
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

endclass : spi_seq_item
