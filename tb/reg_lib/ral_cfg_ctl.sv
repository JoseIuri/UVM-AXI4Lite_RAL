import uvm_pkg::*;           // Import UVM package
`include "uvm_macros.svh"    // Include UVM macros
class ral_cfg_ctl extends uvm_reg;
    rand uvm_reg_field mod_en;
    rand uvm_reg_field bl_yellow;
    rand uvm_reg_field bl_red;
    rand uvm_reg_field profile;

    `uvm_object_utils(ral_cfg_ctl)

 
  
    // Define the covergroup
  covergroup cg(string name = "default_name");
    option.per_instance=1;
    option.auto_bin_max=2;
    coverpoint mod_en.get() {
     
      bins value[] = {0,1};
    }    // Track the values of mod_en
    coverpoint bl_yellow.get() {
   bins yellow_value[] = {0, 1};
    }
    coverpoint bl_red.get() {
   bins red_value[] = {0, 1};
}

 
    endgroup
  
     function new(string name = "ral_cfg_ctl");
        super.new(name, 8, UVM_CVR_ALL);
       cg = new(); // Initialize the covergroup
           `uvm_info("RAL_CFG_CTL", $sformatf("Creating instance: %s", name), UVM_LOW);

    endfunction
  
     // Sample the covergroup whenever a transaction occurs
    virtual function void sample_coverage();
        $display("Sampling coverage for ral_cfg_ctl");
        cg.sample();
    endfunction 

    virtual function void build();
        this.mod_en = uvm_reg_field::type_id::create("mod_en", , get_full_name());
        this.bl_yellow = uvm_reg_field::type_id::create("bl_yellow", , get_full_name());
        this.bl_red = uvm_reg_field::type_id::create("bl_red", , get_full_name());
        this.profile = uvm_reg_field::type_id::create("profile", , get_full_name());

        this.mod_en.configure(this, 1, 0, "RW", 0, 1'h0, 1, 1, 1);
        this.bl_yellow.configure(this, 1, 1, "RW", 0, 1'h0, 1, 1, 1);
        this.bl_red.configure(this, 1, 2, "RW", 0, 1'h0, 1, 1, 1);
        this.profile.configure(this, 1, 3, "RW", 0, 1'h0, 1, 1, 1);

        this.set_reset(32'h00000000, "SOFT"); // Reset value for ctl_reg
    endfunction
  
endclass