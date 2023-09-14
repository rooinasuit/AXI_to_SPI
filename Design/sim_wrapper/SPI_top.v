`include "SPI_regs.v"

module SPI_top (
    input GCLK,
    input NRST,
    //
    input  start_i,
    output busy_o,
    //
    input [1:0] spi_mode_i,
    input [1:0] sck_speed_i,
    input [1:0] word_len_i,
    //
    input [7:0] IFG_i,
    input [7:0] CS_SCK_i,
    input [7:0] SCK_CS_i,
    //
    input  [31:0] mosi_data_i,
    output [31:0] miso_data_o,

    input  MISO_i,
    output MOSI_o,
    output SCLK_o,
    output CS_o
);

SPI_regs SPI_regs0 (
    .GCLK (GCLK),
    .NRST (NRST),
    .start_i (start_i),
    .busy_o  (busy_o),
    .spi_mode_i   (spi_mode_i),
    .sck_speed_i  (sck_speed_i),
    .word_len_i   (word_len_i),
    .IFG_i     (IFG_i),
    .CS_SCK_i  (CS_SCK_i),
    .SCK_CS_i  (SCK_CS_i),
    .mosi_data_i (mosi_data_i),
    .miso_data_o (miso_data_o),
    .MISO_i (MISO_i),
    .MOSI_o (MOSI_o),
    .SCLK_o (SCLK_o),
    .CS_o (CS_o)
);

endmodule