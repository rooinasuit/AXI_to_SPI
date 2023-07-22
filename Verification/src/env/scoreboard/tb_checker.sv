
`uvm_analysis_imp_decl(_dio_expected)
`uvm_analysis_imp_decl(_spi_expected)

class tb_checker extends uvm_component;

    `uvm_component_utils(tb_checker)

    uvm_component dio_comp_array[$];
    uvm_component spi_comp_array[$];

    // `COMP_DECLARE(dio_seq_item, busy_o)
    `COMP_DECLARE(spi_seq_item, MOSI_frame)
    // `COMP_DECLARE(dio_seq_item, MISO_frame)
    `COMP_DECLARE(dio_seq_item, miso_data_o)
    `COMP_DECLARE(dio_seq_item, min_IFG)

    uvm_analysis_imp_dio_expected#(dio_seq_item, tb_checker) dio_rfm_imp;
    uvm_analysis_imp_spi_expected#(spi_seq_item, tb_checker) spi_rfm_imp;

    function new(string name = "tb_checker", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        dio_rfm_imp = new("dio_rfm_imp", this);
        spi_rfm_imp = new("spi_rfm_imp", this);

        // `COMP_CREATE(dio_seq_item, busy_o)
        `COMP_CREATE(spi_seq_item, MOSI_frame)
        // `COMP_CREATE(dio_seq_item, MISO_frame)
        `COMP_CREATE(dio_seq_item, miso_data_o)
        `COMP_CREATE(dio_seq_item, min_IFG)
        // `COMP_CREATE(spi_seq_item, MISO_frame)

        foreach(dio_comp_array[i]) begin
            `uvm_info(get_name(), $sformatf("comparator handle name: %s", dio_comp_array[i].get_name()), UVM_LOW)
        end

    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        //
    endtask : run_phase

    function comparator#(dio_seq_item) get_comp_dio(dio_seq_item item);

        string comp_port_name;
        string port_name;

        get_children(dio_comp_array);
        foreach(dio_comp_array[i]) begin
            comp_port_name = dio_comp_array[i].get_name();
            port_name = comp_port_name.substr(5, comp_port_name.len() - 1);
            if(port_name == item.name) begin
                if (dio_comp_array[i] == null) begin
                    `uvm_fatal(get_name(), $sformatf("There's no comparator made for %s", item.name))
                end
                $cast(get_comp_dio,dio_comp_array[i]);
            end
        end

    endfunction : get_comp_dio

    function comparator#(spi_seq_item) get_comp_spi(spi_seq_item item);

        string comp_port_name;
        string port_name;

        get_children(spi_comp_array);
        foreach(spi_comp_array[i]) begin
            comp_port_name = spi_comp_array[i].get_name();
            port_name = comp_port_name.substr(5, comp_port_name.len() - 1);
            if(port_name == item.name) begin
                if (spi_comp_array[i] == null) begin
                    `uvm_fatal(get_name(), $sformatf("There's no comparator made for %s", item.name))
                end
                $cast(get_comp_spi,spi_comp_array[i]);
            end
        end

    endfunction : get_comp_spi

    function void write_dio_observed(dio_seq_item item);

        `uvm_info(get_name(), $sformatf("Data received from DIO_MTR: "), UVM_LOW)
        item.print();
        get_comp_dio(item).write_obs(item);

    endfunction : write_dio_observed

    function void write_dio_expected(dio_seq_item item);

        `uvm_info(get_name(), $sformatf("Data received from RFM: "), UVM_LOW)
        item.print();
        get_comp_dio(item).write_exp(item);

    endfunction : write_dio_expected

    function void write_spi_observed(spi_seq_item item);

        `uvm_info(get_name(), $sformatf("Data received from SPI_MTR: "), UVM_LOW)
        item.print();
        get_comp_spi(item).write_obs(item);

    endfunction : write_spi_observed

    function void write_spi_expected(spi_seq_item item);

        `uvm_info(get_name(), $sformatf("Data received from RFM: "), UVM_LOW)
        item.print();
        get_comp_spi(item).write_exp(item);

    endfunction : write_spi_expected

endclass