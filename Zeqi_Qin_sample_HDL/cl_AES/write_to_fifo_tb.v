`timescale 1ns / 1ps
//***********************************************************************************
// Project: 		cl_AES_128 
// Author: 		Zeqi Qin 
// Create Date: 	03/28/2019 06:33:24 PM
// Module Name: 	write_to_fifo_tb
// Description: 	This is the testbench of "write_to_fifo_tb.v"
// Additional Comments: Test vector
//			-INPUT  Key        = 128'h000102030405060708090a0b0c0d0e0f;
// 			-INPUT  Plaintext  = 128'h00112233445566778899aabbccddeeff;  
//			-OUTPUT Ciphertext = 128'0x69c4e0d86a7b0430d8cdb78070b4c55a;
//			-Test results meet output expectation.
//***********************************************************************************


module write_to_fifo_tb(

    );
    
 	reg clk_main_a0;
	reg rst_main_n_sync;
	reg [31:0] wr_addr;
	reg wready;
	reg [31:0] wdata;
	reg rready;
	reg arvalid_q;
	reg [31:0] araddr_q;
	reg [15:0] vled_q;

	wire  [1:0] rresp;
	wire  rvalid;
	wire  [31:0] rdata;
	wire  [31:0] hello_world_q;
	
    	
	parameter kin = 128'h000102030405060708090a0b0c0d0e0f;		//test vector key
    	parameter din = 128'h00112233445566778899aabbccddeeff;   	//test vector plaintext
    	//Expected OUTPUT = 0x69c4e0d86a7b0430d8cdb78070b4c55a		//expected ciphertext

    	integer i=16;
    	parameter CYCLE=20;						

	write_to_fifo write_to_fifo_test(				//instantiate the test module
    	.clk_main_a0(clk_main_a0),
    	.rst_main_n_sync(rst_main_n_sync),
    	.wr_addr(wr_addr),
    	.wready(wready),
    	.wdata(wdata),
	.rready(rready),
	.arvalid_q(arvalid_q),
	.araddr_q(araddr_q),
	.vled_q(vled_q),
	.rresp(rresp),
	.rvalid(rvalid),
	.rdata(rdata),
	.hello_world_q(hello_world_q)
   	);
   	
 	always #(CYCLE/2)     
	begin
		clk_main_a0 = ~clk_main_a0;				//generate clock signal
	end	
	
	initial
	begin
	    	clk_main_a0 = 1'b1;					//initial clock 	
		rst_main_n_sync = 1'b0;    				//initial reset (low sensitive)
		
	#(100)
		rst_main_n_sync = 1'b1;					//release the reset signal
		wready = 1'b0;						//disable the "ready to write" signal
		wr_addr = 32'h0000_0510;				//define the writing address
		arvalid_q =1'b1;
		araddr_q = 32'h0000_0510;	
		
    	#(100)
    	for (i=16; i>0; i=i-1)						
	    	begin
		    wready = 1'b1;					//enable the "ready to write" signal
		    wdata[31:28] = i;
		    wdata[27:8] = 0;
		    wdata[7:0] = kin[(i*8-1)-:8];			//16 sets of 8-bit key
	    	#(10);
	    	   wready = 1'b0;					//disable the "ready to write" signal, only write when new data in
	    	#(20);
	    	end							
  
        #(100);  	
      	for (i=16; i>0; i=i-1)
	    	begin
	    	    wready = 1'b1;					//enable the "ready to write" signal
		    wdata[31:28] = i;					
		    wdata[27:8] = 0;
		    wdata[7:0] = din[(i*8-1)-:8];			//16 sets of 8-bit plaintext
		#(10);
	    	   wready = 1'b0;					//disable the "ready to write" signal, only write when new data in
	    	#(20);
	    	end  	
	end
	  	    
endmodule
