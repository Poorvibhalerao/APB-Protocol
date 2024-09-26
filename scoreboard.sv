class apb_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(apb_scoreboard)
  
  uvm_analysis_imp#(apb_packet, apb_scoreboard) item_collect_export;
  
  apb_packet exp_queue[$];
  
  bit [31:0] sc_mem [3:0];
  
  function new(string name="apb_scoreboard", uvm_component parent);
    super.new(name,parent);
    item_collect_export = new("item_collect_export", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    foreach(sc_mem[i]) sc_mem[i] = i;
  endfunction
  
  // write task - recives the pkt from monitor and pushes into queue
  function void write(apb_packet tr);
    //tr.print();
    exp_queue.push_back(tr);
  endfunction 
  
  virtual task run_phase(uvm_phase phase);
    //super.run_phase(phase);
    apb_packet expdata;
    
    forever begin
      wait(exp_queue.size() > 0);
      expdata = exp_queue.pop_front();
      
      if(expdata.r_w == apb_packet::WRITE) begin
        sc_mem[expdata.paddr] = expdata.pwdata;
        `uvm_info("APB_SCOREBOARD",$sformatf("------ :: WRITE DATA       :: ------"),UVM_LOW)
        `uvm_info("",$sformatf("Addr: %0h",expdata.paddr),UVM_LOW)
        `uvm_info("",$sformatf("Data: %0h",expdata.pwdata),UVM_LOW)        
      end
      else if(expdata.r_w == apb_packet::READ) begin
        if(sc_mem[expdata.paddr] == expdata.prdata) begin
          `uvm_info("APB_SCOREBOARD",$sformatf("------ :: READ DATA Match :: ------"),UVM_LOW)
          `uvm_info("",$sformatf("Addr: %0h",expdata.paddr),UVM_LOW)
          `uvm_info("",$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[expdata.paddr],expdata.prdata),UVM_LOW)
        end
        else begin
          `uvm_error("APB_SCOREBOARD","------ :: READ DATA MisMatch :: ------")
          `uvm_info("",$sformatf("Addr: %0h",expdata.paddr),UVM_LOW)
          `uvm_info("",$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[expdata.paddr],expdata.prdata),UVM_LOW)
        end
      end
    end
  endtask 
  
endclass