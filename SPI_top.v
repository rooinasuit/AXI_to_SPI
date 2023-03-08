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

    input  MISO,
    output MOSI,
    output SCK,
    output CS
);

wire start_out;
wire busy_in;
//
wire [1:0] spi_mode_out;
wire [1:0] sck_speed_out;
wire [1:0] word_len_out;
//
wire [7:0] IFG_out;
wire [7:0] CS_SCK_out;
wire [7:0] SCK_CS_out;
//
wire [31:0] mosi_data_out;
wire [31:0] miso_data_in;

SPI_regs SPI_regs0 (
    .GCLK (GCLK),
    .RST  (RST),
    .start_in  (start_in),
    .start_out (start_out),
    .busy_in   (busy_in),
    .busy_out  (busy_out),
    .spi_mode_in   (spi_mode_in),
    .spi_mode_out  (spi_mode_out),
    .sck_speed_in  (sck_speed_in),
    .sck_speed_out (sck_speed_out),
    .word_len_in   (word_len_in),
    .word_len_out  (word_len_out),
    .IFG_in     (IFG_in),
    .IFG_out    (IFG_out),
    .CS_SCK_in  (CS_SCK_in),
    .CS_SCK_out (CS_SCK_out),
    .SCK_CS_in  (SCK_CS_in),
    .SCK_CS_out (SCK_CS_out),
    .mosi_data_in  (mosi_data_in),
    .mosi_data_out (mosi_data_out),
    .miso_data_in  (miso_data_in),
    .miso_data_out (miso_data_out)
);

SPI_master SPI_master0 (
    .GCLK (GCLK),
    .RST  (RST),
    .spi_mode  (spi_mode_out),
    .sck_speed (sck_speed_out),
    .word_len  (word_len_out),
    .start (start_out),
    .t_IFG    (IFG_out),
    .t_CS_SCK (CS_SCK_out),
    .t_SCK_CS (SCK_CS_out),
    .busy  (busy_in),
    .mosi_data (mosi_data_out),
    .miso_data (miso_data_in),
    .i_MISO (MISO),
    .o_MOSI (MOSI),
    .o_SCK  (SCK),
    .o_CS   (CS)
);

endmodule