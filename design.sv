
module APB_slave(
  
  input PCLK, PRESETn,
  input PSEL, PWRITE, PENABLE,
  
  input [31:0] PADDR,
  input [31:0] PWDATA,
  
  output reg [31:0] PRDATA,
  
  output reg PREADY=0 );
  
  reg [31:0] slave_mem [3:0];
  
  reg [2:0] present_state;
  reg [2:0] next_state;
  
  parameter IDLE = 2'b01;
  parameter SETUP = 2'b10;
  parameter ACCESS = 2'b11;
  
  always@(posedge PCLK or PRESETn) begin
    if(!PRESETn)
      present_state <= IDLE;
    else
      present_state <= next_state;
  end
  
  always@(present_state,PSEL,PENABLE,PREADY) begin

    case(present_state)
      
      IDLE : begin
        if(PSEL == 1 && PENABLE == 0 && PRESETn == 1) begin
          next_state = SETUP;
        end else
          next_state = IDLE;
      end
      
      SETUP: begin
        if(PSEL == 1 && PENABLE == 1 && PRESETn == 1 ) begin
          next_state = ACCESS;
        end else
          next_state = IDLE;
      end
      
      ACCESS : begin //
        
        if(PREADY == 1) begin
          if(PWRITE == 1)
            slave_mem[PADDR] = PWDATA;
          else
            PRDATA = slave_mem[PADDR];
          if(PSEL == 0)
            next_state = IDLE;
          else
            next_state = SETUP;
        end
        
        else
          next_state = ACCESS;

      end  //
      
      default : next_state = IDLE;
      
    endcase
  end
  
  
  always@(next_state) begin
    if(PSEL == 1 && PENABLE == 1 && PRESETn == 1 ) begin
      PREADY = 1; 
    end
    if(PREADY == 1)
      @(posedge PCLK) PREADY = 0;
  end
  
endmodule
      
     
