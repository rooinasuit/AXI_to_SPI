`define MONITOR_WATCH(value_in, name_out, pkt_name_out, pkt_val_out, prev_val, curr_val) \
begin \
        prev_val = 0; \
        curr_val = 0; \
        prev_val = value_in; \
        @(value_in) \
            curr_val = value_in; \
            if (curr_val != prev_val) begin \
                pkt_name_out = name_out; \
                pkt_val_out  = curr_val; \
                `uvm_info("DIO_MTR", $sformatf("Detected change on %s: %0d -> %0d", name_out, prev_val, curr_val), UVM_LOW) \
                prev_val = curr_val; \
            end \
end

// `define MONITOR_WATCH_VARS \
//     var old_port_val; \
//     var new_port_val;