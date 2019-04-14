// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Sun Apr 14 19:12:32 2019
// Host        : ece-master running 64-bit Ubuntu 18.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/zeqi/Downloads/lab302/test_library_fifo/test_library_fifo.srcs/sources_1/ip/xpm_fifo_sync/xpm_fifo_sync_stub.v
// Design      : xpm_fifo_sync
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu065-ffvc1517-3-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_3,Vivado 2018.3" *)
module xpm_fifo_sync(clk, srst, din, wr_en, rd_en, dout, full, empty, 
  prog_full, prog_empty, wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[7:0],wr_en,rd_en,dout[7:0],full,empty,prog_full,prog_empty,wr_rst_busy,rd_rst_busy" */;
  input clk;
  input srst;
  input [7:0]din;
  input wr_en;
  input rd_en;
  output [7:0]dout;
  output full;
  output empty;
  output prog_full;
  output prog_empty;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule
