`define COMP_DECLARE(OBJECT_TYPE, PORT_NAME) \
    comparator#(OBJECT_TYPE) comp_``PORT_NAME; \

`define COMP_CREATE(OBJECT_TYPE, PORT_NAME) \
    comp_``PORT_NAME = comparator#(OBJECT_TYPE)::type_id::create(`"comp_``PORT_NAME`", this);