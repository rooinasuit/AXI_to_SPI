`define MONITOR_WATCH(VAL_NAME, HANDLE_NAME) \
begin \
        int prev_val; \
        int curr_val; \
        HANDLE_NAME``_pkt_in = HANDLE_NAME``_seq_item::type_id::create(`"``HANDLE_NAME``_pkt_in`"); \
        HANDLE_NAME``_pkt_in.name = `"VAL_NAME`"; \
        HANDLE_NAME``_pkt_in.value = vif.``VAL_NAME; \
        HANDLE_NAME``_mtr_port.write(HANDLE_NAME``_pkt_in); \
        forever begin \
            prev_val = vif.``VAL_NAME; \
            @(vif.``VAL_NAME) \
                curr_val = vif.``VAL_NAME; \
                if (curr_val != prev_val) begin \
                    HANDLE_NAME``_pkt_in = HANDLE_NAME``_seq_item::type_id::create(`"``HANDLE_NAME``_pkt_in`"); \
                    HANDLE_NAME``_pkt_in.name = `"VAL_NAME`"; \
                    HANDLE_NAME``_pkt_in.value = curr_val; \
                    HANDLE_NAME``_mtr_port.write(HANDLE_NAME``_pkt_in); \
                    prev_val = curr_val; \
                end \
        end \
end