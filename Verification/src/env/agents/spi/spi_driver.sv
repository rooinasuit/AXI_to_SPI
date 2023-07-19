
class spi_driver extends uvm_driver#(spi_seq_item);

    `uvm_component_utils(spi_driver)

    // instantiation of internal objects
    spi_config spi_cfg;
    virtual spi_interface vif;

    // MAYBE THINK ABOUT HOW TO DO THE 3rd MODE IN SPI
    // BOTH AS A MONITOR AND AS A DRIVER

    logic MISO_data_i [$];
    int bit_count;

    logic [1:0] spi_mode;

    function new (string name = "spi_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(spi_config)::get(this, "", "spi_config", spi_cfg)) begin
            `uvm_fatal(get_name(), {"spi config must be set for: ", get_full_name()})
        end

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = spi_cfg.vif;

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        fork
            spi_transaction();
            spi_get_ready();
        join_none

        spi_drive();

    endtask : run_phase

    task spi_transaction();
        forever begin
            spi_seq_item spi_rsp;
            spi_seq_item spi_pkt = spi_seq_item::type_id::create("spi_pkt");
            seq_item_port.get_next_item(spi_pkt);
            case (spi_pkt.name)
                "MISO": begin
                    MISO_data_i = spi_pkt.data;
                    seq_item_port.item_done();
                end
                "CS": begin
                    spi_rsp = spi_seq_item::type_id::create("spi_rsp");
                    @(posedge vif.CS_out);
                    spi_rsp.name = "ready";
                    spi_rsp.set_id_info(spi_pkt);
                    seq_item_port.item_done(spi_rsp);
                end
                default: begin
                    MISO_data_i = MISO_data_i;
                    seq_item_port.item_done();
                end
            endcase
        end
    endtask : spi_transaction

    task spi_get_ready();
        forever begin
        @(negedge vif.CS_out);
            bit_count = MISO_data_i.size();
            spi_mode = spi_cfg.spi_mode;
            `uvm_info(get_name(), $sformatf("loaded spi_mode: %h", spi_mode), UVM_LOW)
        end
    endtask : spi_get_ready

    task spi_drive();
        forever begin
        int i;
        @(negedge vif.CS_out);
            case(spi_mode)
            0: begin
                for(i=bit_count; i>=0; i--) begin
                    if (i == bit_count) begin
                        vif.MISO_in = MISO_data_i.pop_front();
                    end
                    else begin
                        @(negedge vif.SCLK_out);
                            vif.MISO_in = MISO_data_i.pop_front();
                    end
                end
            end
            1: begin
                for(i=bit_count; i>=0; i--) begin
                    @(posedge vif.SCLK_out);
                        vif.MISO_in = MISO_data_i.pop_front();
                end
            end
            2: begin
                for(i=bit_count; i>=0; i--) begin
                    @(negedge vif.SCLK_out);
                        vif.MISO_in = MISO_data_i.pop_front();
                end
            end
            3: begin
                for(i=bit_count; i>=0; i--) begin
                    if (i == bit_count) begin
                        vif.MISO_in = MISO_data_i.pop_front();
                    end
                    else begin
                        @(posedge vif.SCLK_out);
                            vif.MISO_in = MISO_data_i.pop_front();
                    end
                end
            end
            endcase
        end
    endtask : spi_drive

endclass: spi_driver