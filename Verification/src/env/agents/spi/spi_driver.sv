
class spi_driver extends uvm_driver#(spi_seq_item);

    `uvm_component_utils(spi_driver)

    // instantiation of internal objects
    spi_config spi_cfg;
    virtual spi_interface vif;
    spi_seq_item spi_pkt;

    bit sck_pol;
    int MISO_buff;

    function new (string name = "spi_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(spi_config)::get(this, "", "spi_config", spi_cfg)) begin
            `uvm_fatal("SPI_DRV", {"spi config must be set for: ", get_full_name(), " spi_cfg"})
        end

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = spi_cfg.vif;

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        // forever begin
        MISO_data_assert();
        spi_mode_assert();
        spi_slave_send();
        // end

    endtask : run_phase

    task MISO_data_assert();
        fork
            begin
                // if (vif.CS_out) begin
                    create_handle();
                    MISO_buff = spi_pkt.value;
                    `uvm_info("SPI_DRV", $sformatf("Fetched MISO buffer: %d", MISO_buff), UVM_LOW)
                    transaction_done();
                // end
            end
        join_none
    endtask : MISO_data_assert

    task spi_mode_assert();
        fork
            begin
                if (vif.CS_out) begin
                    sck_pol = (vif.SCLK_out) ? 1 : 0;
                end
            end
        join_none
    endtask : spi_mode_assert

    task spi_slave_send();
        fork
            begin
                int i;
                @(negedge vif.CS_out)
                    while (!vif.CS_out) begin
                        case (sck_pol)
                            0: begin
                                for(i=0; i<32; i++) begin
                                @(posedge vif.SCLK_out)
                                    vif.MISO_in <= MISO_buff[i]; // MISO_out
                                end
                            end
                            1: begin
                                for(i=0; i<32; i++) begin
                                @(negedge vif.SCLK_out)
                                    vif.MISO_in <= MISO_buff[i]; // MISO_out
                                end
                            end
                        endcase
                    end
            end
        join_none
    endtask : spi_slave_send

    task create_handle();
        spi_pkt = spi_seq_item::type_id::create("spi_pkt");
        seq_item_port.get_next_item(spi_pkt);
    endtask : create_handle

    function void transaction_done();
        `uvm_info("SPI_DRV", "MISO fetch done", UVM_LOW)
        seq_item_port.item_done();
    endfunction : transaction_done

endclass: spi_driver