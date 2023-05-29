import uvm_pkg::*;
`include "uvm_macros.svh"

class spi_slave_monitor extends uvm_monitor;

    `uvm_component_utils(spi_slave_monitor)

    // instantiation of internal objects
    virtual spi_slave_interface vif;
    spi_slave_seq_item slv_pkt_in;

    uvm_analysis_port#(spi_slave_seq_item) slv_mon_port;

    function new (string name = "spi_slave_monitor", uvm_component parent = null);
        super.new(name,parent);

        slv_mon_port = new("slv_mon_port", this);

    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(!uvm_config_db#(virtual spi_slave_interface)::get(this, "", "s_vif", vif)) begin
            `uvm_error("SPI_MTR", {"virtual interface must be set for: ", get_full_name(), "vif"})
        end

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);


        forever begin
            // @(posedge vif.GCLK)
                slv_pkt_in = spi_slave_seq_item::type_id::create("slv_pkt_in");
                `uvm_info("SLV_MTR", "Fetching slv_pkt_in from the DUT", UVM_LOW)

                slv_pkt_in.MISO_in   = vif.MISO_in;

                slv_pkt_in.MOSI_out  = vif.MOSI_out;
                slv_pkt_in.SCLK_out  = vif.SCLK_out;
                slv_pkt_in.CS_out    = vif.CS_out;

                `uvm_info("SLV_MTR", "Writing collected slv_pkt_in onto slv_mon_port", UVM_LOW)
                slv_mon_port.write(slv_pkt_in);
        end

    endtask : run_phase

endclass: spi_slave_monitor