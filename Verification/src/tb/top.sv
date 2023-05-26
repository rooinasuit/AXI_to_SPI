`timescale 1ns/1ps

import uvm_pkg::*;

`include "uvm_macros.svh"
`include "SPI_top.sv"
`include "tb_dut_interface.sv"

module tb_top;

    dut_interface itf(); // interface

    SPI_top DUT(
        .GCLK          (itf.GCLK),
        .RST           (itf.RST),
        .start_in      (itf.start_in),
        .busy_out      (itf.busy_out),
        .spi_mode_in   (itf.spi_mode_in),
        .sck_speed_in  (itf.sck_speed_in),
        .word_len_in   (itf.word_len_in),
        .IFG_in        (itf.IFG_in),
        .CS_SCK_in     (itf.CS_SCK_in),
        .SCK_CS_in     (itf.SCK_CS_in),
        .mosi_data_in  (itf.mosi_data_in),
        .miso_data_out (itf.miso_data_out),
        .MISO_in       (itf.MISO_in),
        .MOSI_out      (itf.MOSI_out),
        .SCLK_out      (itf.SCLK_out),
        .CS_out        (itf.CS_out)
    );

//    HOW TO SET A VALUE FOR AN OUTPUT OF A CLOCKING BLOCK SIGNAL IN INTERFACE NOW

//    initial begin
//        itf.cb.EXAMPLE = 0; 
//    end

    initial begin
        uvm_config_db#(virtual dut_interface)::set(null, "*", "vif", itf); // set virtual handle for interface

        run_test("test_1");
    end

endmodule : tb_top
