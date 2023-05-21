`timescale 1ns/1ps

module SPI_master (
    ////////////////////
    // GLOBAL SIGNALS //
    input GCLK, // global clock (say 100MHz)
    input RST,  // asynchronous reset

    /////////////////////
    // CONTROL SIGNALS //
    input      start_i, // transmission start flag [1 - start | 0 - stop]
    //
    output reg busy_o,  // busy flag [1 - busy | 0 - ready] whoa

    ////////////////////
    // CONFIG SIGNALS //
    input [1:0] spi_mode_i,  // one of 4 modes [SCK polarity, SCK phase, which SCK edge for picking up and which for shifting data] - mode 0 by default {CHECK}
    input [1:0] sck_speed_i, // [1/128, 1/64, 1/32, 1/16] of GCLK - 1/128 by default {CHECK}
    input [1:0] word_len_i,  // length of a single word directed on/sampled from the bus - [32, 16, 8, 4] bits - 32 bits by default {CHECK}

    ////////////////////
    // STATUS SIGNALS //
    input [7:0] t_IFG_i,    // minimum interframe gap (parameter)
    input [7:0] t_CS_SCK_i, // the time between the switch of CS polarity and the response in switch of SCK polarity (parameter)
    input [7:0] t_SCK_CS_i,

    //////////////
    // SPI DATA //
    input      [31:0] mosi_data_i, // data frame to send via MOSI (8/16/32 bits and the remaining are filled with zeroes)
    //
    output reg [31:0] miso_data_o, // data frame received via MISO (8/16/32 bits and the remaining are filled with zeroes)

    /////////////
    // SPI BUS //
    input  MISO_i,
    //
    output MOSI_o,
    output SCLK_o,
    output CS_o
);

wire trans_start;
reg  d_ff;
//
// reg [1:0] sck_mode;

wire sck_pol; // sck polarity - active high [0] or active low [1]
wire sck_pha; // sck phase - send on rising edge/pick up on falling edge [0] or send on falling edge/pick up on rising edge [1]
//
reg [5:0] sck_switch;
reg [5:0] sck_switch_cnt;
reg       sck;
//
wire pos_sck;
wire neg_sck;
//
reg       CS_to_SCK; // from !CS to the first SCK pulse
reg       SCK_to_CS;   // from the last SCK pulse to CS

reg [7:0] CSnSCK_cnt;
//
reg       IFG_done;
reg [7:0] IFG_cnt;
//
reg [4:0] chosen_word_len;
//
localparam IDLE        = 0;
localparam TRANSACTION = 1;
localparam FINISH      = 2;

reg [1:0]  state;

reg        mosi;
reg        chip_sel;

reg [31:0] miso_buff;
reg [31:0] mosi_buff;

reg [4:0]  bit_cnt;

wire trans_done;

////////////////////////
// SPI MODE SELECTION //

// 0: SCK active high, MOSI on rising SCK,  MISO on falling SCK
// 1: SCK active high, MOSI on falling SCK, MISO on rising SCK
// 2: SCK active low,  MOSI on rising SCK,  MISO on falling SCK
// 3: SCK active low,  MOSI on falling SCK, MISO on rising SCK

assign sck_pol = spi_mode_i[1];
assign sck_pha = spi_mode_i[0];

// always @ (posedge GCLK) begin
//     if (RST) begin
//         sck_mode <= 2'd0;
//     end
//     else begin
//         sck_mode <= spi_mode_i;
//     end
// end

// assign sck_pol = sck_mode[1];
// assign sck_pha = sck_mode[0];

/////////////////////////
// SCK SPEED SELECTION //

// sck_switch states the value at which to change clock polarity (double the clock period)

always @ (posedge GCLK) begin
    if (RST) begin
        sck_switch <= 6'd63;
    end
    else begin
        case (sck_speed_i)
            0: sck_switch  <= 6'd63; // [1/128] GCLK
            1: sck_switch  <= 6'd31; // [1/64] GCLK
            2: sck_switch  <= 6'd15; // [1/32] GCLK
            3: sck_switch  <= 6'd7;  // [1/16] GCLK
        endcase
    end
end

///////////////////////////
// WORD LENGTH SELECTION //

// Rx/Tx counter will decrement with each sent/received bit, hence [31 - word_len]

always @ (posedge GCLK) begin
    if (RST)
        chosen_word_len <= 5'd0;
    else begin
        case (word_len_i)
            0: chosen_word_len <= 5'd0; // 32-bit word
            1: chosen_word_len <= 5'd15; // 16-bit word
            2: chosen_word_len <= 5'd23; // 8-bit word
            3: chosen_word_len <= 5'd27; // 4-bit word
        endcase
    end
end

///////////////////
// SCK GENERATOR //

always @ (posedge GCLK) begin
    if (RST) begin
        sck_switch_cnt <= 6'd0;
        sck            <= (sck_pol) ? 1'd1 : 1'd0; // idle sck polarity?
    end
    else if (!chip_sel & !SCK_to_CS) begin
        if (sck_switch_cnt >= sck_switch & !CS_to_SCK) begin
            sck_switch_cnt <= 6'd0;
            sck            <= !sck; // marks half a period of sck cycle
        end
        else
            sck_switch_cnt <= sck_switch_cnt + 1'b1;
    end
    else if (!chip_sel & SCK_to_CS) begin
        sck_switch_cnt <= 6'd0;
        sck            <= (sck_pol) ? 1'd1 : 1'd0; // idle sck polarity?
    end
    else
        sck_switch_cnt <= 6'd0;
end

assign SCLK_o = sck;

////////////////////
// EDGE DETECTION //

always @ (posedge GCLK) begin
    if (RST) begin
        d_ff <= 0;
    end
    else
        d_ff <= start_i;
end

assign trans_start = start_i & !d_ff;

// The rest of the design "knows" exactly when the clock
// is going to switch its polarity one GCLK edge prior.
// New mosi data bit is set with sck edge and miso data
// bit is collected, according to sck phase

assign pos_sck = !sck & (sck_switch_cnt >= sck_switch) & !CS_to_SCK;
assign neg_sck = sck & (sck_switch_cnt >= sck_switch) & !CS_to_SCK;

///////////////////////////////
// CStoSCK & SCKtoCS TIMINGS //

// CStoSCK - additional delay between the newly activated CS
// and the first SCK polarity switch
// SCKtoCS - additional delay between the last SCK polarity switch
// in a (now finished) frame and the CS going idle  

always @ (posedge GCLK) begin
    if (RST) begin
        CSnSCK_cnt    <= 8'd0;
        CS_to_SCK     <= 1'b0;
        SCK_to_CS     <= 1'b0;
    end
    //
    else if (chip_sel & trans_start & IFG_done) // nasty cond
        CS_to_SCK     <= 1'b1;
    else if (trans_done)
        SCK_to_CS     <= 1'b1;
    //
    else if (CS_to_SCK & (CSnSCK_cnt == t_CS_SCK_i)) begin
        CSnSCK_cnt    <= 8'd0;
        CS_to_SCK     <= 1'b0;
    end
    else if (SCK_to_CS & (CSnSCK_cnt == t_SCK_CS_i)) begin
        CSnSCK_cnt    <= 8'd0;
        SCK_to_CS     <= 1'b0;
    end
    else if (CS_to_SCK | SCK_to_CS)
        CSnSCK_cnt    <= CSnSCK_cnt + 1'b1;
end

////////////////
// IFG TIMING //

// IFG (INTERFRAME GAP) - the minimum delay between two independent
// transmission instances (frames) 

always @ (posedge GCLK) begin
    if (RST) begin
        IFG_cnt    <= 8'd0;
        IFG_done   <= 1'b0;
    end
    else if (trans_start & IFG_done) begin
        IFG_cnt    <= 8'd0;
        IFG_done   <= 1'b0;
    end
    else if (!IFG_done & (IFG_cnt == t_IFG_i))
        IFG_done   <= 1'b1;
    else if (!IFG_done & (state == IDLE))
        IFG_cnt    <= IFG_cnt + 1'b1;
end

////////////////////////////////////
// SPI TRANSMISSION STATE MACHINE //

always @ (posedge GCLK) begin
    if (RST) begin
        busy_o      <= 1'b0; // ready for transmission

        mosi      <= 1'b0;
        chip_sel  <= 1'b1;

        miso_data_o <= 32'd0;

        miso_buff <= 32'd0;
        mosi_buff <= 32'd0;

        bit_cnt   <= 5'd31;

        state     <= IDLE;
    end
    else begin
        case (state)
            IDLE: begin
                busy_o      <= 1'b0; // ready
                mosi      <= 1'b0;
                chip_sel  <= 1'b1;

                miso_buff <= 32'd0;
                mosi_buff <= 32'd0;

                bit_cnt   <= 5'd31;
                //
                if (trans_start & IFG_done) begin // start signal and the minimum IFG time passed
                    busy_o      <= 1'b1; // TRULY busy
                    chip_sel  <= 1'b0; // start SCK to CS timer
                    mosi_buff <= mosi_data_i;
                    //
                    state <= TRANSACTION;
                    // state <= START;
                end
                else
                    state <= IDLE;
            end
            TRANSACTION: begin
                case (sck_pol) 
                    0: begin // subtract from bit_cnt upon detection of a falling SCK edge
                        // (SCK IDLE '0')    
                        case (sck_pha)
                            0: begin // send on rising edge/pick up on falling edge
                                if (trans_done) begin
                                    miso_data_o          <= miso_buff;
                                    bit_cnt            <= 5'd31;
                                    state              <= FINISH;
                                end
                                else if (pos_sck) begin
                                    mosi               <= mosi_buff[bit_cnt];
                                end
                                else if (neg_sck) begin
                                    miso_buff[bit_cnt] <= MISO_i;
                                    bit_cnt            <= bit_cnt - 1'b1;
                                end
                            end
                            1: begin // send on falling edge/pick up on rising edge
                                if (trans_done) begin
                                    miso_data_o          <= miso_buff;
                                    bit_cnt            <= 5'd31;
                                    state              <= FINISH;
                                end
                                else if (pos_sck) begin
                                    miso_buff[bit_cnt] <= MISO_i;
                                end
                                else if (neg_sck) begin
                                    mosi               <= mosi_buff[bit_cnt];
                                    bit_cnt            <= bit_cnt - 1'b1;
                                end
                            end
                        endcase
                    end
                    1: begin // subtract from bit_cnt upon detection of a rising SCK edge
                        // (SCK IDLE '1')
                        case (sck_pha)
                            0: begin // send on rising edge/pick up on falling edge
                                if (trans_done) begin
                                    miso_data_o          <= miso_buff;
                                    bit_cnt            <= 5'd31;
                                    state              <= FINISH;
                                end
                                else if (pos_sck) begin
                                    mosi               <= mosi_buff[bit_cnt];
                                    bit_cnt            <= bit_cnt - 1'b1;
                                end
                                else if (neg_sck) begin
                                    miso_buff[bit_cnt] <= MISO_i;
                                end
                            end
                            1: begin // send on falling edge/pick up on rising edge
                                if (trans_done) begin
                                    miso_data_o          <= miso_buff;
                                    bit_cnt            <= 5'd31;
                                    state              <= FINISH;
                                end
                                else if (pos_sck) begin
                                    miso_buff[bit_cnt] <= MISO_i;
                                    bit_cnt            <= bit_cnt - 1'b1;
                                end
                                else if (neg_sck) begin
                                    mosi               <= mosi_buff[bit_cnt];
                                end
                            end
                        endcase
                    end
                endcase
            end
            FINISH: begin
                if (!SCK_to_CS)
                    state <= IDLE;
                else
                    state <= FINISH;
            end
            default: begin
                busy_o      <= 1'b0;
                mosi      <= 1'b0;
                chip_sel  <= 1'b1;

                miso_buff <= 32'd0;
                mosi_buff <= 32'd0;

                bit_cnt   <= 5'd31;
                //
                if (trans_start & IFG_done) begin
                    busy_o      <= 1'b1; // TRULY busy
                    chip_sel  <= 1'b0; // start SCK
                    mosi_buff <= mosi_data_i;
                    //
                    state <= TRANSACTION;
                    // state <= START;
                end
                else
                    state <= IDLE;
            end
        endcase
    end
end

assign trans_done = (bit_cnt == chosen_word_len);

assign MOSI_o = mosi;
assign CS_o = chip_sel;

endmodule
