import uvm_pkg::*;

`include "SPI_top.v"

`include "clock_interface.sv"
`include "dio_interface.sv"
`include "spi_interface.sv"

import test_pkg::*;

module tb_top;

    clock_interface c_itf();
    dio_interface   d_itf();
    spi_interface   s_itf();

    SPI_top DUT(
        .GCLK          (c_itf.GCLK),
        //
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
        uvm_config_db#(virtual clock_interface)::set(null, "uvm_test_top*", "c_vif", c_itf); // clock driver
        uvm_config_db#(virtual dio_interface)::set(null, "uvm_test_top*", "d_vif", d_itf); // dio driver/monitor
        uvm_config_db#(virtual spi_interface)::set(null, "uvm_test_top*", "s_vif", s_itf); // spi slave driver/monitor
        // tu zmienić scope na test
        run_test("test_0010_1");
    end

endmodule : tb_top
