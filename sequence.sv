class apb_sequence extends uvm_sequence #(apb_packet);
  
  `uvm_object_utils(apb_sequence)
  
  function new(string name="apb_sequence");
    super.new(name);
  endfunction
  
  task body();
   `uvm_info(get_type_name,"sequence class:inside body",UVM_LOW)
    req=apb_packet::type_id::create("req");
    wait_for_grant();
    assert(req.randomize());
    req.print();
    send_request(req);
    
  endtask
  
endclass