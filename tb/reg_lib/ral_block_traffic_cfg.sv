class ral_block_traffic_cfg extends uvm_reg_block;
  
  `uvm_object_utils(ral_block_traffic_cfg)
  
  rand ral_cfg_ctl    ctrl;       // RW
  rand ral_cfg_timer  timer[2];   // RW
  rand ral_cfg_stat        stat;       // RO

  uvm_reg_map         reg_map;
 
 
  function new(string name = "ral_block_traffic_cfg");
    super.new(name, UVM_CVR_ALL);
      `uvm_info("RAL_BLOCK", $sformatf("Creating instance: %s", name), UVM_LOW);
  endfunction
 
  
  virtual function void build();
    this.reg_map = create_map("", 0, 8, UVM_LITTLE_ENDIAN, 0);
    
    this.ctrl = ral_cfg_ctl::type_id::create("ctrl",,get_full_name());
    this.ctrl.build();
    this.ctrl.configure(this, null, "");   
    this.reg_map.add_reg(this.ctrl, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
 
 
    this.timer[0] = ral_cfg_timer::type_id::create("timer[0]",,get_full_name());
    this.timer[0].build();
    this.timer[0].configure(this, null, "");
    
    this.reg_map.add_reg(this.timer[0], `UVM_REG_ADDR_WIDTH'h4, "RW", 0);
 
    this.timer[1] = ral_cfg_timer::type_id::create("timer[1]",,get_full_name());
    this.timer[1].build();
    this.timer[1].configure(this, null, "");
    
    this.reg_map.add_reg(this.timer[1], `UVM_REG_ADDR_WIDTH'h8, "RW", 0);
 
    this.stat = ral_cfg_stat::type_id::create("stat",,get_full_name());
    this.stat.build();
    this.stat.configure(this, null, "");
    
    this.reg_map.add_reg(this.stat, `UVM_REG_ADDR_WIDTH'hc, "RO", 0);

    lock_model();
  endfunction 
endclass 