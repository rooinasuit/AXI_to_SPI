
class spi_driver extends uvm_driver#(spi_seq_item);

    `uvm_component_utils(spi_driver)

    // instantiation of internal objects
    spi_config spi_cfg;
    virtual spi_interface vif;

    logic MISO_queue [$];
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
            spi_drive();
        join_none

    endtask : run_phase

    task spi_transaction();
        forever begin
            // spi_seq_item spi_rsp;
            spi_seq_item spi_pkt = spi_seq_item::type_id::create("spi_pkt");
            seq_item_port.get_next_item(spi_pkt);
            if (spi_pkt.name == "MISO") begin
                MISO_queue = spi_pkt.data;
            end
            // case (spi_pkt.name)
            //     "MISO": begin
            //         MISO_queue = spi_pkt.data;
            //     end
            //     default: begin
            //         MISO_queue = MISO_queue;
            //     end
            // endcase
            seq_item_port.item_done();
        end
    endtask : spi_transaction

    task spi_drive();
        int i;
        //
        forever begin
        vif.MISO_i = 0;
        @(negedge vif.CS_o);
            spi_mode = spi_cfg.spi_mode;
            bit_count = MISO_queue.size();
            `uvm_info(get_name(), $sformatf("spi mode: %d", spi_mode), UVM_LOW)
            case(spi_mode)
                0: begin
                    for(i=bit_count; i>=0; i--) begin
                        if (i == bit_count) begin
                            vif.MISO_i = MISO_queue.pop_front();
                        end
                        else begin
                            @(negedge vif.SCLK_o);
                                vif.MISO_i = MISO_queue.pop_front();
                        end
                    end
                end
                1: begin
                    for(i=bit_count; i>=0; i--) begin
                        @(posedge vif.SCLK_o);
                            vif.MISO_i = MISO_queue.pop_front();
                    end
                end
                2: begin
                    for(i=bit_count; i>=0; i--) begin
                        @(negedge vif.SCLK_o);
                            vif.MISO_i = MISO_queue.pop_front();
                    end
                end
                3: begin
                    for(i=bit_count; i>=0; i--) begin
                        if (i == bit_count) begin
                            vif.MISO_i = MISO_queue.pop_front();
                        end
                        else begin
                            @(posedge vif.SCLK_o);
                                vif.MISO_i = MISO_queue.pop_front();
                        end
                    end
                end
            endcase
        end
    endtask : spi_drive

endclass: spi_driver