
class spi_slave_driver extends uvm_driver#(spi_slave_seq_item);

    `uvm_component_utils(spi_slave_driver)

    // instantiation of internal objects
    virtual spi_slave_interface vif;
    spi_slave_seq_item slv_pkt;

    int spi_mode;

    uvm_analysis_port#(spi_slave_seq_item) slv_drv_port;

    function new (string name = "spi_slave_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        slv_drv_port = new("slv_drv_port", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(!uvm_config_db#(virtual spi_slave_interface)::get(this, "", "s_vif", vif)) begin
            `uvm_error("SPI_DRV", {"virtual interface must be set for: ", get_full_name(), "vif"})
        end

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            create_handle();
            spi_slave_send(spi_mode);
            transaction_done();
        end

    endtask : run_phase

    task spi_slave_send(int spi_mode);
        if (vif.CS_out) begin
            case(spi_mode)
                0: begin
                    @(negedge vif.SCLK_out) begin
                        if (slv_pkt.name == "MISO_out")
                            vif.MISO_in <= slv_pkt.value;
                    end
                end
                1: begin
                    @(posedge vif.SCLK_out) begin
                        if (slv_pkt.name == "MISO_out")
                            vif.MISO_in <= slv_pkt.value;
                    end
                end
                2: begin
                    @(negedge vif.SCLK_out) begin
                        if (slv_pkt.name == "MISO_out")
                            vif.MISO_in <= slv_pkt.value;
                    end
                end
                3: begin
                    @(posedge vif.SCLK_out) begin
                        if (slv_pkt.name == "MISO_out")
                            vif.MISO_in <= slv_pkt.value;
                    end
                end
            endcase
        end
    endtask : spi_slave_send

    task create_handle();
        slv_pkt = spi_slave_seq_item::type_id::create("slv_pkt");
        seq_item_port.get_next_item(slv_pkt);
        `uvm_info("SLV_DRV", "Fetching next slv_pkt to put onto the DUT interface", UVM_LOW)
    endtask : create_handle

    function void transaction_done();
        `uvm_info("SLV_DRV", "Transaction finished, ready for another", UVM_LOW)
        slv_drv_port.write(slv_pkt);
        seq_item_port.item_done();
    endfunction : transaction_done

endclass: spi_slave_driver