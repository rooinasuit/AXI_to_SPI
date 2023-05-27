package env_pkg;

    // `include "clock_agent.sv"
    // `include "dio_agent.sv"
    // `include "spi_slave_agent.sv"

    import clock_pkg::*;
    import dio_pkg::*;
    import spi_slave_pkg::*;

    `include "virtual_sequencer.sv"

    `include "checker.sv"
    `include "ref_model.sv"
    `include "scoreboard.sv"

endpackage : env_pkg