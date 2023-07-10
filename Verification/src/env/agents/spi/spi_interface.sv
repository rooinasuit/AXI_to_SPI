
interface spi_interface();

    // requested inputs
    bit MISO_in;

    // received outputs
    bit MOSI_out;
    bit SCLK_out;
    bit CS_out;

    task reset_spi();
        MISO_in = 0;
    endtask : reset_spi

endinterface : spi_interface