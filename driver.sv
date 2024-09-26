class apb_driver extends uvm_driver#(apb_packet);
  `uvm_component_utils(apb_driver);
  
  virtual apb_inf vif_d;
  apb_packet p1;
  
  function new(string name="apb_driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual apb_inf)::get(this," ","vif",vif_d))
      `uvm_fatal(get_full_name(),$sformatf("virtual interface is not obtained"))
    else
      `uvm_info("BUILD_PHASE_OF_DRIVER",$sformatf("virtual interface is obtained"),UVM_LOW)
  endfunction
      
  task run_phase(uvm_phase phase);
    
    super.run_phase(phase);
    init_signals();
    wait_for_reset();
    get_and_drive();
    
  endtask
    
 virtual task init_signals();
      
      vif_d.cb_drv.psel <= 1'b0;
      vif_d.cb_drv.pwrite <= 1'b0;
      vif_d.cb_drv.penable <= 1'b0;
      
  endtask
    
 virtual task wait_for_reset();
   
    wait(!vif_d.preset);
    
  endtask
    
 virtual task get_and_drive();
    
    forever begin
      p1=apb_packet::type_id::create("p1");
      seq_item_port.get_next_item(p1);
      repeat(1)
        begin
          @(posedge vif_d.clk);
          vif_d.cb_drv.psel <= 1'b1;
          vif_d.cb_drv.paddr <= p1.paddr;
          vif_d.cb_drv.pwrite <= p1.r_w;
          
          if(p1.r_w == apb_packet::WRITE)
            vif_d.cb_drv.pwdata <= p1.pwdata;
          @(posedge vif_d.clk);
          vif_d.cb_drv.penable <= 1'b1;
          p1.pready <= vif_d.cb_drv.pready;
          wait(p1.pready);
          
          @(posedge vif_d.clk);
          vif_d.cb_drv.psel <= 1'b0;
          vif_d.cb_drv.penable <= 1'b0;
          
          `uvm_info(get_type_name, $sformatf("psel=%0d,pwrite=%0d,paddr=%0d,pwdata=%0d",p1.psel,p1.r_w,p1.paddr,p1.pwdata),UVM_NONE);
          
          seq_item_port.item_done();
          
        end
      
    end
  endtask 
      
endclass