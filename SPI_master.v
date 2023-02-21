`timescale 1ns/1ps

module SPI_master (
    ////////////////////
    // GLOBAL SIGNALS //
    input GCLK, // global clock (say 100MHz)
    input RST,  // asynchronous reset

    /////////////////////
    // CONFIG SIGNALS  //
    input [1:0] spi_mode,  // one of 4 modes [SCK polarity, SCK phase, which SCK edge for picking up and which for shifting data] - mode 0 by default {CHECK}
    input [1:0] sck_speed, // [1/128, 1/64, 1/32, 1/16] of GCLK - 1/128 by default {CHECK}
    input [1:0] word_len,  // length of a single word directed on/sampled from the bus - [32, 16, 8, 4] bits - 32 bits by default {CHECK}

    /////////////////////
    // CONTROL SIGNALS //
    input start, // transmission start flag [1 - start | 0 - stop]

    ////////////////////
    // STATUS SIGNALS //
    input      [7:0] t_IFG,   // minimum interframe gap (parameter)
    input      [7:0] t_CS_SCK, // the time between the switch of CS polarity and the response in switch of SCK polarity (parameter)
    input      [7:0] t_SCK_CS,
    //
    output reg       busy,      // busy flag [1 - busy | 0 - ready]

    //////////////
    // SPI DATA //
    input      [31:0] mosi_data, // data frame to send via MOSI (8/16/32 bits and the remaining are filled with zeroes)
    //
    output reg [31:0] miso_data, // data frame received via MISO (8/16/32 bits and the remaining are filled with zeroes)

    /////////////
    // SPI BUS //
    input  i_MISO,
    //
    output o_MOSI,
    output o_SCK,
    output o_CS
);

reg sck_pol; // sck polarity - active high [0] or active low [1]
reg sck_pha; // sck phase - send on rising edge/pick up on falling edge [0] or send on falling edge/pick up on rising edge [1]
//
reg [5:0] sck_switch;
reg [5:0] sck_switch_cnt;
reg       sck;

reg  sck_ff;
wire pos_sck;
wire neg_sck;

reg  cs_ff;
wire pos_cs;
wire neg_cs;
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
localparam START       = 1;
localparam TRANSACTION = 2;
localparam FINISH      = 3;

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

always @ (posedge GCLK or posedge RST) begin
    // if (RST) begin
    //     sck_pol <= 1'b0;
    //     sck_pha <= 1'b0;
    // end
    // else begin
        case (spi_mode)
            0: begin
                sck_pol <= 1'b0;
                sck_pha <= 1'b0;
            end
            1: begin
                sck_pol <= 1'b0;
                sck_pha <= 1'b1;
            end
            2: begin
                sck_pol <= 1'b1;
                sck_pha <= 1'b0;
            end
            3: begin
                sck_pol <= 1'b1;
                sck_pha <= 1'b1;
            end
        endcase
    // end
end

/////////////////////////
// SCK SPEED SELECTION //

// sck_switch states the value at which to change clock polarity (double the clock period)

always @ (posedge GCLK or posedge RST) begin
    if (RST) begin
        sck_switch <= 6'd63;
    end
    else begin
        case (sck_speed)
            0: sck_switch  <= 6'd63; // [1/128]
            1: sck_switch  <= 6'd31; // [1/64]
            2: sck_switch  <= 6'd15; // [1/32]
            3: sck_switch  <= 6'd7;  // [1/16]
        endcase
    end
end

///////////////////////////
// WORD LENGTH SELECTION //

// Rx/Tx counter will decrement with each sent/received bit, hence [31 - word_len]

always @ (posedge GCLK or posedge RST) begin
    if (RST)
        chosen_word_len <= 5'd0;
    else begin
        case (word_len)
            0: chosen_word_len <= 5'd0; // 32-bit word
            1: chosen_word_len <= 5'd15; // 16-bit word
            2: chosen_word_len <= 5'd23; // 8-bit word
            3: chosen_word_len <= 5'd27; // 4-bit word
        endcase
    end
end

///////////////////
// SCK GENERATOR //

always @ (posedge GCLK or posedge RST) begin
    if (RST) begin
        sck_switch_cnt <= 6'd0;
        sck            <= (sck_pol) ? 1'd1 : 1'd0;
    end
    else if (!chip_sel & !SCK_to_CS) begin
        if (sck_switch_cnt >= sck_switch & !CS_to_SCK) begin
            sck_switch_cnt <= 6'd0;
            sck            <= !sck;
        end
        else
            sck_switch_cnt <= sck_switch_cnt + 1'b1;
    end
    else if (!chip_sel & SCK_to_CS) begin
        sck_switch_cnt <= 6'd0;
        sck            <= (sck_pol) ? 1'd1 : 1'd0;
    end
    else
        sck_switch_cnt <= 6'd0;
end

assign o_SCK = sck;

////////////////////
// EDGE DETECTION //

always @ (posedge GCLK or posedge RST) begin
    if (RST) begin
        sck_ff <= 1'b0;
        cs_ff  <= 1'b0;
    end
    else begin
        sck_ff <= sck;
        cs_ff  <= chip_sel;
    end
end

assign pos_sck = sck & (!sck_ff);
assign neg_sck = (!sck) & sck_ff;

assign pos_cs = chip_sel & (!cs_ff);
assign neg_cs = (!chip_sel) & cs_ff;

///////////////////////////////
// CStoSCK & SCKtoCS TIMINGS //

always @ (posedge GCLK or posedge RST) begin
    if (RST) begin
        CSnSCK_cnt    <= 8'd0;
        CS_to_SCK     <= 1'b0;
        SCK_to_CS     <= 1'b0;
    end
    //
    else if (neg_cs)
        CS_to_SCK     <= 1'b1;
    else if (trans_done)
        SCK_to_CS     <= 1'b1;
    //
    else if (CS_to_SCK & (CSnSCK_cnt == t_CS_SCK)) begin
        CSnSCK_cnt    <= 8'd0;
        CS_to_SCK     <= 1'b0;
    end
    else if (SCK_to_CS & (CSnSCK_cnt == t_SCK_CS)) begin
        CSnSCK_cnt    <= 8'd0;
        SCK_to_CS     <= 1'b0;
    end
    else if (CS_to_SCK | SCK_to_CS)
        CSnSCK_cnt    <= CSnSCK_cnt + 1'b1;
end

////////////////
// IFG TIMING //

always @ (posedge GCLK or posedge RST) begin
    if (RST) begin
        IFG_cnt    <= 8'd0;
        IFG_done   <= 1'b0;
    end
    else if (state == START) begin
        IFG_cnt    <= 8'd0;
        IFG_done   <= 1'b0;
    end
    else if (!IFG_done & (IFG_cnt == t_IFG))
        IFG_done   <= 1'b1;
    else if (!IFG_done & (state == IDLE))
        IFG_cnt    <= IFG_cnt + 1'b1;
end

////////////////////////////////////
// SPI TRANSMISSION STATE MACHINE //

always @ (posedge GCLK or posedge RST) begin
    if (RST) begin
        busy      <= 1'b0; // ready for transmission

        mosi      <= 1'b0;
        chip_sel  <= 1'b1;

        miso_data <= 32'd0;

        miso_buff <= 32'd0;
        mosi_buff <= 32'd0;

        bit_cnt   <= 5'd31;

        state     <= IDLE;
    end
    else begin
        case (state)
            IDLE: begin
                busy      <= 1'b0;
                mosi      <= 1'b0;
                chip_sel  <= 1'b1;

                miso_buff <= 32'd0;
                mosi_buff <= 32'd0;

                bit_cnt   <= 5'd31;
                //
                if (start & IFG_done)
                    state <= START;
                else
                    state <= IDLE;
            end
            START: begin
                busy      <= 1'b1; // TRULY busy/?
                mosi_buff <= mosi_data;
                chip_sel  <= 1'b0; // start SCK
                //
                state <= TRANSACTION;
            end
            TRANSACTION: begin
                case (sck_pol)
                    0: begin // subtract from bit_cnt upon detection of a falling SCK edge
                        case (sck_pha)
                            0: begin // send on rising edge/pick up on falling edge
                                if (trans_done) begin
                                    miso_data          <= miso_buff;
                                    state              <= FINISH;
                                end
                                else if (pos_sck) begin
                                    mosi               <= mosi_buff[bit_cnt];
                                end
                                else if (neg_sck) begin
                                    miso_buff[bit_cnt] <= i_MISO;
                                    bit_cnt            <= bit_cnt - 1'b1;
                                end
                            end
                            1: begin // send on falling edge/pick up on rising edge
                                if (trans_done) begin
                                    miso_data          <= miso_buff;
                                    state              <= FINISH;
                                end
                                else if (pos_sck) begin
                                    miso_buff[bit_cnt] <= i_MISO;
                                end
                                else if (neg_sck) begin
                                    mosi               <= mosi_buff[bit_cnt];
                                    bit_cnt            <= bit_cnt - 1'b1;
                                end
                            end
                        endcase
                    end
                    1: begin // subtract from bit_cnt upon detection of a rising SCK edge
                        case (sck_pha)
                            0: begin // send on rising edge/pick up on falling edge
                                if (trans_done) begin
                                    miso_data          <= miso_buff;
                                    state              <= FINISH;
                                end
                                else if (pos_sck) begin
                                    mosi               <= mosi_buff[bit_cnt];
                                    bit_cnt            <= bit_cnt - 1'b1;
                                end
                                else if (neg_sck) begin
                                    miso_buff[bit_cnt] <= i_MISO;
                                end
                            end
                            1: begin // send on falling edge/pick up on rising edge
                                if (trans_done) begin
                                    miso_data          <= miso_buff;
                                    state              <= FINISH;
                                end
                                else if (pos_sck) begin
                                    miso_buff[bit_cnt] <= i_MISO;
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
                bit_cnt   <= 5'd31;
                if (!SCK_to_CS)
                    state <= IDLE;
                else
                    state <= FINISH;
            end
        endcase
    end
end

assign trans_done = (bit_cnt == chosen_word_len);

assign o_MOSI = mosi;
assign o_CS = chip_sel;

endmodule
