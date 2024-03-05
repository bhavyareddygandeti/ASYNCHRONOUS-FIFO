//-------------------------------------------------------------
//----------ASYNCHRONOUS FIFO ENVIRONMENT----------------------
//-------------------------------------------------------------


class asyncf_environment extends uvm_env;

   //-----------------------------------------
   //agent and scoreboard instances
   //-----------------------------------------
   asyncf_write_agent              wr_agnt;
   asyncf_read_agent               rd_agnt;
   asyncf_scoreboard               scoreboard;
   asyncf_write_coverage           wr_coverage;
   asyncf_read_coverage           rd_coverage;
   
   `uvm_component_utils(asyncf_environment)
   
   //------------------------------------------------------
   //------------Constructor
   //------------------------------------------------------
   function new(string name = "asyncf_environment", uvm_component parent);
      super.new(name, parent);
   endfunction: new
  
   //------------------------------------------------------
   //------------Build Phase
   //------------------------------------------------------
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      wr_agnt = asyncf_write_agent::type_id::create("wr_agnt", this);
      rd_agnt = asyncf_read_agent::type_id::create("rd_agnt", this);
      scoreboard = asyncf_scoreboard::type_id::create("scoreboard", this);
      wr_coverage = asyncf_write_coverage::type_id::create("wr_coverage", this);
      rd_coverage = asyncf_read_coverage::type_id::create("rd_coverage", this);
   endfunction
   
   //------------------------------------------------------
   //------------Connect Phase
   //------------------------------------------------------
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
     wr_agnt.mon.item_collected_port.connect(scoreboard.write_item_collected_export);
     rd_agnt.mon.item_collected_port.connect(scoreboard.read_item_collected_export);
     wr_agnt.mon.item_collected_port.connect(wr_coverage.import_wr);
     rd_agnt.mon.item_collected_port.connect(rd_coverage.import_rd);
   endfunction
endclass



