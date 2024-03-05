//------------------------------------------------------
//----------ASYNCHRONOUS FIFO INTERFACE-----------------
//------------------------------------------------------

//write interface
interface write_if(input wclk, input wrst_n);
   logic [8-1:0] wdata;
   logic winc;
   logic wfull;
   int W_Burst_ID;
endinterface


//Read Interface
interface read_if(input rclk, input rrst_n);
   logic [8-1:0] rdata;
   logic rinc;
   logic rempty;
  int R_Burst_ID;
endinterface

