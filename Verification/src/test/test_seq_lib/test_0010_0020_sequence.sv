
class test_0010_0020_sequence extends test_base_sequence;

    `uvm_object_utils(test_0010_0020_sequence)

    function new (string name = "test_0010_0020_sequence");
        super.new(name);
    endfunction : new

    // FRD-0010:
    // The SPI shall start sending an SPI frame on the rising edge of start_i when SPI is not sending any SPI frame and time defined by IFG_i elapsed from the moment when last SPI frame transmission was finished.

    // FRD-0020:
    // If the rising edge of start_i is detected during IFG, the SPI shall wait until IFG elapses and start sending the SPI frame.

    // TC-0010-0020:

    // [Brief]: assert start_i:
    //     - during SPI frame,
    //     - during IFG,
    //     - after IFG.

    // 1. Release reset signal,

    // 2. Provide the SPI master with following:
    //     - spi_mode_i - any,
    //     - sck_speed_i - any,
    //     - word_len_i - any,
    //     - CS_SCK_i - any,
    //     - SCK_CS_i - any,
    //     - IFG_i - {0, 255},
    //     - mosi_data_i - any,
    //     - MISO_i - any.

    // 3. Drive start_i = 1 in one of the possible ways (cover all):
    //     3.1. While IFG_i = 0:
    //         3.1.1. Assert for 1 clock cycle,
    //         3.1.2. Assert for more than 1 clock cycle and deassert before the end  of  SPI transmission,
    //         3.1.3. Assert for more than 1 clock cycle and keep it asserted for a few more clock cycles after the end of SPI transmission.
    //     3.2. While IFG_i = 255:
    //         3.2.1. Assert for 1 clock cycle,
    //         3.2.2. Assert for more than 1 clock cycle and deassert before the end  of  SPI transmission,
    //         3.2.3. Assert for more than 1 clock cycle and keep it asserted for a few more clock cycles after the end of SPI transmission.

    // 4. Verify that the SPI master:
    //     4.1. Begins sending SPI frame on the rising edge of start_i,
    //     4.2. Ignores any edge or state of start_i signal if it is asserted while there is an ongoing SPI transmission,
    //     4.3. Counts off the preset value of IFG_i when the SPI transmission ends before allowing for another SPI transmission to take place,


    task body();
        reset_io();
        drive_clock_period(clock_cycle); // ns
        drive_clock_state(1);
        //
        #(2*clock_cycle);
        drive_io("NRST", 1);
        //
        config_dio_params(0, 0, 3, 255, 0, 0, 0);
        define_test_step("setting up dio params -> IFG = 255");

        define_test_step("decoy frame");
        //
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 3.1.1
        //
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 3.1.2
        //
        #(11*clock_cycle);
        drive_io("start", 1);
        #(10*clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);

        // CASE 3.1.3
        //
        #(11*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        wait_io("CS_o", 1);
        #(10*clock_cycle);
        drive_io("start", 0);
        //

        config_dio_params(0, 0, 3, 0, 0, 0, 0);
        define_test_step("setting up dio params -> IFG = 0");

        define_test_step("decoy frame");
        //
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 3.2.1
        //
        #(clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);
        #(clock_cycle);

        // CASE 3.2.2
        //
        #(11*clock_cycle);
        drive_io("start", 1);
        #(10*clock_cycle);
        drive_io("start", 0);
        //
        wait_io("CS_o", 1);

        // CASE 3.2.3
        //
        #(11*clock_cycle);
        drive_io("start", 1);
        #(clock_cycle);
        wait_io("CS_o", 1);
        #(10*clock_cycle);
        drive_io("start", 0);
        //
        drive_clock_state(0);
    endtask : body

endclass : test_0010_0020_sequence