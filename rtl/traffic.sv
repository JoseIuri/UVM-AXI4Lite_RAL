module traffic (  input          pclk,
                  input          presetn,
                  input [31:0]   paddr,
                  input [31:0]   pwdata,
                  input          psel,
                  input          pwrite,
                  input          penable,
 
                  // Outputs
                  output reg pready, pslverr,
                  output [31:0]  prdata);
 
   reg [3:0]      ctl_reg;    // profile, blink_red, blink_yellow, mod_en RW
   reg [1:0]      stat_reg;   // state[1:0] 
   reg [31:0]     timer_0;    // timer_g2y[31:20], timer_r2g[19:8], timer_y2r[7:0] RW
   reg [31:0]     timer_1;    // timer_g2y[31:20], timer_r2g[19:8], timer_y2r[7:0] RW
 
   reg [31:0]     data_in;
   reg [31:0]     rdata_tmp;
   typedef enum {idle = 0, setup = 1, access = 2, transfer = 3} state_type;
   state_type state = idle, next_state = idle;
   // Set all registers to default values
   always @ (posedge pclk) begin
      if (!presetn) begin
         state <=idle;
         prdata <=32'h00000000;
         pready <= 1'b0;
         pslverr<= 1'b0;
         data_in <= 0;
         ctl_reg  <= 0; 
         stat_reg <= 0; 
         timer_0  <= 32'hcafe_1234; 
         timer_1  <= 32'hface_5678;
      end
      else
      begin
         case (state)
         idle: 
         begin
            
            prdata <=32'h00000000;
            pready <= 1'b0;
            pslverr<= 1'b0;
            data_in <= 0;
            ctl_reg  <= 0; 
            stat_reg <= 0; 
            timer_0  <= 32'hcafe_1234; 
            timer_1  <= 32'hface_5678;
            if (psel == 1'b0) && (penable == 1'b0)
            state<=setup;
         end


         setup:
         begin
            if ((psel == 1'b1) && (penable == 1'b0)) begin
               if(paddr<32) begin
                  state<=access;
                  pready<=1'b1;
            end
            else begin
               state <=access;
               pready<=1'b0;
            end

            else
            state<= setup;
            end


         end

         access:
         begin
            if (psel && pwrite && penable)
            begin
               if(paddr<32)
                begin
               case (paddr)
               'h0   : ctl_reg <= pwdata;
               'h4   : timer_0 <= pwdata;
               'h8   : timer_1 <= pwdata;
               'hc   : stat_reg <= pwdata;
                endcase
                state <= transfer;
                pslverr<=1'b0;

                end
               else
               begin
                 state <= transfer;
                  pready <= 1'b1;
                  pslverr <= 1'b1;

               end

               else if (psel && penable && !pwrite)

               begin
                  if (paddr<32)
                  begin
                 case (paddr )
                'h0 : rdata_tmp <= ctl_reg;
                  'h4 : rdata_tmp <= timer_0;
                 'h8 : rdata_tmp <= timer_1;
                'hc : rdata_tmp <= stat_reg;
                  endcase
                  state <= transfer;
                 pready <= 1'b1;
                pslverr <= 1'b0;
                  end
                  else
                  begin
                     state <= transfer;
                     pready <= 1'b1;
                     pslverr <= 1'b1;
                     prdata <= 32'hxxxxxxxx;
                  end

               end


            end

         end

         transfer:
         begin
         end
         default: state<=idle;

         endcase
         assign prdata = (psel & penable & !pwrite) ? rdata_tmp : 'hz;
      end

   end

 
  
 
endmodule