`define FIRST_OF \
    fork \
    begin \
    fork \

`define END_FIRST_OF \
    join_any \
    disable fork; \
    end \
    join