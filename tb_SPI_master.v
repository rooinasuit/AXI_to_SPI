`timescale 1ns/1ps
`include "SPI_master.v"

module tb_SPI_master ();

// GLOBAL SIGNALS
reg GCLK;
reg RST;

// CONFIG SIGNALS (regs)
reg [1:0] spi_mode;
reg [1:0] sck_speed;
reg [1:0] word_len;

// CONTROL SIGNALS
reg start;

// STATUS SIGNALS
reg  [7:0] t_IFG;
reg  [7:0] t_CStoSCK;
reg  [7:0] t_SCKtoCS;
wire       busy;

// SPI DATA
reg  [31:0] mosi_data;
wire [31:0] miso_data;

// SPI BUS
reg  MISO;
wire MOSI;
wire SCK;
wire CS;

SPI_master DUT (
    .GCLK      (GCLK),
    .RST       (RST),
    .spi_mode  (spi_mode),
    .sck_speed (sck_speed),
    .word_len  (word_len),
    .start     (start),
    .t_IFG     (t_IFG),
    .t_CS_SCK  (t_CStoSCK),
    .t_SCK_CS  (t_SCKtoCS),
    .busy      (busy),
    .mosi_data (mosi_data),
    .miso_data (miso_data),
    .i_MISO    (MISO),
    .o_MOSI    (MOSI),
    .o_SCK     (SCK),
    .o_CS      (CS)
);

initial begin // monitor
    $monitor("time = %4d, start = %b, spi_mode = %2b, 
              sck_speed = %2b, word_len = %2b, busy = %b, 
              mosi_data = %8h, miso_data = %8h, 
              MISO = %b, MOSI = %b, SCK = %b, CS = %b",
             $time, start, spi_mode, sck_speed, word_len, 
             busy, mosi_data, miso_data, MISO, MOSI, SCK, CS);
end

initial begin // clock
               GCLK = 1'b0;
    forever #5 GCLK = ~GCLK; // 100MHz
end

initial begin // reset
        RST = 1'b0;
    #20 RST = 1'b1;
    #10 RST = 1'b0;
end

initial begin
    MISO = 1'b0;
    forever #150 MISO = ~MISO;
end

always @ (posedge GCLK) begin
    if (!busy) begin
        start <= 1'b1;
    end
    else
        start <= 1'b0;
end

initial begin // all the other signals
        t_IFG     = 8'd5;
        t_CStoSCK = 8'd10;
        t_SCKtoCS = 9'd5;

        start = 1'b0;
        spi_mode  = 2'b10;
        sck_speed = 2'b11;
        word_len  = 2'b10;
        mosi_data = 32'haa000000;

    // #30 start = 1'b1;
    // //
    // #41000 start = 1'b0;

    // #10 spi_mode  = 2'b01;
    //     sck_speed = 2'b01;
    //     word_len  = 2'b01;
    //     mosi_data = 32'h87590000;

    // #30 start = 1'b1;
    // //
    // #10500 start = 1'b0;

    // #10 spi_mode  = 2'b10;
    //     sck_speed = 2'b10;
    //     word_len  = 2'b10;
    //     mosi_data = 32'hbf000000;

    // #30 start = 1'b1;
    // //
    // #3000 start = 1'b0;
        
    // #10 spi_mode  = 2'b11;
    //     sck_speed = 2'b11;
    //     word_len  = 2'b11;
    //     mosi_data = 32'h23000000;

    // #30 start = 1'b1;

    // #1000 start = 1'b0;
end
endmodule
