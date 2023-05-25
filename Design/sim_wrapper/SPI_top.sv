`timescale 1ns/1ps

`include "SPI_regs.sv"

module SPI_top (
    input GCLK,
    input RST,
    //
    input  start_in,
    output busy_out,
    //
    input [1:0] spi_mode_in,
    input [1:0] sck_speed_in,
    input [1:0] word_len_in,
    //
    input [7:0] IFG_in,
    input [7:0] CS_SCK_in,
    input [7:0] SCK_CS_in,
    //
    input  [31:0] mosi_data_in,
    output [31:0] miso_data_out,

    input  MISO_in,
    output MOSI_out,
    output SCLK_out,
    output CS_out
);

SPI_regs SPI_regs0 (
    .GCLK (GCLK),
    .RST  (RST),
    .start_in  (start_in),
    .busy_out  (busy_out),
    .spi_mode_in   (spi_mode_in),
    .sck_speed_in  (sck_speed_in),
    .word_len_in   (word_len_in),
    .IFG_in     (IFG_in),
    .CS_SCK_in  (CS_SCK_in),
    .SCK_CS_in  (SCK_CS_in),
    .mosi_data_in  (mosi_data_in),
    .miso_data_out (miso_data_out),
    .MISO_in (MISO_in),
    .MOSI_out (MOSI_out),
    .SCLK_out (SCLK_out),
    .CS_out (CS_out)
);

endmodule