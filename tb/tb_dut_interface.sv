
interface dut_interface();

    // GLOBAL SIGNALS
    bit GCLK;
    bit RST;

    // requested inputs (DIO)
    bit start_in;
    //
    logic [1:0] spi_mode_in;
    logic [1:0] sck_speed_in;
    logic [1:0] word_len_in;
    //
    logic [7:0] IFG_in;
    logic [7:0] CS_SCK_in;
    logic [7:0] SCK_CS_in;
    //
    logic [31:0] mosi_data_in;

    // requested inputs (SPI)
    bit MISO_in;

    // received outputs (DIO)
    bit busy_out;
    //
    logic [31:0] miso_data_out;

    // received outputs (SPI)
    bit MOSI_out;
    bit SCLK_out;
    bit CS_out;

    ////////////////////
    // CLOCKING LOGIC //

    // int period;
    // bit clk_en;

    // //fork
    //     always#(period/2) begin
    //         wait (clk_en);
    //         while (clk_en) begin
    //             GCLK = !GCLK;
    //         end
    //     end
    // //join_none

    // clocking cb @(posedge GCLK); // the only clocking block in the testbench
    //     default input #1 output #1;
    //     output start_in;

    //     output spi_mode_in;
    //     output sck_speed_in;
    //     output word_len_in;

    //     output IFG_in;
    //     output CS_SCK_in;
    //     output SCK_CS_in;

    //     output mosi_data_in;

    //     input busy_out;
    //     input miso_data_out;

    //     input MOSI;
    //     input SCK;
    //     input CS;
    // endclocking : cb

//    modport D_PORT(clocking cb, input GCLK, RST);

//    modport S_PORT(clocking cb, input GCLK, RST);

endinterface : dut_interface