class reg_rw_test extends base_test;
   `uvm_component_utils(reg_rw_test)

   my_sequence m_seq;
   reset_seq   rst_seq;

   function new(string name = "reg_rw_test", uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual task main_phase(uvm_phase phase);
      phase.raise_objection(this);

      // Create and run the reset sequence
      rst_seq = reset_seq::type_id::create("rst_seq");
      rst_seq.start(null); // Null sequencer for direct execution of reset

      // Create and run the main test sequence
      m_seq = my_sequence::type_id::create("m_seq");

      // Pass the Register Model to the Sequence
      m_seq.model = m_env.m_ral_model;

      // Run the main test sequence
      m_seq.start(m_env.m_agent.m_seqr);

      phase.drop_objection(this);
   endtask
endclass

