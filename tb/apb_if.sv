interface apb_if (input pclk, input presetn); // presetn as input
    logic [31:0] paddr;
    logic [31:0] pwdata;
    logic [31:0] prdata;
    logic pwrite;
    logic psel;
    logic penable;
    logic pready;   // If pready is used
  	logic pslverr;
  // Assertion: pslverr should be asserted for invalid addresses
property invalid_address_check;
    @(posedge pclk) (paddr inside {0, 4, 8}) or pslverr == 1'b1;
endproperty

assert property (invalid_address_check) 
else $error("Invalid address detected !");



endinterface