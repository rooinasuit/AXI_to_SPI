
class spi_slave_monitor extends uvm_monitor;

    `uvm_component_utils(spi_slave_monitor)

    // instantiation of internal objects
    virtual spi_slave_interface vif;
    spi_slave_seq_item slv_pkt_in;

    uvm_analysis_port#(spi_slave_seq_item) slv_mtr_port;

    int spi_mode;

    function new (string name = "spi_slave_monitor", uvm_component parent = null);
        super.new(name,parent);

        slv_mtr_port = new("slv_mtr_port", this);

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
            create_handle();
            spi_slave_capture(spi_mode);
            write_transaction();
        end

    endtask : run_phase

    task spi_slave_capture(int spi_mode);
        case(spi_mode)
            0: begin
                @(posedge vif.SCLK_out) begin
                    slv_pkt_in.name = "MOSI";
                    slv_pkt_in.value = vif.MOSI_out;
                end
                @(negedge vif.SCLK_out) begin
                    slv_pkt_in.name = "MISO";
                    slv_pkt_in.value = vif.MISO_in;
                end
            end
            1: begin
                @(posedge vif.SCLK_out) begin
                    slv_pkt_in.name = "MISO";
                    slv_pkt_in.value = vif.MISO_in;
                end
                @(negedge vif.SCLK_out) begin
                    slv_pkt_in.name = "MOSI";
                    slv_pkt_in.value = vif.MOSI_out;
                end
            end
            2: begin
                @(negedge vif.SCLK_out) begin
                    slv_pkt_in.name = "MISO";
                    slv_pkt_in.value = vif.MISO_in;
                end
                @(posedge vif.SCLK_out) begin
                    slv_pkt_in.name = "MOSI";
                    slv_pkt_in.value = vif.MOSI_out;
                end
            end
            3: begin
                // slv_pkt_in.CS_in    = vif.CS_out;
                // slv_pkt_in.SCLK_in  = vif.SCLK_out;
                @(negedge vif.SCLK_out) begin
                    slv_pkt_in.name = "MOSI";
                    slv_pkt_in.value = vif.MOSI_out;
                end
                @(posedge vif.SCLK_out) begin
                    slv_pkt_in.name = "MISO";
                    slv_pkt_in.value = vif.MISO_in;
                end
            end
        endcase
    endtask : spi_slave_capture

    function void create_handle();
        `uvm_info("SLV_MTR", "Fetching slv_pkt_in from the DUT", UVM_LOW)
        slv_pkt_in = spi_slave_seq_item::type_id::create("slv_pkt_in");
    endfunction : create_handle

    function void write_transaction();
        `uvm_info("SLV_MTR", "Writing collected slv_mtr_pkt onto dio_mtr_port", UVM_LOW)
        slv_mtr_port.write(slv_pkt_in);
    endfunction : write_transaction

endclass: spi_slave_monitor