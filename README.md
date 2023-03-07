# AXI to SPI

This update marks the beginning of a larger project, pertaining to inter-protocol communication (CPU - peripheral).

Based on the principle of one-for-all, AXI4-Lite protocol will be used as a means to standardize communication between a sample processor (AXI master)
and an SPI master peripheral (AXI slave).

## State of the project

- [x] SPI master module,
- [x] SPI master control/data registers (generated with the use of vivado),
- [x] SPI master and its registers encased in an AXI slave module (generated with the use of vivado),
- [ ] AXI4-Lite Bus,
- [ ] UVM methodology verification of SPI master (Design Under Test):
    - [ ] UVM test bench (written in SystemVerilog),
    - [ ] Script-based compilation of both test bench and the DUT,
    - [ ] Script-based simulation scheme,
    - [ ] Script-based regression testing.

