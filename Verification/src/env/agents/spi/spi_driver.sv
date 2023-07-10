
class spi_driver extends uvm_driver#(spi_seq_item);

    `uvm_component_utils(spi_driver)

    // instantiation of internal objects
    spi_config spi_cfg;
    virtual spi_interface vif;
    spi_seq_item spi_pkt;

    int i;

    logic [1:0] spi_mode;
    logic [4:0] word_len;
    logic [31:0] MISO_buff;

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

        //
        spi_transaction();
        spi_get_config();
        spi_drive();

    endtask : run_phase

    task spi_get_config();
        @(negedge vif.CS_out);
            spi_mode = spi_cfg.spi_mode;
            word_len = spi_cfg.word_len;
            `uvm_info("SPI_DRV", $sformatf("loaded spi_mode: %h", spi_mode), UVM_LOW)
            `uvm_info("SPI_DRV", $sformatf("loaded word_len: %h", word_len), UVM_LOW)
    endtask : spi_get_config

    task spi_transaction();
        create_handle();
        case (spi_pkt.name)
            "MISO": begin
                MISO_buff = spi_pkt.value;
                `uvm_info("SPI_DRV", $sformatf("Fetched MISO buffer: %h", MISO_buff), UVM_LOW)
            end
            default: begin
                MISO_buff = MISO_buff;
            end
        endcase
        transaction_done();
    endtask : spi_transaction

    task spi_drive();
        case (spi_mode)
            0: begin
                for(i=(word_len); i>0; i--) begin
                if (i == (word_len)) begin
                    vif.MISO_in <= MISO_buff[i]; // MISO_out
                end
                else begin
                    @(negedge vif.SCLK_out)
                        vif.MISO_in <= MISO_buff[i]; // MISO_out
                end
                end
            end
            1: begin
                for(i=(word_len); i>0; i--) begin
                    @(posedge vif.SCLK_out)
                        vif.MISO_in <= MISO_buff[i]; // MISO_out
                end
            end
            2: begin
                for(i=(word_len); i>0; i--) begin
                    @(negedge vif.SCLK_out)
                        vif.MISO_in <= MISO_buff[i]; // MISO_out
                end
            end
            3: begin
                for(i=(word_len); i>0; i--) begin
                if (i == (word_len)) begin
                    vif.MISO_in <= MISO_buff[i]; // MISO_out
                end
                else begin
                    @(posedge vif.SCLK_out)
                        vif.MISO_in <= MISO_buff[i]; // MISO_out
                end
                end
            end
        endcase
    endtask : spi_drive

    task create_handle();
        spi_pkt = spi_seq_item::type_id::create("spi_pkt");
        seq_item_port.get_next_item(spi_pkt);
    endtask : create_handle

    function void transaction_done();
        seq_item_port.item_done();
    endfunction : transaction_done

endclass: spi_driver