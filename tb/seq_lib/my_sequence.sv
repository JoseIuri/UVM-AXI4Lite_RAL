class my_sequence extends uvm_reg_sequence();
   `uvm_object_utils(my_sequence)

   function new(string name = "my_sequence");
      super.new(name);
   endfunction

 virtual task body();
    uvm_status_e status; 
    uvm_reg_data_t rdata;
    ral_block_traffic_cfg m_ral_model;

    if (!$cast(m_ral_model, model)) begin
        `uvm_fatal("SEQ", "Failed to cast model to ral_block_traffic_cfg");
    end

   // Write and verify Registers
   // Write to bl_yellow with value 0
   write_reg(m_ral_model.ctrl, status, 32'h20); 
   m_ral_model.ctrl.sample_coverage();

   // Write to bl_yellow with value 1
   write_reg(m_ral_model.ctrl, status, 32'h2); // Assuming `bl_yellow` is bit 1
   m_ral_model.ctrl.sample_coverage();

   // Write to bl_red with value 0
   write_reg(m_ral_model.ctrl, status, 32'h0); 
   m_ral_model.ctrl.sample_coverage();

   // Write to bl_red with value 1
   write_reg(m_ral_model.ctrl, status, 32'h4); // Assuming `bl_red` is bit 2
   m_ral_model.ctrl.sample_coverage();

   write_reg(m_ral_model.ctrl, status, 32'h1); 
   m_ral_model.ctrl.sample_coverage();


    write_reg(m_ral_model.timer[0], status, 32'hAAAA_BBBB);
    m_ral_model.timer[0].mirror(status, UVM_CHECK);
    read_reg(m_ral_model.timer[0], status, rdata);
   `uvm_info("SEQ", $sformatf("Read Data from timer[0]: %h", rdata), UVM_LOW);

    write_reg(m_ral_model.timer[1], status, 32'hCCCC_DDDD);
    m_ral_model.timer[1].mirror(status, UVM_CHECK);

    read_reg(m_ral_model.timer[1], status, rdata);
    `uvm_info("SEQ", $sformatf("Read Data from timer[1]: %h", rdata), UVM_LOW);


endtask
endclass
