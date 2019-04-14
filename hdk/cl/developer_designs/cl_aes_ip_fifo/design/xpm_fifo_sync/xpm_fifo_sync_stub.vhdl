-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
-- Date        : Sun Apr 14 19:12:32 2019
-- Host        : ece-master running 64-bit Ubuntu 18.04.1 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/zeqi/Downloads/lab302/test_library_fifo/test_library_fifo.srcs/sources_1/ip/xpm_fifo_sync/xpm_fifo_sync_stub.vhdl
-- Design      : xpm_fifo_sync
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcvu065-ffvc1517-3-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xpm_fifo_sync is
  Port ( 
    clk : in STD_LOGIC;
    srst : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 7 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC;
    prog_full : out STD_LOGIC;
    prog_empty : out STD_LOGIC;
    wr_rst_busy : out STD_LOGIC;
    rd_rst_busy : out STD_LOGIC
  );

end xpm_fifo_sync;

architecture stub of xpm_fifo_sync is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,srst,din[7:0],wr_en,rd_en,dout[7:0],full,empty,prog_full,prog_empty,wr_rst_busy,rd_rst_busy";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_2_3,Vivado 2018.3";
begin
end;
