class apb_driver extends uvm_driver #(apb_tr);
   `uvm_component_utils (apb_driver)
 
   apb_tr  tr;
   virtual apb_if    vif;
 
   function new (string name = "apb_driver", uvm_component parent);
      super.new (name, parent);
   endfunction
 
   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      if (! uvm_config_db#(virtual apb_if)::get (this, "*", "apb_if", vif))
         `uvm_error ("DRVR", "Did not get bus if handle")
   endfunction
 
   virtual task run_phase (uvm_phase phase);
      bit [31:0] data;
 
      vif.psel <= 0;
      vif.penable <= 0;
      vif.pwrite <= 0;
      vif.paddr <= 0;
      vif.pwdata <= 0;
      forever begin
         @(posedge vif.pclk);
         seq_item_port.get_next_item (tr);
         if (tr.write)
            write (tr.addr, tr.data);
         else begin
            read (tr.addr, data);
            tr.data = data;
         end
         seq_item_port.item_done ();
      end
   endtask
 
   virtual task write(input bit [31:0] addr, input bit [31:0] data);
    vif.paddr <= addr;
    vif.pwdata <= data;
    vif.pwrite <= 1;
    vif.psel <= 1;
    @(posedge vif.pclk);
    vif.penable <= 1;

    // Wait for pready to be asserted
    wait (vif.pready == 1);
    @(posedge vif.pclk);
    $display("DRIVER WRITE: Addr=%h, Data=%h, pready=%b", addr, data, vif.pready);

    vif.psel <= 0;
    vif.penable <= 0;
endtask

virtual task read(input bit [31:0] addr, output logic [31:0] data);
    vif.paddr <= addr;
    vif.pwrite <= 0;
    vif.psel <= 1;
    @(posedge vif.pclk);
    vif.penable <= 1;

    // Wait for pready to be asserted
    wait (vif.pready == 1);
    @(posedge vif.pclk);
    data = vif.prdata;
    $display("DRIVER READ: Addr=%h, Data=%h, pready=%b", addr, data, vif.pready);

    vif.psel <= 0;
    vif.penable <= 0;
endtask
     
endclass
