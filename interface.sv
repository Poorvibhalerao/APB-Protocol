interface apb_inf(input logic clk, input logic preset);
  
  logic [31:0] paddr;
  logic [31:0] pwdata;
  logic pwrite;
  logic psel;
  logic penable;
  logic pready;
  logic [31:0] prdata;
  
  clocking cb_drv @(posedge clk);
    output paddr;
    output pwdata;
    output pwrite;
    output psel;
    output penable;
    input  pready;
  endclocking
  
  clocking cb_mon @(posedge clk);
    input paddr;
    input pwdata;
    input pwrite;
    input psel;
    input penable;
    input pready;  
    input prdata;
  endclocking 
  
  
endinterface