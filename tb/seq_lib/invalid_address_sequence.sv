class invalid_address_sequence extends uvm_sequence;
   `uvm_object_utils(invalid_address_sequence)

   function new(string name = "invalid_address_sequence");
      super.new(name);
   endfunction

   virtual task body();
      apb_tr tr;
      tr = apb_tr::type_id::create("invalid_address_tr", null);

      // Drive invalid address
      tr.addr = 32'hDEAD_BEEF; // Invalid address
      tr.data = 32'hBAD_CAFE;
      tr.write = 1;

      `uvm_info("INVALID_SEQ", $sformatf("Sending invalid address: %h", tr.addr), UVM_LOW);

      start_item(tr);
      finish_item(tr);
   endtask
endclass