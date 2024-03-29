`define COMP_DECLARE(OBJECT_TYPE, PORT_NAME) \
    comparator#(OBJECT_TYPE) comp_``PORT_NAME; \

`define COMP_CREATE(OBJECT_TYPE, PORT_NAME) \
    comp_``PORT_NAME = comparator#(OBJECT_TYPE)::type_id::create(`"comp_``PORT_NAME`", this); \

`define RFM_DECLARE_P(PORT_NAME, WIDTH) \
    logic [WIDTH-1:0] PORT_NAME``_mirror; \
    event PORT_NAME``_change_e; \

`define RFM_DECLARE_UP(PORT_NAME, WIDTH) \
    logic PORT_NAME``_mirror [WIDTH]; \
    event PORT_NAME``_change_e; \
    int PORT_NAME``_mirror_packed; \

`define UPDATE_MIRROR(ITEM, PORT_NAME) \
    if (ITEM.value !== PORT_NAME``_mirror) begin \
        PORT_NAME``_mirror = ITEM.value; \
        ->PORT_NAME``_change_e; \
        // `uvm_info(get_name(), ({"\n",`"PORT_NAME`"," event called - value has changed"}), UVM_LOW) \
    end \

`define SYNC_TO_CLOCK(PORT_NAME, CLOCK) \
forever begin \
    @(PORT_NAME``_mirror); \
    wait(CLOCK``_mirror == 1); \
    PORT_NAME``_mirror_synced = PORT_NAME``_mirror; \
end