class apb_monitor extends uvm_monitor;
   `uvm_component_utils (apb_monitor)
   function new (string name="apb_monitor", uvm_component parent);
      super.new (name, parent);
   endfunction
 
   uvm_analysis_port #(apb_tr)  mon_ap;
   virtual apb_if                vif;
 
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
        if (!uvm_config_db#(virtual apb_if)::get(null, "uvm_test_top.*", "apb_if", vif))
            `uvm_error("MONITOR", "Failed to get apb_if");
    endfunction
   
   
   
   virtual task run_phase(uvm_phase phase);
    fork
        @(posedge vif.presetn); // Wait for reset deassertion
        forever begin
            @(posedge vif.pclk);
            if (vif.psel && vif.penable && vif.presetn) begin
                apb_tr tr = apb_tr::type_id::create("tr");
                tr.addr = vif.paddr;

                if (vif.pwrite) begin
                    tr.data = vif.pwdata;
                    tr.write = 1'b1;
                    $display("MONITOR: Captured WRITE - Addr=%h, Data=%h", tr.addr, tr.data);
                end else begin
                    tr.data = vif.prdata;
                    tr.write = 1'b0;
                    $display("MONITOR: Captured READ - Addr=%h, Data=%h", tr.addr, tr.data);
                end

                // Forward the transaction
                mon_ap.write(tr);
            end
        end
    join_none
endtask


endclass
