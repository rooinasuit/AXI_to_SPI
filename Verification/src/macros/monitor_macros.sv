`define MONITOR_WATCH(PORT_NAME_OUT, PORT_NAME_IN, CREATE_HANDLE, WRITE_TRANSACTION) \
    old_port_val = PORT_NAME_IN; \
    // forever begin \
        @(PORT_NAME_IN !== old_port_val) \
            // CREATE_HANDLE(); \
            // new_port_val = PORT_NAME_IN; \
            // if (new_port_val !== old_port_val) begin \
                PORT_NAME_OUT = PORT_NAME_IN; \
                // old_port_val = new_port_val; \
                `uvm_info("DIO_MTR", $sformatf("Detected change on PORT_NAME_IN: %0d -> %0d", old_port_val, new_port_val), UVM_LOW) \
            // end \
            // WRITE_TRANSACTION(); \
    // end

`define MONITOR_WATCH_VARS \
    var old_port_val; \
    var new_port_val;