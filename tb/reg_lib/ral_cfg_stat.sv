class ral_cfg_stat extends uvm_reg;
    uvm_reg_field state;

    `uvm_object_utils(ral_cfg_stat)

    function new(string name = "ral_cfg_stat");
        super.new(name, 8, UVM_CVR_ALL);
    endfunction

    virtual function void build();
        this.state = uvm_reg_field::type_id::create("state", , get_full_name());
        this.state.configure(this, 2, 0, "RO", 0, 1'h0, 1, 1, 1);

        this.set_reset(32'h00000000, "SOFT"); // Reset value for stat_reg
    endfunction
endclass

