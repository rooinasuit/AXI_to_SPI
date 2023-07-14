
interface spi_interface();

    // requested inputs
    logic MISO_in;

    // received outputs
    logic MOSI_out;
    logic SCLK_out;
    logic CS_out;

endinterface : spi_interface