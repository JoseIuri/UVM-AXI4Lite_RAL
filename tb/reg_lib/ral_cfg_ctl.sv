// Register definition for the register called "ctl"
class ral_cfg_ctl extends uvm_reg;
    rand uvm_reg_field mod_en;      // Enables the module
    rand uvm_reg_field bl_yellow;   // Blinks yellow
    rand uvm_reg_field bl_red;      // Blinks red
    rand uvm_reg_field profile;     // 1 : Peak, 0 : Off-Peak

    `uvm_object_utils(ral_cfg_ctl)
// new code start

////////////////////////adding coverpoints     
  
 covergroup mod_cov;
    
   option.per_instance = 1;
    
    
   coverpoint mod_en 
    {
      bins low = {0};
      bins high = {1};
    }

    coverpoint bl_yellow;
    coverpoint b1_red;
    coverpoint profile;
     
  endgroup
  
 
  ////////////////checking coverage and adding new method to covergroup
  
  function new (string name = "ral_cfg_ctl");
    super.new(name,32,UVM_CVR_FIELD_VALS);
    
    if(has_coverage(UVM_CVR_FIELD_VALS))
      mod_en = new();
    
  endfunction
 
//////////////////////////////   implementation of sample and sample_Values  
  
  
  virtual function void sample(uvm_reg_data_t data,
                                uvm_reg_data_t byte_en,
                                bit            is_read,
                                uvm_reg_map    map);
    
         mod_en.sample();
   endfunction
  
  
   virtual function void sample_values();
    super.sample_values();
     
    mod_en.sample();
     
   endfunction


    //new code end: jissjoseph1997

   /* function new(string name = "traffic_cfg_ctrl");
        super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
    endfunction: new */

    // Build all register field objects
    virtual function void build();
        this.mod_en     = uvm_reg_field::type_id::create("mod_en",,   get_full_name());
        this.bl_yellow  = uvm_reg_field::type_id::create("bl_yellow",,get_full_name());
        this.bl_red     = uvm_reg_field::type_id::create("bl_red",,   get_full_name());
        this.profile    = uvm_reg_field::type_id::create("profile",,  get_full_name());

        // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
        this.mod_en.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 0);
        this.bl_yellow.configure(this, 1, 1, "RW", 0, 3'h4, 1, 0, 0);
        this.bl_red.configure(this, 1, 2, "RW", 0, 1'h0, 1, 0, 0);
        this.profile.configure(this, 1, 3, "RW", 0, 1'h0, 1, 0, 0);
    endfunction
endclass