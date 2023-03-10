module SPI_regs (
    input GCLK,
    input RST,

    input start_in;
    output start_out;

    input busy_in;
    output busy_out;
    //
    input [1:0] spi_mode_in;
    output [1:0] spi_mode_out;

    input [1:0] sck_speed_in;
    output [1:0] sck_speed_out;
    
    input [1:0] word_len_in;
    output [1:0] word_len_out;
    //
    input [7:0] IFG_in;
    output [7:0] IFG_out;

    input [7:0] CS_SCK_in;
    output [7:0] CS_SCK_out;

    input [7:0] SCK_CS_in;
    output [7:0] SCK_CS_out;
    //
    input [31:0] mosi_data_in;
    output [31:0] mosi_data_out;

    input [31:0] miso_data_in;
    output [31:0] miso_data_out;
);

reg start_reg;
reg busy_reg;
//
reg [1:0] spi_mode_reg;
reg [1:0] sck_mode_reg;
reg [1:0] word_len_reg;
//
reg [7:0] IFG_reg;
reg [7:0] CS_SCK_reg;
reg [7:0] SCK_CS_reg;
//
reg [31:0] mosi_data_reg;
reg [31:0] miso_data_reg;

always @ (posedge GCLK) begin
    if (RST) begin
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
    end
    else begin
        start_reg <= start_in;
        busy_reg  <= busy_in;
        //
        spi_mode_reg  <= spi_mode_in;  // do not change while busy
        sck_speed_reg <= sck_speed_in; // do not change while busy
        word_len_reg  <= word_len_in;  // do not change while busy
        //
        IFG_reg    <= IFG_in;    // do not change while busy
        CS_SCK_reg <= CS_SCK_in; // do not change while busy
        SCK_CS_reg <= SCK_CS_in; // do not change while busy
        //
        mosi_data_reg <= mosi_data_in;
        miso_data_reg <= miso_data_in;
    end
end

assign start_out = start_reg;
assign busy_out  = busy_reg;
//
assign spi_mode_out  = spi_mode_reg;
assign sck_speed_out = sck_speed_reg;
assign word_len_out  = word_len_reg;
//
assign IFG_out    = IFG_reg;
assign CS_SCK_out = CS_SCK_reg;
assign SCK_CS_out = SCK_CS_reg;
//
assign mosi_data_out = mosi_data_reg;
assign miso_data_out = miso_data_reg;

endmodule