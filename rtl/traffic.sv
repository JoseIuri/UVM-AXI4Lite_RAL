module traffic (
    input          pclk,
    input          presetn,
    input [31:0]   paddr,
    input [31:0]   pwdata,
    input          psel,
    input          pwrite,
    input          penable,
    output reg     pready,
    output reg     pslverr,
    output reg [31:0] prdata
);

    // Internal registers
    reg [3:0] ctl_reg;    
    reg [31:0] timer_0;   
    reg [31:0] timer_1;   

    typedef enum logic [1:0] { IDLE, SETUP, ACCESS, TRANSFER } state_t;
    state_t state;

    // Reset and initialization
    always @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            // Reset all internal states and registers
            state <= IDLE;
            ctl_reg <= 4'b0;
            timer_0 <= 32'hcafe1234;
            timer_1 <= 32'hface5678;
            prdata <= 32'h0;
            pready <= 1'b0;
            pslverr <= 1'b0;
            $display("RESET: Registers reset to default values");
        end else begin
            case (state)
                IDLE: begin
                    pready <= 1'b0; // Ensure pready is deasserted
                    if (psel && !penable) begin
                        state <= SETUP;
                        $display("IDLE: Detected psel, moving to SETUP");
                    end
                end

                SETUP: begin
                    if (psel && penable) begin
                        state <= ACCESS;
                        $display("SETUP: Detected penable, moving to ACCESS");
                    end
                end              
      ACCESS: begin
        if (psel && penable && (paddr<32)) begin
      if (pwrite) begin
            // Write operation
            case (paddr)
                32'h0: ctl_reg <= pwdata[3:0];
                32'h4: timer_0 <= pwdata;
                32'h8: timer_1 <= pwdata;
                default: pslverr <= 1'b1;
            endcase
            $display("DUT WRITE: Addr=%h, Data=%h", paddr, pwdata);
        end else begin
            // Read operation
            case (paddr)
                32'h0: prdata <= {28'b0, ctl_reg};
                32'h4: prdata <= timer_0;
                32'h8: prdata <= timer_1;
                default: prdata <= 32'hDEADBEEF;
            endcase
            $display("DUT READ: Addr=%h, Data=%h", paddr, prdata);
        end
        pready <= 1'b1; // Indicate transaction completion
        state <= TRANSFER; // Move to the next state
    end else begin
        pready <= 1'b0; // Ensure pready is low if not in a valid transaction
    end  
      end
TRANSFER: begin
    pready <= 1'b0; // Deassert pready after the transaction
    state <= IDLE;  // Return to IDLE for the next transaction
    $display("TRANSFER: Transaction done, returning to IDLE");
end
            endcase
        end
    end
endmodule