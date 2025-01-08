// Register definition for the register called "timer"
class ral_cfg_timer extends uvm_reg;
  uvm_reg_field timer;     // Time for which it blinks
 
  `uvm_object_utils(ral_cfg_timer)
  function new(string name = "traffic_cfg_timer");
    super.new(name, 32,UVM_CVR_ALL);
  endfunction
 
  virtual function void build();
     this.timer = uvm_reg_field::type_id::create("timer",,get_full_name());
 
    // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
     this.timer.configure(this, 32, 0, "RW", 0, 32'hCAFE1234, 1, 0, 1);
     this.timer.set_reset(32'hCAFE1234, "SOFT");
  endfunction
endclass