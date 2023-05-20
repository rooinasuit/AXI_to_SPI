import uvm_pkg::*;
`include "uvm_macros.svh"

import proj_pkg::*;

class reset_driver extends uvm_driver#(reset_seq_item);

    `uvm_component_utils(reset_driver)

    // instantiation of internal objects
    virtual dut_interface vif;
    reset_seq_item rst_pkt;

    function new (string name = "clock_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(!uvm_config_db#(virtual dut_interface)::get(this, get_full_name(), "vif", vif)) begin
            `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), "vif"})
        end

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        rst_pkt = reset_seq_item::type_id::create("rst_pkt");
        forever begin
            @(posedge vif.GCLK)
                `uvm_info("RST_DRV", "Setting a new value of RST in the DUT", UVM_LOW)
                seq_item_port.get_next_item(rst_pkt); // blocking

                vif.RST <= rst_pkt.RST;

                `uvm_info("RST_DRV", "Transaction finished, ready for another", UVM_LOW)
                seq_item_port.item_done(); // unblocking, ready for another send to the DUT
        end

    endtask : run_phase

endclass : reset_driver