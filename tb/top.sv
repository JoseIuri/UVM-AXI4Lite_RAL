 module top;
  import uvm_pkg::*;
 // import my_pkg::*;
  
  parameter min_cover = 70;
  parameter min_transa = 2000;
  bit pclk;
  bit presetn;
  
  always #10 pclk = ~pclk;


    initial begin
        presetn = 0;  // Assert reset
        #50 presetn = 1;  // Deassert reset after 50 time units
    end

  apb_if   apb_if (pclk, presetn);

  traffic  pB0 (.pclk    (apb_if.pclk),
                .presetn (apb_if.presetn),
                .paddr   (apb_if.paddr),
                .pwdata  (apb_if.pwdata),
                .prdata  (apb_if.prdata),
                .psel    (apb_if.psel),
                .pwrite  (apb_if.pwrite),
                .pready  (apb_if.pready),
                .penable (apb_if.penable),
                .pslverr(apb_if.pslverr));

  initial begin 
    
    `ifdef XCELIUM
       $recordvars();
    `endif
    `ifdef VCS
    //   $vcdpluson;
    `endif
    `ifdef QUESTA
       $wlfdumpvars();
       set_config_int("*", "recording_detail", 1);
    `endif
    
    uvm_config_db #(virtual apb_if)::set (null, "uvm_test_top.*", "apb_if", apb_if);
    run_test ("reg_rw_test");
    
  end
   initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #10000;
    $finish();
  end
    
    
    initial begin
    $coverage_control("all", "on");
    $coverage_save("fcover.acdb");
    $display("Functional Coverage saved to fcover.acdb");
end
endmodule