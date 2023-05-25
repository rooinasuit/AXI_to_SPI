# AXI to SPI

The project pertains to inter-protocol communication (CPU - peripheral).

Based on the principle of one-for-all, AXI4-Lite protocol will be used as a means to standardize communication between a sample processor (AXI master)
and an SPI master peripheral (AXI slave).

## State of the project

- [ ] ~~List of project requirements,~~
- [x] Design for verification:
    - [x] ~~Design architecture,~~
    - [x] SPI master module,
    - [x] SPI master control/data registers (generated with the use of vivado),
    - [x] SPI master and its registers encased in an AXI slave module (generated with the use of vivado),
- [ ] UVM methodology verification of the design:
    - [ ] Design test cases based on project requirements
    - [x] ~~UVM test bench architecture,~~
    - [ ] UVM test bench (written in SystemVerilog):
        - [x] Instantiation of all required objects and components,
        - [ ] Threads management in the test bench,
        - [ ] Directed tests based on the test cases,
    - [x] ~~Script-based compilation of both test bench and the DUT,~~
    - [ ] Script-based simulation scheme,
    - [ ] Script-based regression testing.

Simulation scripts, list of requirements and test cases, along with both the design and testbench architectures, will get introduced as the project nears its completion.

