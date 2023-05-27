import uvm_pkg::*;
`include "uvm_macros.svh"

`include "SPI_master.sv"
`include "SPI_regs.sv"
`include "SPI_top.sv"

`include "dio_interface.sv"
`include "spi_interface.sv"

import top_pkg::*;

module tb_top;

    dio_interface d_itf();
    spi_interface s_itf();

    SPI_top DUT(
        .GCLK          (d_itf.GCLK),
        .RST           (d_itf.RST),
        .start_in      (d_itf.start_in),
        .busy_out      (d_itf.busy_out),
        .spi_mode_in   (d_itf.spi_mode_in),
        .sck_speed_in  (d_itf.sck_speed_in),
        .word_len_in   (d_itf.word_len_in),
        .IFG_in        (d_itf.IFG_in),
        .CS_SCK_in     (d_itf.CS_SCK_in),
        .SCK_CS_in     (d_itf.SCK_CS_in),
        .mosi_data_in  (d_itf.mosi_data_in),
        .miso_data_out (d_itf.miso_data_out),
        //
        .MISO_in       (s_itf.MISO_in),
        .MOSI_out      (s_itf.MOSI_out),
        .SCLK_out      (s_itf.SCLK_out),
        .CS_out        (s_itf.CS_out)
    );

//    HOW TO SET A VALUE FOR AN OUTPUT OF A CLOCKING BLOCK SIGNAL IN INTERFACE NOW

//    initial begin
//        itf.cb.EXAMPLE = 0; 
//    end

    initial begin
        uvm_config_db#(virtual dio_interface)::set(null, "base_test.env*", "d_vif", d_itf);
        uvm_config_db#(virtual spi_interface)::set(null, "base_test.env*", "s_vif", d_itf);

        run_test("test_1");
    end

endmodule : tb_top
