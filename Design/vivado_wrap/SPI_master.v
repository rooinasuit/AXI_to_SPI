`timescale 1ns/1ps

module SPI_master (
    ////////////////////
    // GLOBAL SIGNALS //
    input GCLK, // global clock (say 100MHz)
    input NRST,  // asynchronous reset

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
    input [7:0] IFG_i,    // minimum interframe gap (parameter)
    input [7:0] CS_SCK_i, // the time between the switch of CS polarity and the response in switch of SCK polarity (parameter)
    input [7:0] SCK_CS_i,

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
localparam INTERFRAME  = 1;
localparam PRE_TRANS   = 2;
localparam TRANSACTION = 3;
localparam FINISH      = 4;

reg [2:0]  state;

reg        mosi;
reg        chip_sel;

reg [31:0] miso_buff;
reg [31:0] mosi_buff;

reg [4:0]  bit_cnt;
reg        last_bit;

wire trans_done;

////////////////////////
// SPI MODE SELECTION //

// 0: SCK idle low,  sample on rising SCK,  toggle on falling SCK
// 1: SCK idle low,  sample on falling SCK, toggle on rising SCK
// 2: SCK idle high, sample on rising SCK,  toggle on falling SCK
// 3: SCK idle high, sample on falling SCK, toggle on rising SCK

assign sck_pol = spi_mode_i[1];
assign sck_pha = spi_mode_i[0];

/////////////////////////
// SCK SPEED SELECTION //

// sck_switch states the value at which to change clock polarity (double the clock period)

always @ (posedge GCLK) begin
    if (!NRST) begin
        sck_switch <= 6'd0;
    end
    else begin
        case (sck_speed_i)
            0: sck_switch  <= 6'd63; // [1/128] GCLK
            1: sck_switch  <= 6'd31; // [1/64] GCLK
            2: sck_switch  <= 6'd15; // [1/32] GCLK
            3: sck_switch  <= 6'd7;  // [1/16] GCLK
            default: begin
                sck_switch  <= 6'd63; // [1/128] GCLK
            end
        endcase
    end
end

///////////////////////////
// WORD LENGTH SELECTION //

// Rx/Tx counter will decrement with each sent/received bit, hence [31 - word_len]

always @ (posedge GCLK) begin
    if (!NRST)
        chosen_word_len <= 5'd31;
    else begin
        case (word_len_i)
            0: chosen_word_len <= 5'd0; // 32-bit word
            1: chosen_word_len <= 5'd16; // 16-bit word
            2: chosen_word_len <= 5'd24; // 8-bit word
            3: chosen_word_len <= 5'd28; // 4-bit word
            default: begin
                chosen_word_len <= 5'd0; // 32-bit word
            end
        endcase
    end
end

///////////////////
// SCK GENERATOR //

always @ (posedge GCLK) begin
    if (!NRST) begin
        sck_switch_cnt <= 6'd0;
        // sck            <= (sck_pol) ? 1'd1 : 1'd0; // idle sck polarity?
        sck            <= 1'd0;
    end
    else if (state == PRE_TRANS) begin
        if (CSnSCK_cnt >= CS_SCK_i) begin
            sck_switch_cnt <= 6'd0;
            sck            <= !sck; // marks half a period of sck cycle
        end
    end
    else if (state == TRANSACTION) begin
        if (sck_switch_cnt >= sck_switch) begin
            sck_switch_cnt <= 6'd0;
            sck            <= !sck; // marks half a period of sck cycle
        end
        else begin
            sck_switch_cnt <= sck_switch_cnt + 1'b1;
        end
    end
    else if (!chip_sel) begin
        sck_switch_cnt <= 6'd0;
        sck            <= (sck_pol) ? 1'd1 : 1'd0; // idle sck polarity?
    end
    else begin
        sck_switch_cnt <= 6'd0;
        sck            <= (sck_pol) ? 1'd1 : 1'd0;
    end
end

assign SCLK_o = sck;

////////////////////
// EDGE DETECTION //

always @ (posedge GCLK) begin
    if (!NRST) begin
        d_ff <= 0;
    end
    else begin
        d_ff <= start_i;
    end
end

assign trans_start = start_i & !d_ff;

// The rest of the design "knows" exactly when the clock
// is going to switch its polarity one GCLK edge prior.
// New mosi data bit is set with sck edge and miso data
// bit is collected, according to sck phase

assign pos_sck = !sck & (sck_switch_cnt >= sck_switch);
assign neg_sck = sck & (sck_switch_cnt >= sck_switch);

///////////////////////////////
// CStoSCK & SCKtoCS TIMINGS //

// CStoSCK - additional delay between the newly activated CS
// and the first SCK polarity switch
// SCKtoCS - additional delay between the last SCK polarity switch
// in a (now finished) frame and the CS going idle

always @ (posedge GCLK) begin
    if (!NRST) begin
        CSnSCK_cnt    <= 8'd0;
        CS_to_SCK     <= 1'b0;
        SCK_to_CS     <= 1'b0;
    end
    //
    else if ((IFG_done & (state == INTERFRAME))) begin
        CS_to_SCK     <= 1'b1;
        CSnSCK_cnt    <= 8'd1;
    end
    else if (trans_done) begin
        case (sck_pol)
        0: begin
            if((!sck_pha & neg_sck) || (sck_pha & !sck)) begin
                SCK_to_CS <= 1'b1;
            end
            else begin
                SCK_to_CS <= SCK_to_CS;
            end
            // SCK_to_CS  <= (!sck_pha & neg_sck) ? 1'b1 : (sck_pha & !sck) ? 1'b1 : SCK_to_CS;
            CSnSCK_cnt    <= 8'd1;
        end
        1: begin
            if((!sck_pha & sck) || (sck_pha & pos_sck)) begin
                SCK_to_CS <= 1'b1;
            end
            else begin
                SCK_to_CS <= SCK_to_CS;
            end
            // SCK_to_CS  <= (!sck_pha & sck) ? 1'b1 : (sck_pha & pos_sck) ? 1'b1 : SCK_to_CS;
            CSnSCK_cnt    <= 8'd1;
        end
        default: begin
            CSnSCK_cnt    <= 8'd0;
            CS_to_SCK     <= 1'b0;
            SCK_to_CS     <= 1'b0;
        end
        endcase
    end
    else if (CS_to_SCK & (CSnSCK_cnt >= CS_SCK_i)) begin
        CSnSCK_cnt    <= 8'd0;
        CS_to_SCK     <= 1'b0;
    end
    else if (SCK_to_CS & (CSnSCK_cnt >= SCK_CS_i)) begin
        CSnSCK_cnt    <= 8'd0;
        SCK_to_CS     <= 1'b0;
    end
    else if (CS_to_SCK | SCK_to_CS) begin
        CSnSCK_cnt    <= CSnSCK_cnt + 1'b1;
    end
end

////////////////
// IFG TIMING //

// IFG (INTERFRAME GAP) - the minimum delay between two independent
// transmission instances (frames) 

always @ (posedge GCLK) begin
    if (!NRST) begin
        IFG_cnt    <= 8'd0;
        IFG_done   <= 1'b0;
    end
    else if (state == PRE_TRANS) begin
        IFG_cnt    <= 8'd0;
        IFG_done   <= 1'b0;
    end
    else if (!IFG_done & (IFG_cnt == IFG_i)) begin
        IFG_done   <= 1'b1;
    end
    else if (!IFG_done & (state == IDLE || state == INTERFRAME)) begin
        IFG_cnt    <= IFG_cnt + 1'b1;
    end
end

////////////////////////////////////
// SPI TRANSMISSION STATE MACHINE //

always @ (posedge GCLK) begin
    if (!NRST) begin
        busy_o      <= 1'b0; // ready for transmission

        mosi      <= 1'b0;
        chip_sel  <= 1'b1;

        miso_data_o <= 32'd0;

        miso_buff <= 32'd0;
        mosi_buff <= 32'd0;

        bit_cnt   <= 5'd31;
        last_bit  <= 1'b0;

        state     <= IDLE;
    end
    else begin
        case (state)
            IDLE: begin
                busy_o    <= 1'b0; // ready
                mosi      <= 1'b0;
                chip_sel  <= 1'b1;

                miso_buff <= 32'd0;
                mosi_buff <= 32'd0;

                bit_cnt   <= 5'd31;
                last_bit  <= 1'b0;
                //
                if (trans_start) begin // start signal and the minimum IFG time passed
                    mosi_buff <= mosi_data_i;
                    //
                    state <= INTERFRAME;
                end
                else begin
                    state <= IDLE;
                end
            end
            INTERFRAME: begin
                if (IFG_done) begin
                    busy_o   <= 1'b1; // TRULY busy
                    chip_sel <= 1'b0; // start SCK to CS timer
                    state    <= PRE_TRANS;
                end
                else begin
                    state <= INTERFRAME;
                end
            end
            PRE_TRANS: begin
                if (CSnSCK_cnt >= CS_SCK_i) begin
                    case (sck_pol)
                    0: begin
                        if (!sck_pha) begin
                            miso_buff[bit_cnt-chosen_word_len] <= MISO_i;
                            bit_cnt <= bit_cnt - 1'b1;
                            state <= TRANSACTION;
                        end
                        else begin
                            mosi    <= mosi_buff[bit_cnt-chosen_word_len];
                            state <= TRANSACTION;
                        end
                    end
                    1: begin
                        if (!sck_pha) begin
                            mosi    <= mosi_buff[bit_cnt-chosen_word_len];
                            state <= TRANSACTION;
                        end
                        else begin
                            miso_buff[bit_cnt-chosen_word_len] <= MISO_i;
                            bit_cnt <= bit_cnt - 1'b1;
                            state <= TRANSACTION;
                        end
                    end
                    default: begin
                        state <= IDLE;
                    end
                    endcase
                end
                else begin
                    case (sck_pol)
                    0: begin
                        if (!sck_pha) begin
                            mosi <= mosi_buff[bit_cnt-chosen_word_len];
                            state <= PRE_TRANS;
                        end
                    end
                    1: begin
                        if (sck_pha) begin
                            mosi <= mosi_buff[bit_cnt-chosen_word_len];
                            state <= PRE_TRANS;
                        end
                    end
                    default: begin
                        state <= IDLE;
                    end
                    endcase
                end
            end
            TRANSACTION: begin
                case (sck_pol)
                    0: begin // subtract from bit_cnt upon detection of a falling SCK edge
                        // (SCK IDLE '0')
                        case (sck_pha)
                            0: begin // pick up on rising edge/send on falling edge
                                if (trans_done) begin
                                    if (pos_sck) begin
                                        miso_buff[bit_cnt-chosen_word_len] <= MISO_i;
                                    end
                                    else if (neg_sck) begin
                                        state    <= (last_bit) ? FINISH : TRANSACTION;
                                        mosi     <= mosi_buff[bit_cnt-chosen_word_len];
                                        last_bit <= 1'b1;
                                    end
                                end
                                else if (pos_sck) begin
                                    miso_buff[bit_cnt-chosen_word_len] <= MISO_i;
                                    bit_cnt <= bit_cnt - 1'b1;
                                end
                                else if (neg_sck) begin
                                    mosi    <= mosi_buff[bit_cnt-chosen_word_len];
                                end
                            end
                            1: begin // send on rising edge/pick up on falling edge
                                if (trans_done) begin
                                    if (pos_sck) begin
                                        mosi    <= mosi_buff[bit_cnt-chosen_word_len];
                                    end
                                    else if (neg_sck) begin
                                        miso_buff[bit_cnt-chosen_word_len] <= MISO_i;
                                        state   <= FINISH;
                                    end
                                end
                                else if (pos_sck) begin
                                    mosi    <= mosi_buff[bit_cnt-chosen_word_len];
                                end
                                else if (neg_sck) begin
                                    miso_buff[bit_cnt-chosen_word_len] <= MISO_i;
                                    bit_cnt <= bit_cnt - 1'b1;
                                end
                            end
                            default: begin
                                state <= IDLE;
                            end
                        endcase
                    end
                    1: begin // subtract from bit_cnt upon detection of a rising SCK edge
                        // (SCK IDLE '1')
                        case (sck_pha)
                            0: begin // send on falling edge/pick up on rising edge
                                if (trans_done) begin
                                    if (neg_sck) begin
                                        mosi    <= mosi_buff[bit_cnt-chosen_word_len];
                                    end
                                    else if (pos_sck) begin
                                        miso_buff[bit_cnt-chosen_word_len] <= MISO_i;
                                        state   <= FINISH;
                                    end
                                end
                                else if (neg_sck) begin
                                    mosi    <= mosi_buff[bit_cnt-chosen_word_len];
                                end
                                else if (pos_sck) begin
                                    miso_buff[bit_cnt-chosen_word_len] <= MISO_i;
                                    bit_cnt <= bit_cnt - 1'b1;
                                end
                            end
                            1: begin // pick up on falling edge/send on rising edge
                                if (trans_done) begin
                                    if (neg_sck) begin
                                        miso_buff[bit_cnt-chosen_word_len] <= MISO_i;
                                    end
                                    else if (pos_sck) begin
                                        state    <= (last_bit) ? FINISH : TRANSACTION;
                                        mosi    <= mosi_buff[bit_cnt-chosen_word_len];
                                        last_bit <= 1'b1;
                                    end
                                end
                                else if (neg_sck) begin
                                    miso_buff[bit_cnt-chosen_word_len] <= MISO_i;
                                    bit_cnt <= bit_cnt - 1'b1;
                                end
                                else if (pos_sck) begin
                                    mosi    <= mosi_buff[bit_cnt-chosen_word_len];
                                end
                            end
                            default: begin
                                state <= IDLE;
                            end
                        endcase
                    end
                    default: begin
                        state <= IDLE;
                    end
                endcase
            end
            FINISH: begin
                if (CSnSCK_cnt >= SCK_CS_i) begin
                    busy_o     <= 1'b0;
                    chip_sel   <= 1'b1;
                    miso_data_o <= miso_buff;
                    state       <= IDLE;
                end
                else begin
                    bit_cnt     <= 5'd31;
                    state       <= FINISH;
                end
            end
            default: begin
                busy_o     <= 1'b0;
                mosi       <= 1'b0;
                chip_sel   <= 1'b1;

                miso_buff  <= 32'd0;
                mosi_buff  <= 32'd0;

                bit_cnt    <= 5'd31;
                last_bit   <= 1'b0;
                //
                if (trans_start) begin
                    mosi_buff <= mosi_data_i;
                    //
                    state <= INTERFRAME;
                end
                else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign trans_done = ((bit_cnt - chosen_word_len) == 0);

assign MOSI_o = mosi;
assign CS_o = chip_sel;

endmodule
