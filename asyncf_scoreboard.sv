`uvm_analysis_imp_decl(_WRITE)
`uvm_analysis_imp_decl(_READ)

class asyncf_scoreboard extends uvm_scoreboard;
  
   `uvm_component_utils(asyncf_scoreboard)
   
  bit [8-1:0] sc_mem[$];
   bit[7:0] exp_rdata;

  uvm_analysis_imp_WRITE #(asyncf_write_sequence_item, asyncf_scoreboard) write_item_collected_export;
  uvm_analysis_imp_READ #(asyncf_read_sequence_item, asyncf_scoreboard) read_item_collected_export;
   
   function new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction 

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      write_item_collected_export = new("write_item_collected_export", this);
      read_item_collected_export = new("read_item_collected_export", this);
   endfunction 

  virtual function void write_WRITE(asyncf_write_sequence_item wr_pkt);
      if(wr_pkt.wfull == 1'b0) begin
      sc_mem.push_front(wr_pkt.data);
        `uvm_info(get_type_name(),$sformatf("Received wdata: wr_pkt.wdata: %0h", wr_pkt.data),UVM_LOW)
      end
   endfunction

  virtual function void write_READ(asyncf_read_sequence_item rd_pkt);
      if(rd_pkt.rempty == 1'b0) begin
      exp_rdata = sc_mem.pop_back();

      if(exp_rdata == rd_pkt.data) begin
      `uvm_info(get_type_name(),$sformatf("data match"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("exp_rdata: %0h, received_rdata: %0h", exp_rdata, rd_pkt.data),UVM_LOW)
      end else begin
      `uvm_error(get_type_name(),$sformatf("data mismatch"))
        `uvm_error(get_type_name(),$sformatf("exp_rdata: %0h, received_rdata: %0h", exp_rdata, rd_pkt.data))
      end
      end
   endfunction

endclass 

