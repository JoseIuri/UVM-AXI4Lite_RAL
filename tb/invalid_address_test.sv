class invalid_address_test extends uvm_test;
   `uvm_component_utils(invalid_address_test)

   traffic_env m_env;
   uvm_sequence invalid_seq;

   function new(string name = "invalid_address_test", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      m_env = traffic_env::type_id::create("m_env", this);
   endfunction

   virtual task main_phase(uvm_phase phase);
      phase.raise_objection(this);

      // Create and run the invalid_address_sequence
     
      invalid_seq = invalid_address_sequence::type_id::create("invalid_seq");
      invalid_seq.start(m_env.m_agent.m_seqr); // Start the sequence on the APB sequencer

      phase.drop_objection(this);
   endtask
endclass
