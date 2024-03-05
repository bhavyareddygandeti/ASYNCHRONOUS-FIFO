//-------------------------------------------------------------
//----------ASYNCHRONOUS FIFO TESTBENCH--------------
//-------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"

`include "asyncf_write_sequence_item.sv"
`include "asyncf_write_sequence.sv"
`include "asyncf_write_sequencer.sv"

`include "asyncf_read_sequence_item.sv"
`include "asyncf_read_sequence.sv"
`include "asyncf_read_sequencer.sv"

`include "asyncf_write_driver.sv"
`include "asyncf_write_monitor.sv"

`include "asyncf_read_driver.sv"
`include "asyncf_read_monitor.sv"


`include "asyncf_write_agent.sv"
`include "asyncf_read_agent.sv"

`include "asyncf_scoreboard.sv"
`include "asyncf_coverage.sv"

`include "asyncf_environment.sv"


`include "asyncf_base_test.sv"

//`include "asyncf_write_test.sv"
//`include "asyncf_read_test.sv"

module top;

   parameter FIFO_WIDTH = 8;
   parameter ADDR_WIDTH = 8;
  
   parameter Burst_len = 512;
   parameter WRITE_FREQ = 240000;
   parameter READ_FREQ = 400000;
  
   real write_clk_pd = ((1.0/(WRITE_FREQ * 1e3)) * 1e9);
   real read_clk_pd = ((1.0/(READ_FREQ * 1e3)) * 1e9);
  
   //------------------------------------------------------
   //clock and reset signal declaration
   //------------------------------------------------------
   bit wclk, rclk;
   bit wrst_n, rrst_n;
   
   //------------------------------------------------------
   //interface instance 
   //------------------------------------------------------
   write_if wr_intf(wclk, wrst_n);
   read_if rd_intf(rclk,rrst_n);
   
   //------------------------------------------------------
   //DUT instance 
   //------------------------------------------------------
   async_fifo #(FIFO_WIDTH, ADDR_WIDTH) DUT(
                     .rdata(rd_intf.rdata),
                     .wfull(wr_intf.wfull),
                     .rempty(rd_intf.rempty),
                     .wdata(wr_intf.wdata),
                     .winc(wr_intf.winc), 
                     .wclk(wr_intf.wclk), 
                     .wrst_n(wr_intf.wrst_n),
                     .rinc(rd_intf.rinc), 
                     .rclk(rd_intf.rclk), 
                     .rrst_n(rd_intf.rrst_n)
                );

   //------------------------------------------------------
   //clock generation
   //------------------------------------------------------
   
   initial begin
     wclk = 1'b0;
     rclk = 1'b0;

     fork
       forever #(write_clk_pd/2) wclk = ~wclk;
       forever #(read_clk_pd/2) rclk = ~rclk;
    join
   end   
   
   //------------------------------------------------------
   //Reset generation
   //------------------------------------------------------
   initial begin
     wrst_n = 1'b0;
     rrst_n = 1'b0;
     #40;
     wrst_n = 1'b1;
     rrst_n = 1'b1;
   end

   //---------------------------------------------------------------------
   // passing the interface handle to lower hierarchy using set method
   // and enabling the wave dump
   //---------------------------------------------------------------------
   initial begin
     uvm_config_db#(virtual write_if)::set(uvm_root::get(), "*", "wr_if", wr_intf);
     uvm_config_db#(virtual read_if)::set(uvm_root::get(),"*","rd_if", rd_intf);
   end

   //------------------------------------------------------
   //calling test
   //------------------------------------------------------
   initial begin    
     //fork
     //run_test("asyncf_write_test");
     //run_test("asyncf_read_test");
     //run_test("asyncf_write_read_test");
     run_test("asyncf_write_read_parallel_test");
     //join
   end 
  
  initial begin
    $dumpfile("abc.vcd");
    $dumpvars;
  end

endmodule
