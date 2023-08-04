`include "SPI_master.v"

module SPI_regs (
    input GCLK,
    input NRST,
    //
    input start_i,
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
    input [31:0] mosi_data_i,
    output [31:0] miso_data_o,
    //
    input MISO_i,
    output MOSI_o,
    output SCLK_o,
    output CS_o
);

wire start_v;
wire busy_v;
//
wire [1:0] spi_mode_v;
wire [1:0] sck_speed_v;
wire [1:0] word_len_v;
//
wire [7:0] IFG_v;
wire [7:0] CS_SCK_v;
wire [7:0] SCK_CS_v;
//
wire [31:0] mosi_data_v;
wire [31:0] miso_data_v;

wire MISO_v;
wire MOSI_v;
wire SCLK_v;
wire CS_v;

reg start_reg;
reg busy_reg;
//
reg [1:0] spi_mode_reg;
reg [1:0] sck_speed_reg;
reg [1:0] word_len_reg;
//
reg [7:0] IFG_reg;
reg [7:0] CS_SCK_reg;
reg [7:0] SCK_CS_reg;
//
reg [31:0] mosi_data_reg;
reg [31:0] miso_data_reg;

reg MISO_reg;
reg MOSI_reg;
reg SCLK_reg;
reg CS_reg;

SPI_master SPI_master0 (
    .GCLK (GCLK),
    .NRST  (NRST),
    .start_i (start_v),
    .busy_o  (busy_v),
    .spi_mode_i  (spi_mode_v),
    .sck_speed_i (sck_speed_v),
    .word_len_i  (word_len_v),
    .IFG_i    (IFG_v),
    .CS_SCK_i (CS_SCK_v),
    .SCK_CS_i (SCK_CS_v),
    .mosi_data_i (mosi_data_v),
    .miso_data_o (miso_data_v),

    .MISO_i (MISO_v),
    .MOSI_o (MOSI_v),
    .SCLK_o (SCLK_v),
    .CS_o   (CS_v)
);

always @ (posedge GCLK) begin
    if (!NRST) begin
        start_reg <= 1'd0;
        busy_reg  <= 1'd0;
        //
        spi_mode_reg  <= 2'd0;
        sck_speed_reg <= 2'd0;
        word_len_reg  <= 2'd0;
        //
        IFG_reg    <= 8'd0;
        CS_SCK_reg <= 8'd0;
        SCK_CS_reg <= 8'd0;
        //
        mosi_data_reg <= 32'd0;
        miso_data_reg <= 32'd0;
        //
        MISO_reg <= 1'b0;
        MOSI_reg <= 1'b0;
        SCLK_reg <= 1'b0;
        CS_reg   <= 1'b1;
    end
    else begin
        start_reg <= start_i;
        busy_reg  <= busy_v;
        //
        spi_mode_reg  <= spi_mode_i;  // do not change while busy
        sck_speed_reg <= sck_speed_i; // do not change while busy
        word_len_reg  <= word_len_i;  // do not change while busy
        //
        IFG_reg    <= IFG_i;    // do not change while busy
        CS_SCK_reg <= CS_SCK_i; // do not change while busy
        SCK_CS_reg <= SCK_CS_i; // do not change while busy
        //
        mosi_data_reg <= mosi_data_i;
        miso_data_reg <= miso_data_v;
        //
        MISO_reg <= MISO_i;
        MOSI_reg <= MOSI_v;
        SCLK_reg <= SCLK_v;
        CS_reg   <= CS_v;
    end
end

assign start_v  = start_reg;
assign busy_o = busy_reg;
//
assign spi_mode_v  = spi_mode_reg;
assign sck_speed_v = sck_speed_reg;
assign word_len_v  = word_len_reg;
//
assign IFG_v    = IFG_reg;
assign CS_SCK_v = CS_SCK_reg;
assign SCK_CS_v = SCK_CS_reg;
//
assign mosi_data_v = mosi_data_reg;
assign miso_data_o = miso_data_reg;

assign MISO_v   = MISO_reg;
assign MOSI_o = MOSI_reg;
assign SCLK_o = SCLK_reg;
assign CS_o   = CS_reg;

endmodule