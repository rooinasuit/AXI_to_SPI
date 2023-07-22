
class comparator#(type T = uvm_sequence_item) extends uvm_component;

    `uvm_component_param_utils(comparator#(T))

    uvm_tlm_fifo#(T) fifo_obs;
    uvm_tlm_fifo#(T) fifo_exp;

    T exp_pkt;
    T obs_pkt;

    int result;

    function new(string name = "comparator", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        fifo_obs = new("fifo_obs", this, 10);
        fifo_exp = new("fifo_exp", this, 10);

    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            fifo_exp.get(exp_pkt);
            fifo_obs.get(obs_pkt);

            `uvm_info(get_name(), $sformatf("\nNEW PAIR OF ITEMS IN COMPARATOR\n"), UVM_LOW)
            result = exp_pkt.compare_packet(obs_pkt);
            if (result) begin
                `uvm_info(get_name(), $sformatf("\nobs_pkt == exp_pkt\n"), UVM_LOW)
            end
            else begin
                `uvm_info(get_name(), $sformatf("\nobs_pkt != exp_pkt\n"), UVM_LOW)
            end
        end

    endtask : run_phase

    function void write_exp(T item);
        fork
            fifo_exp.put(item);
        join_none
    endfunction : write_exp

    function void write_obs(T item);
        fork
            if(item.obs_timestamp != 0) begin
                fifo_obs.put(item);
            end
        join_none
    endfunction : write_obs

endclass : comparator