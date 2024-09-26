class apb_environment extends uvm_env;
  `uvm_component_utils(apb_environment);
  
  apb_agent agnt;
  apb_scoreboard scb;
  
   
  function new(string name="apb_environment",uvm_component parent);
    super.new(name,parent);    
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnt=apb_agent::type_id::create("agnt",this);
    scb=apb_scoreboard::type_id::create("scb",this);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    agnt.mon.item_collect_port.connect(scb.item_collect_export);    
  endfunction
  
  
endclass