interface apb_if (input pclk, input presetn); // presetn as input
    logic [31:0] paddr;
    logic [31:0] pwdata;
    logic [31:0] prdata;
    logic pwrite;
    logic psel;
    logic penable;
    logic pready;   // If pready is used
endinterface