//------------------------------------------------------
//----------ASYNCHRONOUS FIFO Coverages--------------
//------------------------------------------------------

class asyncf_write_coverage extends uvm_subscriber#(asyncf_write_sequence_item);
  asyncf_write_sequence_item write_item;
  asyncf_write_sequence_item write_item_queue[$];

  `uvm_component_utils(asyncf_write_coverage)
  
  uvm_analysis_imp#(asyncf_write_sequence_item,asyncf_write_coverage) import_wr;
  
  covergroup asyncf_write_cg;
    option.per_instance = 1;
    
    write_data_cp : coverpoint write_item.data{
      bins min = {'0};
      bins max = {'1};
      bins data_1[] = {[0:255]};
    }
    
    write_winc_cp : coverpoint write_item.winc{
      bins winc_low = {1'b0};
      ignore_bins winc_High = {1'b1};
    }
    
    write_full_cp : coverpoint write_item.wfull{
      bins full_low = {1'b0};
      ignore_bins full_High = {1'b1};
    }
  endgroup  
  
  //------------------------------------------------------
  //------------Constructor
  //------------------------------------------------------
  function new(string name = "asyncf_write_coverage", uvm_component parent);
    super.new(name, parent);
    asyncf_write_cg = new();
  endfunction
   
  //------------------------------------------------------
  //------------Build Phase
  //------------------------------------------------------
  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    import_wr = new("import_wr",this);      
  endfunction: build_phase
  
   function void write (asyncf_write_sequence_item t);
        write_item_queue.push_front(t);
    endfunction :write

  //------------------------------------------------------
  //------------Run Phase
  //------------------------------------------------------
	task run_phase (uvm_phase phase);
        //super.run_phase(phase);    
       `uvm_info(get_type_name(), "Inside Run Phase!", UVM_HIGH)
        forever begin
          write_item = asyncf_write_sequence_item::type_id::create("write_item",this);
          wait(write_item_queue.size!=0);
	     	write_item  = write_item_queue.pop_back();
	    asyncf_write_cg.sample();  
        end 
    endtask 
endclass

//------------------------------------------------------
//----------ASYNCHRONOUS FIFO Coverages--------------
//------------------------------------------------------

class asyncf_read_coverage extends uvm_subscriber#(asyncf_read_sequence_item);
  asyncf_read_sequence_item read_item;
  asyncf_read_sequence_item read_item_queue[$];

  `uvm_component_utils(asyncf_read_coverage)
  
  uvm_analysis_imp#(asyncf_read_sequence_item,asyncf_read_coverage) import_rd;
  
  covergroup asyncf_read_cg;
    option.per_instance = 1;
    
    read_data_cp : coverpoint read_item.data{
      bins min = {'0};
      bins max = {'1};
      bins data_1[] = {[0:255]};
    }
    
    read_rinc_cp : coverpoint read_item.rinc{
      ignore_bins rinc_low = {1'b0};
      bins rinc_High = {1'b1};
    }
    
    read_empty_cp : coverpoint read_item.rempty{
      bins empty_low = {1'b0};
      bins empty_High = {1'b1};
    }
  endgroup  
  
  //------------------------------------------------------
  //------------Constructor
  //------------------------------------------------------
  function new(string name = "asyncf_read_coverage", uvm_component parent);
    super.new(name, parent);
    asyncf_read_cg = new();
  endfunction
   
  //------------------------------------------------------
  //------------Build Phase
  //------------------------------------------------------
  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    import_rd = new("import_rd",this);      
  endfunction: build_phase
  
   function void write (asyncf_read_sequence_item t);
        read_item_queue.push_front(t);
    endfunction :write

  //------------------------------------------------------
  //------------Run Phase
  //------------------------------------------------------
	task run_phase (uvm_phase phase);
        //super.run_phase(phase);    
       `uvm_info(get_type_name(), "Inside Run Phase!", UVM_HIGH)
        forever begin
          read_item = asyncf_read_sequence_item::type_id::create("read_item",this);
          wait(read_item_queue.size!=0);
	     	read_item  = read_item_queue.pop_back();
	    asyncf_read_cg.sample();  
        end 
    endtask 
endclass


