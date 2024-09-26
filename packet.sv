
class apb_packet extends uvm_sequence_item;
  
  typedef enum {READ , WRITE} read_write;
  rand bit [31:0] paddr;
  rand logic [31:0] pwdata;
  rand read_write r_w;
  logic psel;
  logic penable;
  logic [31:0] prdata;
  logic pready;
  
  `uvm_object_utils_begin(apb_packet)
  	`uvm_field_int(paddr,UVM_ALL_ON)
  	`uvm_field_int(pwdata,UVM_ALL_ON)
  `uvm_field_enum(read_write,r_w,UVM_ALL_ON)
    `uvm_field_int(psel,UVM_ALL_ON)
    `uvm_field_int(penable,UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name="apb_packet");
    super.new(name);
  endfunction
  
      
endclass