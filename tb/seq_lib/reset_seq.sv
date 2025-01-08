class reset_seq extends uvm_sequence;
    `uvm_object_utils(reset_seq)

    function new(string name = "reset_seq");
        super.new(name);
    endfunction

    virtual apb_if vif;

    task body();
        if (!uvm_config_db #(virtual apb_if)::get(null, "uvm_test_top.*", "apb_if", vif)) begin
            `uvm_fatal("VIF", "No vif found in configuration database!");
        end

        `uvm_info("RESET", "Waiting for reset to be deasserted...", UVM_MEDIUM);

        // Wait for reset deassertion
        @(posedge vif.presetn);
        `uvm_info("RESET", "Reset deasserted. Proceeding with test.", UVM_MEDIUM);
    endtask
endclass
