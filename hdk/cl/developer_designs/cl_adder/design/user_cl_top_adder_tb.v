///////////////////////////////////////////////////////////////////////
//This file is the testbench of data transfer between FIFO and ADDER///
//Author:Zeqi Qin                                                   ///
//Date:12/03/2018                               		    ///	
//Modified:12/05/2018                                               ///
///////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module user_cl_top_adder_tb();
	reg clock;
	reg reset_n;
	
	//data inputs from input FIFO
	reg 		     data_empty;
	wire 		     data_rd;	
	reg [DATA_WIDTH-1:0] data_din;

	//data outputs to output FIFO
	reg 		      data_full;
	wire 		      data_wr;
	wire [DATA_WIDTH-1:0] data_dout;  
/*
	//control inputs
	reg 		     ctrl_empty;
	wire		     ctrl_rd;
	reg [DATA_WIDTH-1:0] ctrl_din;

	//control outputs
	reg		     ctrl_full;
	wire		     ctrl_wr;
	wire [DATA_WIDTH-1:0] ctrl_dout;
*/	
	parameter DATA_WIDTH=32;
	parameter CYCLE=20;
	parameter DELAY=100;

	//teset vector
	parameter add1=16'b0000111100110101;
	parameter add2=16'b1010110011110000;

	user_cl_top_adder user_cl_top_adder_test(
	.clock(clock),
	.reset_n(reset_n),
	.data_empty(data_empty),
	.data_rd(data_rd),
	.data_din(data_din),
	.data_full(data_full),
	.data_wr(data_wr),
	.data_dout(data_dout)   //comment out the ,
/*	.ctrl_empty(ctrl_empty),
	.ctrl_rd(ctrl_rd),
	.ctrl_din(ctrl_din),
	.ctrl_full(ctrl_full),
	.ctrl_wr(ctrl_wr),
	.ctrl_dout(ctrl_dout)
*/	);

	always #(CYCLE/2)    
	begin
		clock=~clock;
	end

	initial 
	begin
	       $dumpfile("user_cl_top_adder_test.vcd"); 
	       $dumpvars(0,user_cl_top_adder_test);	
		
		clock=1'b0;
		reset_n=1'b0;
		data_empty=1'b1;
		data_full=1'b0;

		#(CYCLE)
		reset_n = 1'b1;
		data_empty=1'b0;
		data_full=1'b0;

		#(CYCLE*4)
		data_din[31:8] <=0;
		data_din[3:0] <= add1[15:12];
		data_din[7:4] <= add2[15:12];

		#(CYCLE*4)
		data_din[31:8] <=0;
		data_din[3:0] <= add1[11:8];
		data_din[7:4] <= add2[11:8];

		#(CYCLE*4)
		data_din[31:8] <=0;
		data_din[3:0] <= add1[7:4];
		data_din[7:4] <= add2[7:4];

		#(CYCLE*4)
		data_din[31:8] <=0;
		data_din[3:0] <= add1[3:0];
		data_din[7:4] <= add2[3:0];

		#(CYCLE*4)
		reset_n=1'b0;
		#(CYCLE*4);
		$finish;
       end
endmodule
	
