
class spi_monitor extends uvm_monitor;

    `uvm_component_utils(spi_monitor)

    // instantiation of internal objects
    spi_config spi_cfg;
    virtual spi_interface vif;
    spi_seq_item spi_pkt_in;

    uvm_analysis_port#(spi_seq_item) spi_mtr_port;

    uvm_verbosity verbosity_v = UVM_HIGH;

    int i;

    logic [1:0] spi_mode;
    logic [4:0] word_len;

    logic [31:0] MISO_buff;
    logic [31:0] MOSI_buff;

    function new (string name = "spi_monitor", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        spi_mtr_port = new("spi_mtr_port", this);

        if (!uvm_config_db #(spi_config)::get(this, "", "spi_config", spi_cfg)) begin
            `uvm_fatal("SPI_AGT", {"spi config must be set for: ", get_full_name(), " spi_cfg"})
        end

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vif = spi_cfg.vif;

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        spi_get_config();
        spi_capture();
        spi_to_scb();

    endtask : run_phase

    task spi_get_config();
        @(negedge vif.CS_out);
            spi_mode = spi_cfg.spi_mode;
            word_len = spi_cfg.word_len;
            `uvm_info("SPI_MTR", $sformatf("loaded spi_mode: %h", spi_mode), UVM_LOW)
            `uvm_info("SPI_MTR", $sformatf("loaded word_len: %h", word_len), UVM_LOW)
    endtask : spi_get_config

    task spi_capture();
        case (spi_mode)
        0: begin
            for (i=(word_len); i>=0; i--) begin
                @(posedge vif.SCLK_out);
                MISO_buff[i] <= vif.MISO_in;
                MOSI_buff[i] <= vif.MOSI_out;
            end
            
        end
        1: begin
            for (i=(word_len); i>=0; i--) begin
                @(negedge vif.SCLK_out)
                MISO_buff[i] <= vif.MISO_in;
                MOSI_buff[i] <= vif.MOSI_out;
            end
        end
        2: begin
            for (i=(word_len); i>=0; i--) begin
                @(posedge vif.SCLK_out)
                MISO_buff[i] <= vif.MISO_in;
                MOSI_buff[i] <= vif.MOSI_out;
            end
        end
        3: begin
            for (i=(word_len); i>=0; i--) begin
                @(negedge vif.SCLK_out)
                MISO_buff[i] <= vif.MISO_in;
                MOSI_buff[i] <= vif.MOSI_out;
            end
        end
        endcase
    endtask : spi_capture

    task spi_to_scb();
        @(posedge vif.CS_out);
            fork
                begin
                create_handle();
                spi_pkt_in.name  = "MISO_frame";
                spi_pkt_in.value = MISO_buff;
                write_transaction();
                end
                //
                begin
                create_handle();
                spi_pkt_in.name  = "MOSI_frame";
                spi_pkt_in.value = MOSI_buff;
                write_transaction();
                end
            join
    endtask : spi_to_scb

    function void create_handle();
        spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
    endfunction : create_handle

    function void write_transaction();
        spi_mtr_port.write(spi_pkt_in);
    endfunction : write_transaction

endclass: spi_monitor
