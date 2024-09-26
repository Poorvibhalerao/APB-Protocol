class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)
  
  apb_environment env;
  apb_sequence seq;
  
  function new(string name="apb_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    env=apb_environment::type_id::create("env",this);
    seq=apb_sequence::type_id::create("seq");    
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
        seq.start(env.agnt.seqncr);  
    #30;
        phase.drop_objection(this);
    `uvm_info(get_type_name,"end of test case",UVM_NONE)    
  endtask
  
endclass