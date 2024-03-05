 //------------------------------------------------------
//----------ASYNCHRONOUS FIFO WRITE MONITOR-------------
//------------------------------------------------------

class asyncf_write_monitor extends uvm_monitor;

   virtual write_if wr_if;
  
  uvm_analysis_port #(asyncf_write_sequence_item) item_collected_port;
  uvm_analysis_port #(asyncf_write_sequence_item) write_cov_port;

   `uvm_component_utils(asyncf_write_monitor)
  
   //------------------------------------------------------
   //------------Constructor
   //------------------------------------------------------
   function new(string name = "asyncf_write_monitor", uvm_component parent);
      super.new(name, parent);
   endfunction
   
   //------------------------------------------------------
   //------------Build Phase
   //------------------------------------------------------
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
     if(!uvm_config_db#(virtual write_if)::get(this, "", "wr_if", wr_if))
         `uvm_fatal("asyncf_up_mornitor", "virtual interface must be set for up_if!!!")
       item_collected_port = new("item_collected_port", this);
       write_cov_port = new("write_cov_port", this);
   endfunction

   virtual task run_phase(uvm_phase phase);
   asyncf_write_sequence_item req;
   while(1) begin
     req = new("req");
     collect_one_pkt(req);
     item_collected_port.write(req);
     write_cov_port.write(req);
   end
endtask
  task collect_one_pkt(asyncf_write_sequence_item tr);
   
   while(1) begin
     @(posedge wr_if.wclk);
      if(wr_if.winc) break;
   end
   
   tr.data = wr_if.wdata;
   tr.winc = wr_if.winc;
   tr.wfull = wr_if.wfull;
   tr.W_Burst_ID = wr_if.W_Burst_ID;
    `uvm_info(get_type_name(),$sformatf("tr.W_Burst_ID: %0h, tr.winc: %0h, tr.data: %0h",tr.W_Burst_ID, tr.winc, tr.data),UVM_LOW)
   //@(posedge wr_if.wclk);
endtask
     
endclass


