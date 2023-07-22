
interface spi_interface();

    // requested inputs
    logic MISO_i;

    // received outputs
    logic MOSI_o;
    logic SCLK_o;
    logic CS_o;

endinterface : spi_interface