`define MONITOR_WATCH(VAL_NAME, HANDLE_NAME) \
begin \
        int prev_val; \
        int curr_val; \
        HANDLE_NAME``_pkt = HANDLE_NAME``_seq_item::type_id::create("HANDLE_NAME``_pkt"); \
        HANDLE_NAME``_pkt.name = `"VAL_NAME`"; \
        HANDLE_NAME``_pkt.value = vif.``VAL_NAME; \
        HANDLE_NAME``_mtr_port.write(HANDLE_NAME``_pkt); \
        forever begin \
            prev_val = vif.``VAL_NAME; \
            @(vif.``VAL_NAME) \
                curr_val = vif.``VAL_NAME; \
                if (curr_val != prev_val) begin \
                    HANDLE_NAME``_pkt = HANDLE_NAME``_seq_item::type_id::create("HANDLE_NAME``_pkt"); \
                    HANDLE_NAME``_pkt.name = `"VAL_NAME`"; \
                    HANDLE_NAME``_pkt.value = curr_val; \
                    HANDLE_NAME``_mtr_port.write(HANDLE_NAME``_pkt); \
                    prev_val = curr_val; \
                end \
        end \
end