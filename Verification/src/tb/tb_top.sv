import uvm_pkg::*;
`include "uvm_macros.svh"

`include "clock_interface.sv"
`include "dio_interface.sv"
`include "spi_interface.sv"

import test_pkg::*;

module tb_top;

    clock_interface c_itf();
    dio_interface   d_itf();
    spi_interface   s_itf();

    logic GCLK;
    //
    logic RST;
    logic start_in;
    logic [1:0] spi_mode_in;
    logic [1:0] sck_speed_in;
    logic [1:0] word_len_in;
    logic [7:0] IFG_in;
    logic [7:0] CS_SCK_in;
    logic [7:0] SCK_CS_in;
    logic [31:0] mosi_data_in;

    logic busy_out;
    logic [31:0] miso_data_out;
    //
    logic MISO_in;

    logic MOSI_out;
    logic SCLK_out;
    logic CS_out;

    // clk_to_DUT
    assign GCLK = c_itf.GCLK;

    // dio_to_DUT
    assign RST            = d_itf.RST;
    assign start_in       = d_itf.start_in;
    assign spi_mode_in    = d_itf.spi_mode_in;
    assign sck_speed_in   = d_itf.sck_speed_in;
    assign word_len_in    = d_itf.word_len_in;
    assign IFG_in         = d_itf.IFG_in;
    assign CS_SCK_in      = d_itf.CS_SCK_in;
    assign SCK_CS_in      = d_itf.SCK_CS_in;
    assign mosi_data_in   = d_itf.mosi_data_in;
    // dio_from_DUT
    assign d_itf.busy_out = busy_out;
    assign d_itf.miso_data_out = miso_data_out;

    // spi_to_DUT
    assign MISO_in = s_itf.MISO_in;
    // spi_from_DUT
    assign s_itf.MOSI_out = MOSI_out;
    assign s_itf.SCLK_out = SCLK_out;
    assign s_itf.CS_out   = CS_out;

    SPI_top DUT(
        .GCLK          (GCLK),
        //
        .RST           (RST),
        .start_in      (start_in),
        .busy_out      (busy_out),
        .spi_mode_in   (spi_mode_in),
        .sck_speed_in  (sck_speed_in),
        .word_len_in   (word_len_in),
        .IFG_in        (IFG_in),
        .CS_SCK_in     (CS_SCK_in),
        .SCK_CS_in     (SCK_CS_in),
        .mosi_data_in  (mosi_data_in),
        .miso_data_out (miso_data_out),
        //
        .MISO_in       (MISO_in),
        .MOSI_out      (MOSI_out),
        .SCLK_out      (SCLK_out),
        .CS_out        (CS_out)
    );

    initial begin
        uvm_config_db#(virtual clock_interface)::set(null, "uvm_test_top*", "c_vif", c_itf); // clock driver
        uvm_config_db#(virtual dio_interface)::set(null, "uvm_test_top*", "d_vif", d_itf); // dio driver/monitor
        uvm_config_db#(virtual spi_interface)::set(null, "uvm_test_top*", "s_vif", s_itf); // spi driver/monitor

        // run_test("test_0010_1");
        run_test();
    end

endmodule : tb_top
