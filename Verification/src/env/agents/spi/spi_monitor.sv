
class spi_monitor extends uvm_monitor;

    `uvm_component_utils(spi_monitor)

    // instantiation of internal objects
    spi_config spi_cfg;
    virtual spi_interface vif;
    spi_seq_item spi_pkt_in;

    uvm_analysis_port#(spi_seq_item) spi_mtr_port;

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


        forever begin
            spi_slave_capture();
        end

    endtask : run_phase

    task spi_slave_capture();
        if (!vif.CS_out) begin
            fork
                mode0_p();
                mode0_n();
                mode1_p();
                mode1_n();
                mode2_p();
                mode2_n();
                mode3_p();
                mode3_n();
            join
        end
    endtask : spi_slave_capture

    function void create_handle();
        spi_pkt_in = spi_seq_item::type_id::create("spi_pkt_in");
    endfunction : create_handle

    function void write_transaction();
        // `uvm_info("SLV_MTR", "Writing collected slv_mtr_pkt onto dio_mtr_port", UVM_LOW)
        spi_mtr_port.write(spi_pkt_in);
    endfunction : write_transaction

    task mode0_p();
        begin
            @(posedge vif.SCLK_out) begin
                `uvm_info("SPI_MTR", "mode_0 MOSI value", UVM_LOW)
                create_handle();
                spi_pkt_in.name_mode0 = "MOSI";
                spi_pkt_in.value_mode0 = vif.MOSI_out;
                write_transaction();
                
            end
        end
    endtask : mode0_p
    task mode0_n();
        begin
            @(negedge vif.SCLK_out) begin
                `uvm_info("SPI_MTR", "mode_0 MISO value", UVM_LOW)
                create_handle();
                spi_pkt_in.name_mode0 = "MISO";
                spi_pkt_in.value_mode0 = vif.MISO_in;
                write_transaction();
            end
        end
    endtask : mode0_n

    task mode1_p();
        begin
            @(posedge vif.SCLK_out) begin
                `uvm_info("SPI_MTR", "mode_1 MISO value", UVM_LOW)
                create_handle();
                spi_pkt_in.name_mode1 = "MISO";
                spi_pkt_in.value_mode1 = vif.MISO_in;
                write_transaction();
            end
        end
    endtask : mode1_p
    task mode1_n();
        begin
            @(negedge vif.SCLK_out) begin
                `uvm_info("SPI_MTR", "mode_1 MOSI value", UVM_LOW)
                create_handle();
                spi_pkt_in.name_mode1 = "MOSI";
                spi_pkt_in.value_mode1 = vif.MOSI_out;
                write_transaction();
            end
        end
    endtask : mode1_n

    task mode2_n();
        begin
            @(negedge vif.SCLK_out) begin
                `uvm_info("SPI_MTR", "mode_2 MISO value", UVM_LOW)
                create_handle();
                spi_pkt_in.name_mode2 = "MISO";
                spi_pkt_in.value_mode2 = vif.MISO_in;
                write_transaction();
            end
        end
    endtask : mode2_n
    task mode2_p();
        begin
            @(posedge vif.SCLK_out) begin
                `uvm_info("SPI_MTR", "mode_2 MOSI value", UVM_LOW)
                create_handle();
                spi_pkt_in.name_mode2 = "MOSI";
                spi_pkt_in.value_mode2 = vif.MOSI_out;
                write_transaction();
            end
        end
    endtask : mode2_p

    task mode3_n();
        begin
            @(negedge vif.SCLK_out) begin
                `uvm_info("SPI_MTR", "mode_3 MOSI value", UVM_LOW)
                create_handle();
                spi_pkt_in.name_mode3 = "MOSI";
                spi_pkt_in.value_mode3 = vif.MOSI_out;
                write_transaction();
            end
        end
    endtask : mode3_n
    task mode3_p();
        begin
            @(posedge vif.SCLK_out) begin
                `uvm_info("SPI_MTR", "mode_3 MISO value", UVM_LOW)
                create_handle();
                spi_pkt_in.name_mode3 = "MISO";
                spi_pkt_in.value_mode3 = vif.MISO_in;
                write_transaction();
            end
        end
    endtask : mode3_p

endclass: spi_monitor