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

wire trans_start_v;
reg  d_ff_v;

wire sck_pol_v; // sck polarity - active high [0] or active low [1]
wire sck_pha_v; // sck phase - send on rising edge/pick up on falling edge [0] or send on falling edge/pick up on rising edge [1]
//
reg [5:0] sck_switch_v;
reg [5:0] sck_switch_cnt_v;
reg       sck_v;
//
wire pos_sck_v;
wire neg_sck_v;
//
reg       CS_to_SCK_v; // from !CS to the first SCK pulse
reg       SCK_to_CS_v;   // from the last SCK pulse to CS

reg [7:0] CSnSCK_cnt_v;
//
reg       IFG_done_v;
reg [7:0] IFG_cnt_v;
//
reg [4:0] chosen_word_len_v;
//
localparam IDLE        = 0;
localparam INTERFRAME  = 1;
localparam PRE_TRANS   = 2;
localparam TRANSACTION = 3;
localparam FINISH      = 4;

reg [2:0] STATE;

reg        mosi_v;
reg        chip_sel_v;

reg [31:0] miso_buff_v;
reg [31:0] mosi_buff_v;

reg [4:0]  bit_cnt_v;
reg        last_bit_v;

wire trans_done_v;

////////////////////////
// SPI MODE SELECTION //

// 0: SCK idle low,  sample on rising SCK,  toggle on falling SCK
// 1: SCK idle low,  sample on falling SCK, toggle on rising SCK
// 2: SCK idle high, sample on rising SCK,  toggle on falling SCK
// 3: SCK idle high, sample on falling SCK, toggle on rising SCK

assign sck_pol_v = spi_mode_i[1];
assign sck_pha_v = spi_mode_i[0];

/////////////////////////
// SCK SPEED SELECTION //

// sck_switch_v states the value at which to change clock polarity (double the clock period)

always @ (posedge GCLK) begin
    if (!NRST) begin
        sck_switch_v <= 6'd0;
    end
    else begin
        case (sck_speed_i)
            0: sck_switch_v  <= 6'd63; // [1/128] GCLK
            1: sck_switch_v  <= 6'd31; // [1/64] GCLK
            2: sck_switch_v  <= 6'd15; // [1/32] GCLK
            3: sck_switch_v  <= 6'd7;  // [1/16] GCLK
            default: begin
                sck_switch_v  <= 6'd63; // [1/128] GCLK
            end
        endcase
    end
end

///////////////////////////
// WORD LENGTH SELECTION //

// Rx/Tx counter will decrement with each sent/received bit, hence [31 - word_len]

always @ (posedge GCLK) begin
    if (!NRST)
        chosen_word_len_v <= 5'd31;
    else begin
        case (word_len_i)
            0: chosen_word_len_v <= 5'd0; // 32-bit word
            1: chosen_word_len_v <= 5'd16; // 16-bit word
            2: chosen_word_len_v <= 5'd24; // 8-bit word
            3: chosen_word_len_v <= 5'd28; // 4-bit word
            default: begin
                chosen_word_len_v <= 5'd0; // 32-bit word
            end
        endcase
    end
end

///////////////////
// SCK GENERATOR //

always @ (posedge GCLK) begin
    if (!NRST) begin
        sck_switch_cnt_v <= 6'd0;
        // sck_v            <= (sck_pol_v) ? 1'd1 : 1'd0; // idle sck polarity?
        sck_v            <= 1'd0;
    end
    else if (STATE == PRE_TRANS) begin
        if (CSnSCK_cnt_v >= CS_SCK_i) begin
            sck_switch_cnt_v <= 6'd0;
            sck_v            <= !sck_v; // marks half a period of sck_v cycle
        end
    end
    else if (STATE == TRANSACTION) begin
        if (sck_switch_cnt_v >= sck_switch_v) begin
            sck_switch_cnt_v <= 6'd0;
            sck_v            <= !sck_v; // marks half a period of sck_v cycle
        end
        else begin
            sck_switch_cnt_v <= sck_switch_cnt_v + 1'b1;
        end
    end
    else if (!chip_sel_v) begin
        sck_switch_cnt_v <= 6'd0;
        sck_v            <= (sck_pol_v) ? 1'd1 : 1'd0; // idle sck_v polarity?
    end
    else begin
        sck_switch_cnt_v <= 6'd0;
        sck_v            <= (sck_pol_v) ? 1'd1 : 1'd0;
    end
end

assign SCLK_o = sck_v;

////////////////////
// EDGE DETECTION //

always @ (posedge GCLK) begin
    if (!NRST) begin
        d_ff_v <= 0;
    end
    else begin
        d_ff_v <= start_i;
    end
end

assign trans_start_v = start_i & !d_ff_v;

// The rest of the design "knows" exactly when the clock
// is going to switch its polarity one GCLK edge prior.
// New mosi data bit is set with sck_v edge and miso data
// bit is collected, according to sck_v phase

assign pos_sck_v = !sck_v & (sck_switch_cnt_v >= sck_switch_v);
assign neg_sck_v = sck_v & (sck_switch_cnt_v >= sck_switch_v);

///////////////////////////////
// CStoSCK & SCKtoCS TIMINGS //

// CStoSCK - additional delay between the newly activated CS
// and the first SCK polarity switch
// SCKtoCS - additional delay between the last SCK polarity switch
// in a (now finished) frame and the CS going idle

always @ (posedge GCLK) begin
    if (!NRST) begin
        CSnSCK_cnt_v    <= 8'd0;
        CS_to_SCK_v     <= 1'b0;
        SCK_to_CS_v     <= 1'b0;
    end
    //
    else if ((IFG_done_v & (STATE == INTERFRAME))) begin
        CS_to_SCK_v     <= 1'b1;
        CSnSCK_cnt_v    <= 8'd1;
    end
    else if (trans_done_v) begin
        case (sck_pol_v)
        0: begin
            if((!sck_pha_v & neg_sck_v) || (sck_pha_v & !sck_v)) begin
                SCK_to_CS_v <= 1'b1;
            end
            else begin
                SCK_to_CS_v <= SCK_to_CS_v;
            end
            // SCK_to_CS_v  <= (!sck_pha_v & neg_sck_v) ? 1'b1 : (sck_pha_v & !sck) ? 1'b1 : SCK_to_CS_v;
            CSnSCK_cnt_v    <= 8'd1;
        end
        1: begin
            if((!sck_pha_v & sck_v) || (sck_pha_v & pos_sck_v)) begin
                SCK_to_CS_v <= 1'b1;
            end
            else begin
                SCK_to_CS_v <= SCK_to_CS_v;
            end
            // SCK_to_CS_v  <= (!sck_pha_v & sck_v) ? 1'b1 : (sck_pha_v & pos_sck_v) ? 1'b1 : SCK_to_CS_v;
            CSnSCK_cnt_v    <= 8'd1;
        end
        default: begin
            CSnSCK_cnt_v    <= 8'd0;
            CS_to_SCK_v     <= 1'b0;
            SCK_to_CS_v     <= 1'b0;
        end
        endcase
    end
    else if (CS_to_SCK_v & (CSnSCK_cnt_v >= CS_SCK_i)) begin
        CSnSCK_cnt_v    <= 8'd0;
        CS_to_SCK_v     <= 1'b0;
    end
    else if (SCK_to_CS_v & (CSnSCK_cnt_v >= SCK_CS_i)) begin
        CSnSCK_cnt_v    <= 8'd0;
        SCK_to_CS_v     <= 1'b0;
    end
    else if (CS_to_SCK_v | SCK_to_CS_v) begin
        CSnSCK_cnt_v    <= CSnSCK_cnt_v + 1'b1;
    end
end

////////////////
// IFG TIMING //

// IFG (INTERFRAME GAP) - the minimum delay between two independent
// transmission instances (frames) 

always @ (posedge GCLK) begin
    if (!NRST) begin
        IFG_cnt_v    <= 8'd0;
        IFG_done_v   <= 1'b0;
    end
    else if (STATE == PRE_TRANS) begin
        IFG_cnt_v    <= 8'd0;
        IFG_done_v   <= 1'b0;
    end
    else if (!IFG_done_v & (IFG_cnt_v == IFG_i)) begin
        IFG_done_v   <= 1'b1;
    end
    else if (!IFG_done_v & (STATE == IDLE || STATE == INTERFRAME)) begin
        IFG_cnt_v    <= IFG_cnt_v + 1'b1;
    end
end

////////////////////////////////////
// SPI TRANSMISSION STATE MACHINE //

always @ (posedge GCLK) begin
    if (!NRST) begin
        busy_o      <= 1'b0; // ready for transmission

        mosi_v      <= 1'b0;
        chip_sel_v  <= 1'b1;

        miso_data_o <= 32'd0;

        miso_buff_v <= 32'd0;
        mosi_buff_v <= 32'd0;

        bit_cnt_v   <= 5'd31;
        last_bit_v  <= 1'b0;

        STATE     <= IDLE;
    end
    else begin
        case (STATE)
            IDLE: begin
                busy_o    <= 1'b0; // ready
                mosi_v      <= 1'b0;
                chip_sel_v  <= 1'b1;

                miso_buff_v <= 32'd0;
                mosi_buff_v <= 32'd0;

                bit_cnt_v   <= 5'd31;
                last_bit_v  <= 1'b0;
                //
                if (trans_start_v) begin // start signal and the minimum IFG time passed
                    mosi_buff_v <= mosi_data_i;
                    //
                    STATE <= INTERFRAME;
                end
                else begin
                    STATE <= IDLE;
                end
            end
            INTERFRAME: begin
                if (IFG_done_v) begin
                    busy_o   <= 1'b1; // TRULY busy
                    chip_sel_v <= 1'b0; // start SCK to CS timer
                    STATE    <= PRE_TRANS;
                end
                else if (!IFG_done_v) begin
                    STATE <= INTERFRAME;
                end
                else begin
                    STATE <= IDLE;
                end
            end
            PRE_TRANS: begin
                if (CSnSCK_cnt_v >= CS_SCK_i) begin
                    case (sck_pol_v)
                    0: begin
                        if (!sck_pha_v) begin
                            miso_buff_v[bit_cnt_v-chosen_word_len_v] <= MISO_i;
                            bit_cnt_v <= bit_cnt_v - 1'b1;
                            STATE <= TRANSACTION;
                        end
                        else begin
                            mosi_v    <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                            STATE <= TRANSACTION;
                        end
                    end
                    1: begin
                        if (!sck_pha_v) begin
                            mosi_v    <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                            STATE <= TRANSACTION;
                        end
                        else begin
                            miso_buff_v[bit_cnt_v-chosen_word_len_v] <= MISO_i;
                            bit_cnt_v <= bit_cnt_v - 1'b1;
                            STATE <= TRANSACTION;
                        end
                    end
                    default: begin
                        STATE <= IDLE;
                    end
                    endcase
                end
                else begin
                    case (sck_pol_v)
                    0: begin
                        if (!sck_pha_v) begin
                            mosi_v <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                            STATE <= PRE_TRANS;
                        end
                    end
                    1: begin
                        if (sck_pha_v) begin
                            mosi_v <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                            STATE <= PRE_TRANS;
                        end
                    end
                    default: begin
                        STATE <= IDLE;
                    end
                    endcase
                end
            end
            TRANSACTION: begin
                case (sck_pol_v)
                    0: begin // subtract from bit_cnt_v upon detection of a falling SCK edge
                        // (SCK IDLE '0')
                        case (sck_pha_v)
                            0: begin // pick up on rising edge/send on falling edge
                                if (trans_done_v) begin
                                    if (pos_sck_v) begin
                                        miso_buff_v[bit_cnt_v-chosen_word_len_v] <= MISO_i;
                                    end
                                    else if (neg_sck_v) begin
                                        STATE    <= (last_bit_v) ? FINISH : TRANSACTION;
                                        mosi_v     <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                                        last_bit_v <= 1'b1;
                                    end
                                end
                                else if (pos_sck_v) begin
                                    miso_buff_v[bit_cnt_v-chosen_word_len_v] <= MISO_i;
                                    bit_cnt_v <= bit_cnt_v - 1'b1;
                                end
                                else if (neg_sck_v) begin
                                    mosi_v    <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                                end
                            end
                            1: begin // send on rising edge/pick up on falling edge
                                if (trans_done_v) begin
                                    if (pos_sck_v) begin
                                        mosi_v    <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                                    end
                                    else if (neg_sck_v) begin
                                        miso_buff_v[bit_cnt_v-chosen_word_len_v] <= MISO_i;
                                        STATE   <= FINISH;
                                    end
                                end
                                else if (pos_sck_v) begin
                                    mosi_v    <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                                end
                                else if (neg_sck_v) begin
                                    miso_buff_v[bit_cnt_v-chosen_word_len_v] <= MISO_i;
                                    bit_cnt_v <= bit_cnt_v - 1'b1;
                                end
                            end
                            default: begin
                                STATE <= IDLE;
                            end
                        endcase
                    end
                    1: begin // subtract from bit_cnt_v upon detection of a rising SCK edge
                        // (SCK IDLE '1')
                        case (sck_pha_v)
                            0: begin // send on falling edge/pick up on rising edge
                                if (trans_done_v) begin
                                    if (neg_sck_v) begin
                                        mosi_v    <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                                    end
                                    else if (pos_sck_v) begin
                                        miso_buff_v[bit_cnt_v-chosen_word_len_v] <= MISO_i;
                                        STATE   <= FINISH;
                                    end
                                end
                                else if (neg_sck_v) begin
                                    mosi_v    <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                                end
                                else if (pos_sck_v) begin
                                    miso_buff_v[bit_cnt_v-chosen_word_len_v] <= MISO_i;
                                    bit_cnt_v <= bit_cnt_v - 1'b1;
                                end
                            end
                            1: begin // pick up on falling edge/send on rising edge
                                if (trans_done_v) begin
                                    if (neg_sck_v) begin
                                        miso_buff_v[bit_cnt_v-chosen_word_len_v] <= MISO_i;
                                    end
                                    else if (pos_sck_v) begin
                                        STATE    <= (last_bit_v) ? FINISH : TRANSACTION;
                                        mosi_v    <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                                        last_bit_v <= 1'b1;
                                    end
                                end
                                else if (neg_sck_v) begin
                                    miso_buff_v[bit_cnt_v-chosen_word_len_v] <= MISO_i;
                                    bit_cnt_v <= bit_cnt_v - 1'b1;
                                end
                                else if (pos_sck_v) begin
                                    mosi_v    <= mosi_buff_v[bit_cnt_v-chosen_word_len_v];
                                end
                            end
                            default: begin
                                STATE <= IDLE;
                            end
                        endcase
                    end
                    default: begin
                        STATE <= IDLE;
                    end
                endcase
            end
            FINISH: begin
                if (CSnSCK_cnt_v >= SCK_CS_i) begin
                    busy_o     <= 1'b0;
                    chip_sel_v   <= 1'b1;
                    miso_data_o <= miso_buff_v;
                    STATE       <= IDLE;
                end
                else begin
                    bit_cnt_v     <= 5'd31;
                    STATE       <= FINISH;
                end
            end
            default: begin
                busy_o     <= 1'b0;
                mosi_v       <= 1'b0;
                chip_sel_v   <= 1'b1;

                miso_buff_v  <= 32'd0;
                mosi_buff_v  <= 32'd0;

                bit_cnt_v    <= 5'd31;
                last_bit_v   <= 1'b0;
                //
                if (trans_start_v) begin
                    mosi_buff_v <= mosi_data_i;
                    //
                    STATE <= INTERFRAME;
                end
                else begin
                    STATE <= IDLE;
                end
            end
        endcase
    end
end

assign trans_done_v = ((bit_cnt_v - chosen_word_len_v) == 0);

assign MOSI_o = mosi_v;
assign CS_o = chip_sel_v;

endmodule
