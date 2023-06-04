import uvm_pkg::*;

`include "SPI_top.v"

// `include "clock_interface.sv"
`include "dio_interface.sv"
`include "spi_slave_interface.sv"

import test_pkg::*;

module tb_top;

    // clock_interface     c_itf();
    dio_interface       d_itf();
    spi_slave_interface s_itf();

    bit GCLK;
    time period = 10ns;

    SPI_top DUT(
        .GCLK          (GCLK),
        .RST           (d_itf.RST),
        .start_in      (d_itf.start_in),
        .busy_out      (d_itf.busy_out),
        .spi_mode_in   (d_itf.spi_mode_in),
        .sck_speed_in  (d_itf.sck_speed_in),
        .word_len_in   (d_itf.word_len_in),
        .IFG_in        (d_itf.IFG_in),
        .CS_SCK_in     (d_itf.CS_SCK_in),
        .SCK_CS_in     (d_itf.SCK_CS_in),
        .mosi_data_in  (d_itf.mosi_data_in),
        .miso_data_out (d_itf.miso_data_out),
        //
        .MISO_in       (s_itf.MISO_in),
        .MOSI_out      (s_itf.MOSI_out),
        .SCLK_out      (s_itf.SCLK_out),
        .CS_out        (s_itf.CS_out)
    );

    initial begin
        forever#(period/2) GCLK = ~GCLK;
    end

    initial begin

        // uvm_config_db#(virtual clock_interface)::set(null, "*", "c_vif", c_itf); // clock driver
        uvm_config_db#(virtual dio_interface)::set(null, "*", "d_vif", d_itf); // dio driver/monitor
        uvm_config_db#(virtual spi_slave_interface)::set(null, "*", "s_vif", s_itf); // spi slave driver/monitor

        run_test("test_0010_1");
    end

endmodule : tb_top
