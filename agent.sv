class apb_agent extends uvm_agent;
  
  `uvm_component_utils(apb_agent);
  apb_sequencer seqncr;
  apb_monitor mon;
  apb_driver driv;
  
  function new(string name="apb_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqncr=apb_sequencer::type_id::create("seqncr",this);
    mon=apb_monitor::type_id::create("mon",this);
    driv=apb_driver::type_id::create("driv",this);
    
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT CLASS","CONNECT PHASE",UVM_NONE);
    if(get_is_active == UVM_ACTIVE)
      begin
        driv.seq_item_port.connect(seqncr.seq_item_export); 
      end
  endfunction
  
endclass