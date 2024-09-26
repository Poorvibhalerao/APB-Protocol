
`include "uvm_macros.svh"
`include "my_pkg.svh"
`include "interface.sv"

module top;
  
  import uvm_pkg::*;
  import my_pkg::*; 
  
  bit clk;
  bit preset;
  
  always #2 clk <= ~clk;
  
  initial begin
    preset=1;
    #5 preset=0;
  end
  
  apb_inf vif(clk,preset);
  
  APB_slave dut(.PCLK(vif.clk),.PRESETn(vif.preset),.PSEL(vif.psel),.PWRITE(vif.pwrite),.PENABLE(vif.penable),.PADDR(vif.paddr),.PWDATA(vif.pwdata),.PRDATA(vif.prdata),.PREADY(vif.pready));
  
   initial 
    begin 
 
      uvm_config_db#(virtual apb_inf)::set(uvm_root::get(), "*", "vif", vif); 

	$dumpfile("dump.vcd"); 
    $dumpvars(0); 
	end 
  
initial 
  begin 
    run_test("apb_test");  
  end 
  
  
endmodule
  
 
