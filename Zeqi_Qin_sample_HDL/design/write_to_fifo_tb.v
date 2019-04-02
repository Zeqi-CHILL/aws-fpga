///////////////////////////////////////////////////////////////////////////////////////
//This file is the testbench of user_cl_top_AES.v with FIFO bridege		 ///
//Author:Zeqi Qin                                                  		 ///
//Date:01/04/2019                               		   		 ///	
//Modified:01/04/2019                                             		 ///
///////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module write_to_fifo_tb();
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
	
	parameter DATA_WIDTH=32;
	parameter CYCLE=20;
	parameter DELAY=100;

  	parameter kin = 128'h000102030405060708090a0b0c0d0e0f;  
        parameter din = 128'h00112233445566778899aabbccddeeff;

	write_to_fifo write_to_fifo_test(
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
		clk_main_a0=~clk_main_a0;
	end

	initial 
	begin
	       $dumpfile("user_cl_top_AES_with_fifo_local_test.vcd"); //!compile to vcd file
	       $dumpvars(0,write_to_fifo_test);	
       
	        clk_main_a0 = 1'b1;			
		rst_main_n_sync = 1'b0;

//ADD FROM HERE		
		#(CYCLE)
		rst_main_n_sync = 1'b1;
		wready = 1'b1;
		wr_addr = 32'h0000_0510;
		arvalid_q =1'b1;
		araddr_q = 32'h0000_0510;

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[127:120];
		wdata[7:0] = din[127:120];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[119:112];
		wdata[7:0] = din[119:112];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[111:104];
		wdata[7:0] = din[111:104];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[103:96];
		wdata[7:0] = din[103:96];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[95:88];
		wdata[7:0] = din[95:88];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[87:80];
		wdata[7:0] = din[87:80];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[79:72];
		wdata[7:0] = din[79:72];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[71:64];
		wdata[7:0] = din[71:64];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[63:56];
		wdata[7:0] = din[63:56];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[55:48];
		wdata[7:0] = din[55:48];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[47:40];
		wdata[7:0] = din[47:40];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[39:32];
		wdata[7:0] = din[39:32];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[31:24];
		wdata[7:0] = din[31:24];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used		
		wdata[15:8] = kin[23:16];
		wdata[7:0] = din[23:16];

		#(CYCLE)
		wdata[31:16]=16'b0;    //high 16bits not used
		wdata[15:8] = kin[15:8];
		wdata[7:0] = din[15:8];

		#(CYCLE)
		wdata[31:16]=16'h1111;    //high 16bits not used, !but here use flag as all input data has been set up, should be ready to read output
		wdata[15:8] = kin[7:0];
		wdata[7:0] = din[7:0];

		#(DELAY*20);
		$finish;
	end

endmodule	
