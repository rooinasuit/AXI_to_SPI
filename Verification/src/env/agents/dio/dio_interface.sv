
interface dio_interface();

    // GLOBAL INPUT SIGNALS
    logic GCLK;
    logic NRST;

    // requested inputs
    logic start_i;
    //
    logic [1:0] spi_mode_i;
    logic [1:0] sck_speed_i;
    logic [1:0] word_len_i;
    //
    logic [7:0] IFG_i;
    logic [7:0] CS_SCK_i;
    logic [7:0] SCK_CS_i;
    //
    logic [31:0] mosi_data_i;

    // received outputs
    logic busy_o;
    //
    logic [31:0] miso_data_o;

    // borrowed from spi
    logic CS_o;

endinterface : dio_interface