
package proj_pkg;

`include "tb_reset_seq_item.sv"
`include "tb_dio_seq_item.sv"
`include "tb_spi_slave_seq_item.sv"

`include "tb_reset_sequences.sv"
`include "tb_dio_sequence.sv"
`include "tb_spi_slave_sequence.sv"

`include "tb_reset_sequencer.sv"
`include "tb_dio_sequencer.sv"
`include "tb_spi_slave_sequencer.sv"

`include "tb_virtual_sequencer.sv"
`include "tb_virtual_sequences.sv"

`include "tb_clock_driver.sv"
`include "tb_reset_driver.sv"
`include "tb_dio_driver.sv"
`include "tb_spi_slave_driver.sv"

`include "tb_dio_monitor.sv"
`include "tb_spi_slave_monitor.sv"

`include "tb_clock_agent.sv"
`include "tb_reset_agent.sv"
`include "tb_dio_agent.sv"
`include "tb_spi_slave_agent.sv"

`include "tb_ref_model.sv"
`include "tb_checker.sv"
`include "tb_scoreboard.sv"

`include "tb_environment.sv"

`include "tb_test.sv"

endpackage