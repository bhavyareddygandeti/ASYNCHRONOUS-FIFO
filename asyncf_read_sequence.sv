//-------------------------------------------------------------------------
//----------ASYNCHRONOUS FIFO READ SEQUENCE - random stimulus-------------
//-------------------------------------------------------------------------

class asyncf_read_sequence extends uvm_sequence #(asyncf_read_sequence_item);
   
   `uvm_object_utils(asyncf_read_sequence)
   
   //------------------------------------------------------
   //------------Constructor
   //------------------------------------------------------
   function  new(string name= "asyncf_read_sequence");
      super.new(name);
   endfunction
  
   function void build_phase(uvm_phase phase);
     `uvm_info("READ_sequence","enter into the down_sequence",UVM_MEDIUM)
   endfunction
  
   //------------------------------------------------------
   //create, randomize and send the item to driver
   //------------------------------------------------------
   virtual task body();
      asyncf_read_sequence_item req;
      repeat(2) begin 
        `uvm_do(req)
      end
   endtask
  

endclass

//------------------------------------------------------
// READ_sequence - "Read" type
//------------------------------------------------------
class asyncf_rd_sequence extends uvm_sequence #(asyncf_read_sequence_item);
  
  
  `uvm_object_utils(asyncf_rd_sequence)
  
  //------------------------------------------------------
  //------------Constructor
  //------------------------------------------------------
  function  new(string name= "asyncf_rd_sequence");
    super.new(name);
  endfunction
  
  
  virtual task body();
    asyncf_read_sequence_item req;
    for (int i=0; i<1000; i++) begin
    `uvm_do_with(req,{req.rinc == 1;  req.R_Burst_ID == i;})
    end
  endtask
  
endclass

//------------------------------------------------------
// WRITE_READ_sequence - Write followed by Read
//------------------------------------------------------
class asyncf_wr_rd_sequence extends uvm_sequence /*#(asyncf_read_sequence_item)*/;
  
  
  `uvm_object_utils(asyncf_wr_rd_sequence)
  
  asyncf_write_sequence w_seq;
  asyncf_read_sequence r_seq;
  
  //------------------------------------------------------
  //------------Constructor
  //------------------------------------------------------
  function  new(string name= "asyncf_wr_rd_sequence");
    super.new(name);
  endfunction
  
  
  virtual task body();    
    `uvm_do(w_seq)
    `uvm_do(r_seq)
  endtask
  
endclass