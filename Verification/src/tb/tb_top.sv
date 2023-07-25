import uvm_pkg::*;
`include "uvm_macros.svh"

`include "clock_interface.sv"
`include "dio_interface.sv"
`include "spi_interface.sv"

`include "SPI_top.v"

import test_pkg::*;

module tb_top;

    clock_interface c_itf();
    dio_interface   d_itf();
    spi_interface   s_itf();

    logic GCLK;
    //
    logic NRST;
    logic start_in;
    logic [1:0] spi_mode_i;
    logic [1:0] sck_speed_i;
    logic [1:0] word_len_i;
    logic [7:0] IFG_i;
    logic [7:0] CS_SCK_i;
    logic [7:0] SCK_CS_i;
    logic [31:0] mosi_data_i;

    logic busy_o;
    logic [31:0] miso_data_o;
    //
    logic MISO_i;

    logic MOSI_o;
    logic SCLK_o;
    logic CS_o;

    // clk_to_DUT
    assign GCLK = c_itf.GCLK;

    // dio_to_DUT
    assign NRST           = d_itf.NRST;
    assign start_i       = d_itf.start_i;
    assign spi_mode_i    = d_itf.spi_mode_i;
    assign sck_speed_i   = d_itf.sck_speed_i;
    assign word_len_i    = d_itf.word_len_i;
    assign IFG_i         = d_itf.IFG_i;
    assign CS_SCK_i      = d_itf.CS_SCK_i;
    assign SCK_CS_i      = d_itf.SCK_CS_i;
    assign mosi_data_i   = d_itf.mosi_data_i;
    // dio_from_DUT
    assign d_itf.busy_o      = busy_o;
    assign d_itf.miso_data_o = miso_data_o;
    // dio_from_spi
    assign d_itf.CS_o = CS_o;

    // spi_to_DUT
    assign MISO_i = s_itf.MISO_i;
    // spi_from_DUT
    assign s_itf.MOSI_o = MOSI_o;
    assign s_itf.SCLK_o = SCLK_o;
    assign s_itf.CS_o   = CS_o;

    SPI_top DUT(
        .GCLK        (GCLK),
        //
        .NRST         (NRST),
        .start_i     (start_i),
        .busy_o      (busy_o),
        .spi_mode_i  (spi_mode_i),
        .sck_speed_i (sck_speed_i),
        .word_len_i  (word_len_i),
        .IFG_i       (IFG_i),
        .CS_SCK_i    (CS_SCK_i),
        .SCK_CS_i    (SCK_CS_i),
        .mosi_data_i (mosi_data_i),
        .miso_data_o (miso_data_o),
        //
        .MISO_i      (MISO_i),
        .MOSI_o      (MOSI_o),
        .SCLK_o      (SCLK_o),
        .CS_o        (CS_o)
    );

    initial begin
        uvm_config_db#(virtual clock_interface)::set(null, "uvm_test_top*", "c_vif", c_itf); // clock driver
        uvm_config_db#(virtual dio_interface)::set(null, "uvm_test_top*", "d_vif", d_itf); // dio driver/monitor
        uvm_config_db#(virtual spi_interface)::set(null, "uvm_test_top*", "s_vif", s_itf); // spi driver/monitor

        run_test();
    end

endmodule : tb_top
