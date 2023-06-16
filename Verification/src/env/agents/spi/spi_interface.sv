
interface spi_interface();

    // requested inputs
    bit MISO_in;

    // received outputs
    bit MOSI_out;
    bit SCLK_out;
    bit CS_out;

endinterface : spi_interface