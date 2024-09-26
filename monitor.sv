class apb_monitor extends uvm_monitor;
  
  uvm_analysis_port #(apb_packet) item_collect_port;
  `uvm_component_utils(apb_monitor)
  virtual apb_inf vif_m;
  apb_packet mon_item;
  
  function new(string name="apb_monitor",uvm_component parent);
    super.new(name,parent); 
    item_collect_port=new("item_collect_port",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR CLASS","BUILD PHASE",UVM_NONE); 
           
    if(!uvm_config_db#(virtual apb_inf)::get(this," ","vif",vif_m))
      `uvm_fatal(get_full_name(),$sformatf("virtual interface is not obtained"))
    else
      `uvm_info("BUILD_PHASE_OF_MONITOR",$sformatf("virtual interface is obtained"),UVM_LOW)
                                                                  
  endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name,"start of run phase:monitor class",UVM_MEDIUM)
    wait(vif_m.cb_mon.psel == 1'b1)
    mon_item= apb_packet::type_id::create("mon_item");
    mon_item.r_w=(this.vif_m.cb_mon.pwrite)? apb_packet::WRITE : apb_packet::READ;
    mon_item.paddr=this.vif_m.cb_mon.paddr;
    
    @(posedge vif_m.clk);
    wait(this.vif_m.cb_mon.penable==1'b1 && this.vif_m.cb_mon.pready==1'b1);
    
    if(this.vif_m.cb_mon.pwrite)
      mon_item.pwdata = vif_m.cb_mon.pwdata;
    else
      mon_item.prdata = vif_m.cb_mon.prdata;
    
    wait(this.vif_m.cb_mon.penable==1'b0);
    `uvm_info(get_type_name,$sformatf("psel=%0d,pwrite=%0d,paddr=%0d,penable=%0d,pready=%0d,pwdata=%0d,prdata=%0d",mon_item.psel,mon_item.r_w,mon_item.paddr,mon_item.penable,mon_item.pready,mon_item.pwdata,mon_item.prdata), UVM_NONE);
    
    item_collect_port.write(mon_item);
    
    
    endtask  
endclass