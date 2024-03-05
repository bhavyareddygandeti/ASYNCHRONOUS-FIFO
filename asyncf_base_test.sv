//-------------------------------------------------------------
//----------ASYNCHRONOUS FIFO BASE TEST------------------------
//-------------------------------------------------------------


class asyncf_base_test extends uvm_test;

   `uvm_component_utils(asyncf_base_test)
  
   //-------------------------------------------------------------
   //environment instance
   //-------------------------------------------------------------
   asyncf_environment env;
   
   //------------------------------------------------------
   //------------Constructor
   //------------------------------------------------------
   function new(string name = "asyncf_base_test", uvm_component parent = null);
      super.new(name,parent);
   endfunction
   
   //------------------------------------------------------
   //------------Build Phase
   //------------------------------------------------------
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
     
      // create the env
      env  =  asyncf_environment::type_id::create("env", this);
   endfunction
  
   //------------------------------------------------------
   //------------Report Phase
   //------------------------------------------------------
  function void end_of_elaboration();
       uvm_top.print_topology();
  endfunction
  
   //------------------------------------------------------
   //------------Report Phase
   //------------------------------------------------------
   function void report_phase(uvm_phase phase);
      uvm_report_server svr;
      super.report_phase(phase);

      svr = uvm_report_server::get_server();
      if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
         `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      end
      else begin
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
         `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      end
   endfunction
   
endclass


class asyncf_write_test extends asyncf_base_test;

   `uvm_component_utils(asyncf_write_test)
  
   //-------------------------------------------------------------
   // sequence instance
   //-------------------------------------------------------------
   asyncf_wr_sequence w_seq;
  
   //------------------------------------------------------
   //------------Constructor
   //------------------------------------------------------
   function new(string name = "asyncf_write_test", uvm_component parent = null);
      super.new(name,parent);
   endfunction
  
   //------------------------------------------------------
   //------------Build Phase
   //------------------------------------------------------
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      w_seq = asyncf_wr_sequence::type_id::create("w_seq");
   endfunction
  
   //------------------------------------------------------
   //------------Run Phase - starting the test
   //------------------------------------------------------
   task run_phase(uvm_phase phase); 
     phase.raise_objection(this);
     w_seq.start(env.wr_agnt.sqr);
     phase.drop_objection(this);
     phase.phase_done.set_drain_time(this, 50);
   endtask

endclass


//-------------------------------------------------------------
//----------ASYNCHRONOUS FIFO READ TEST------------------------
//-------------------------------------------------------------
class asyncf_read_test extends asyncf_base_test;

  `uvm_component_utils(asyncf_read_test)
  
   //-------------------------------------------------------------
   // sequence instance
   //-------------------------------------------------------------
   asyncf_rd_sequence r_seq;
  
   //------------------------------------------------------
   //------------Constructor
   //------------------------------------------------------
  function new(string name = "asyncf_read_test", uvm_component parent = null);
      super.new(name,parent);
   endfunction
  
   //------------------------------------------------------
   //------------Build Phase
   //------------------------------------------------------
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
     r_seq = asyncf_rd_sequence::type_id::create("r_seq");
   endfunction
  
   //------------------------------------------------------
   //------------Run Phase - starting the test
   //------------------------------------------------------
   task run_phase(uvm_phase phase); 
     phase.raise_objection(this);
     r_seq.start(env.rd_agnt.sqr);
     phase.drop_objection(this);
     phase.phase_done.set_drain_time(this, 50);
   endtask

endclass

//-------------------------------------------------------------
//----------ASYNCHRONOUS FIFO WRITE READ TEST -  write followed by read
//-------------------------------------------------------------
class asyncf_write_read_test extends asyncf_base_test;

  `uvm_component_utils(asyncf_write_read_test)
  
   //-------------------------------------------------------------
   // sequence instance
   //-------------------------------------------------------------
   asyncf_wr_sequence w_seq;
   asyncf_rd_sequence r_seq;
  
   //------------------------------------------------------
   //------------Constructor
   //------------------------------------------------------
  function new(string name = "asyncf_write_read_test", uvm_component parent = null);
      super.new(name,parent);
   endfunction
  
   //------------------------------------------------------
   //------------Build Phase
   //------------------------------------------------------
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
     w_seq = asyncf_wr_sequence::type_id::create("w_seq");
     r_seq = asyncf_rd_sequence::type_id::create("r_seq");
   endfunction
  
   //------------------------------------------------------
   //------------Run Phase - starting the test
   //------------------------------------------------------
   task run_phase(uvm_phase phase); 
     phase.raise_objection(this);
     w_seq.start(env.wr_agnt.sqr);
     r_seq.start(env.rd_agnt.sqr);
     phase.drop_objection(this);
     phase.phase_done.set_drain_time(this, 100);
   endtask

endclass

//-------------------------------------------------------------
//----------ASYNCHRONOUS FIFO WRITE READ TEST -  write followed by read
//-------------------------------------------------------------
class asyncf_write_read_parallel_test extends asyncf_base_test;

  `uvm_component_utils(asyncf_write_read_parallel_test)
  
   //-------------------------------------------------------------
   // sequence instance
   //-------------------------------------------------------------
   asyncf_wr_sequence w_seq;
   asyncf_rd_sequence r_seq;
  
   //------------------------------------------------------
   //------------Constructor
   //------------------------------------------------------
  function new(string name = "asyncf_write_read_parallel_test", uvm_component parent = null);
      super.new(name,parent);
   endfunction
  
   //------------------------------------------------------
   //------------Build Phase
   //------------------------------------------------------
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
     w_seq = asyncf_wr_sequence::type_id::create("w_seq");
     r_seq = asyncf_rd_sequence::type_id::create("r_seq");
   endfunction
  
   //------------------------------------------------------
   //------------Run Phase - starting the test
   //------------------------------------------------------
   task run_phase(uvm_phase phase); 
     phase.raise_objection(this);
     fork
     w_seq.start(env.wr_agnt.sqr);
     r_seq.start(env.rd_agnt.sqr);
     join
     phase.drop_objection(this);
     phase.phase_done.set_drain_time(this, 100);
   endtask

endclass




