
class tb_checker extends uvm_component;

    `uvm_component_utils(tb_checker)

    // comparator#(dio_seq_item) dio_comp_array[$];
    uvm_component dio_comp_array[$];

    `COMP_DECLARE(dio_seq_item, busy_out)
    `COMP_DECLARE(dio_seq_item, miso_data_out)
    // `COMP_DECLARE(spi_seq_item, MOSI_frame)
    `COMP_DECLARE(spi_seq_item, MISO_frame)

    function new(string name = "tb_checker", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `COMP_CREATE(dio_seq_item, busy_out)
        `COMP_CREATE(dio_seq_item, miso_data_out)
        // `COMP_CREATE(spi_seq_item, MOSI_frame)
        `COMP_CREATE(spi_seq_item, MISO_frame)

        foreach(dio_comp_array[i]) begin
            `uvm_info(get_name(), $sformatf("comparator handle name: %s", dio_comp_array[i].get_name()), UVM_LOW)
        end

    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

    endtask : run_phase

    function comparator#(dio_seq_item) get_comp(dio_seq_item item);

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
                $cast(get_comp,dio_comp_array[i]);
            end
        end

    endfunction : get_comp

    function void write_dio_observed(dio_seq_item dio_pkt_in);

        `uvm_info(get_name(), $sformatf("Data received from DIO_MTR: "), UVM_LOW)
        dio_pkt_in.item_type = "obs_item";
        dio_pkt_in.print();
        get_comp(dio_pkt_in).write_obs(dio_pkt_in);

    endfunction : write_dio_observed

    function void write_dio_expected(dio_seq_item dio_pkt_in);

        `uvm_info(get_name(), $sformatf("Data received from RFM: "), UVM_LOW)
        dio_pkt_in.item_type = "exp_item";
        dio_pkt_in.print();
        get_comp(dio_pkt_in).write_exp(dio_pkt_in);

    endfunction : write_dio_expected

    function void write_spi_observed(spi_seq_item spi_pkt_in);

        `uvm_info(get_name(), $sformatf("Data received from SPI_MTR: "), UVM_LOW)
        spi_pkt_in.item_type = "obs_item";
        spi_pkt_in.print();
        comp_MISO_frame.write_obs(spi_pkt_in);

    endfunction : write_spi_observed

    function void write_spi_expected(spi_seq_item spi_pkt_in);

        `uvm_info(get_name(), $sformatf("Data received from RFM: "), UVM_LOW)
        spi_pkt_in.item_type = "exp_item";
        spi_pkt_in.print();
        comp_MISO_frame.write_exp(spi_pkt_in);

    endfunction : write_spi_expected

endclass