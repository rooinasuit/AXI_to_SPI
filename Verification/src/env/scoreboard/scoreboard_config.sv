
class scoreboard_config extends uvm_object;

    `uvm_object_utils(scoreboard_config)

    logic [1:0] spi_mode;
    logic [4:0] word_len;
    logic [5:0] sck_speed;

    function new (string name = "scoreboard_config");
        super.new(name);
    endfunction : new

endclass : scoreboard_config