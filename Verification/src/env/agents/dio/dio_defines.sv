`define MONITOR_WATCH(VAL_NAME, HANDLE_NAME) \
begin \
        int prev_val; \
        int curr_val; \
        HANDLE_NAME``_pkt_in = HANDLE_NAME``_seq_item::type_id::create(`"``HANDLE_NAME``_pkt_in`"); \
        HANDLE_NAME``_pkt_in.item_type = "obs_item"; \
        HANDLE_NAME``_pkt_in.name = `"VAL_NAME`"; \
        HANDLE_NAME``_pkt_in.value = vif.``VAL_NAME; \
        HANDLE_NAME``_pkt_in.obs_timestamp = $realtime; \
        HANDLE_NAME``_mtr_port.write(HANDLE_NAME``_pkt_in); \
        // `uvm_info(get_name(), $display("PORT %s monitored at time %0t: %d", VAL_NAME, $realtime, vif.``VAL_NAME), UVM_LOW) \
        forever begin \
            prev_val = vif.``VAL_NAME; \
            @(vif.``VAL_NAME) \
                curr_val = vif.``VAL_NAME; \
                if (curr_val != prev_val) begin \
                    HANDLE_NAME``_pkt_in = HANDLE_NAME``_seq_item::type_id::create(`"``HANDLE_NAME``_pkt_in`"); \
                    HANDLE_NAME``_pkt_in.item_type = "obs_item"; \
                    HANDLE_NAME``_pkt_in.name = `"VAL_NAME`"; \
                    HANDLE_NAME``_pkt_in.value = curr_val; \
                    HANDLE_NAME``_pkt_in.obs_timestamp = $realtime; \
                    HANDLE_NAME``_mtr_port.write(HANDLE_NAME``_pkt_in); \
                end \
        end \
end