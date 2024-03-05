 //------------------------------------------------------
//----------ASYNCHRONOUS FIFO READ MONITOR---------------
//-------------------------------------------------------

class asyncf_read_monitor extends uvm_monitor;

   virtual read_if rd_if;
  
  uvm_analysis_port #(asyncf_read_sequence_item) item_collected_port;
  uvm_analysis_port #(asyncf_read_sequence_item) read_cov_port;

   `uvm_component_utils(asyncf_read_monitor)
  
   //------------------------------------------------------
   //------------Constructor
   //------------------------------------------------------
   function new(string name = "asyncf_read_monitor", uvm_component parent);
      super.new(name, parent);
   endfunction
  
   //------------------------------------------------------
   //------------Build Phase
   //------------------------------------------------------
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
     if(!uvm_config_db#(virtual read_if)::get(this, "", "rd_if", rd_if))
         `uvm_fatal("asyncf_down_mornitor", "virtual interface must be set for down_if!!!")
      item_collected_port = new("item_collected_port", this);
      read_cov_port = new("read_cov_port",this);
   endfunction

     virtual task run_phase(uvm_phase phase);
       asyncf_read_sequence_item req;
       while(1) begin
         req = new("req");
         collect_one_pkt(req);
         item_collected_port.write(req);
         read_cov_port.write(req);
       end
     endtask
     
   task collect_one_pkt(asyncf_read_sequence_item tr);
     while(1) begin
       @(posedge rd_if.rclk);
       //tr.rinc = r_intf.rinc;
      if(rd_if.rinc)
        break;
   end

      tr.data = rd_if.rdata;
      tr.rinc = rd_if.rinc;
      tr.rempty = rd_if.rempty;
      tr.R_Burst_ID = rd_if.R_Burst_ID;
     `uvm_info(get_type_name(),$sformatf(" tr.R_Burst_ID: %0h tr.rinc: %0h, tr.data: %0h, tr.rempty: %0h",tr.R_Burst_ID, tr.rinc, tr.data, tr.rempty),UVM_LOW)
  // @(posedge rd_if.rclk);
endtask
     

endclass


