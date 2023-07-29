
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

    function void check_phase(uvm_phase phase);
        super.check_phase(phase);

        fork
        begin
        if(fifo_exp.is_empty() == 0) begin
            while (fifo_exp.used() > 0) begin
                fifo_exp.get(exp_pkt);
                exp_pkt.print();
                if(exp_pkt.exp_timestamp_max < $realtime) begin
                    `uvm_info(get_name(), $sformatf("prediction didn't meet with an observed item in time"), UVM_LOW)
                end
                else begin
                    `uvm_info(get_name(), $sformatf("run phase ended before the max timestamp"), UVM_LOW)
                end
            end
        end
        else begin
            `uvm_info(get_name(), "exp fifo is empty", UVM_LOW)
        end
        if(fifo_obs.is_empty() == 0) begin
            while (fifo_obs.used() > 0) begin
                fifo_obs.get(obs_pkt);
                obs_pkt.print();
                `uvm_info(get_name(), $sformatf("observed item didn't meet its prediction"), UVM_LOW)
            end
        end
        else begin
            `uvm_info(get_name(), "obs fifo is empty", UVM_LOW)
        end
        end
        join_none

    endfunction : check_phase

    function void write_exp(T item);
        fork
        begin
            // `uvm_info(get_name(), $sformatf("PACKET RECEIVED IN COMPARATOR: EXP"), UVM_LOW)
            // item.print();
            fifo_exp.put(item);
        end
        join_none
    endfunction : write_exp

    function void write_obs(T item);
        fork
        begin
            // `uvm_info(get_name(), $sformatf("PACKET RECEIVED IN COMPARATOR: OBS"), UVM_LOW)
            // item.print();
            if(item.obs_timestamp != 0) begin
                fifo_obs.put(item);
            end
        end
        join_none
    endfunction : write_obs

endclass : comparator