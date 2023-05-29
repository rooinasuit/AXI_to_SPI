
interface dio_interface();

    // GLOBAL INPUT SIGNALS
    logic RST;

    // requested inputs
    logic start_in;
    //
    logic [1:0] spi_mode_in;
    logic [1:0] sck_speed_in;
    logic [1:0] word_len_in;
    //
    logic [7:0] IFG_in;
    logic [7:0] CS_SCK_in;
    logic [7:0] SCK_CS_in;
    //
    logic [31:0] mosi_data_in;

    // received outputs
    logic busy_out;
    //
    logic [31:0] miso_data_out;

endinterface : dio_interface