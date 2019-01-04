///////////////////////////////////////////////////////////////////////
//This file is the testbench of user_cl_top_AES.v		    ///
//Author:Zeqi Qin                                                   ///
//Date:01/04/2019                               		    ///	
//Modified:01/04/2019                                               ///
///////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module user_cl_top_AES_tb();
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

	//control inputs
//	reg 		     ctrl_empty;
//	wire		     ctrl_rd;
//	reg [DATA_WIDTH-1:0] ctrl_din;

	//control outputs
//	reg		     ctrl_full;
//	wire		     ctrl_wr;
//	wire [DATA_WIDTH-1:0] ctrl_dout;
	
	parameter DATA_WIDTH=32;
	parameter CYCLE=20;
	parameter DELAY=100;

	//test vector
//	parameter key = 16'b1110110010001111; 
//	parameter data = 16'b0001001001001000;
  	parameter kin = 128'h000102030405060708090a0b0c0d0e0f;   //use the same test vector as AES_SELF_TESTBENCH
        parameter din = 128'h00112233445566778899aabbccddeeff;

	user_cl_top_AES user_cl_top_AES_local_test(
	.clock(clock),
	.reset_n(reset_n),
	.data_empty(data_empty),
	.data_rd(data_rd),
	.data_din(data_din),
	.data_full(data_full),
	.data_wr(data_wr),
	.data_dout(data_dout)
	);

	always #(CYCLE/2)     
	begin
		clock=~clock;
	end

	initial 
	begin
	       $dumpfile("user_cl_top_AES_local_test.vcd"); //!compile to vcd file
	       $dumpvars(0,user_cl_top_AES_local_test);	
       
	        clock=1'b1;			
		reset_n = 1'b0;
		data_empty=1'b0;        //the test does not include fifo yet,so give value to empty&full 
		data_full=1'b0;		//fifo

/*		#(CYCLE) 
		reset_n = 1'b0;
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8]=key[7:0];
		data_din[7:0]=data[7:0];
		data_empty=1'b0;
		data_full=1'b0;
		
		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8]=key[15:8];
		data_din[7:0]=data[15:8];
		
		#(CYCLE*4)
		data_empty=1'b1;    //what value?
		data_full=1'b0;	    //what value?	
*/

//ADD FROM HERE		
		#(CYCLE)
		reset_n = 1'b1;
		data_empty=1'b0;
		data_full=1'b0;

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[127:120];
		data_din[7:0] = din[127:120];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[119:112];
		data_din[7:0] = din[119:112];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[111:104];
		data_din[7:0] = din[111:104];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[103:96];
		data_din[7:0] = din[103:96];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[95:88];
		data_din[7:0] = din[95:88];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[87:80];
		data_din[7:0] = din[87:80];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[79:72];
		data_din[7:0] = din[79:72];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[71:64];
		data_din[7:0] = din[71:64];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[63:56];
		data_din[7:0] = din[63:56];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[55:48];
		data_din[7:0] = din[55:48];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[47:40];
		data_din[7:0] = din[47:40];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[39:32];
		data_din[7:0] = din[39:32];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[31:24];
		data_din[7:0] = din[31:24];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used		
		data_din[15:8] = kin[23:16];
		data_din[7:0] = din[23:16];

		#(CYCLE)
		data_din[31:16]=16'b0;    //high 16bits not used
		data_din[15:8] = kin[15:8];
		data_din[7:0] = din[15:8];

		#(CYCLE)
		data_din[31:16]=16'h1111;    //high 16bits not used, !but here use flag as all input data has been set up, should be ready to read output
		data_din[15:8] = kin[7:0];
		data_din[7:0] = din[7:0];

		#(DELAY*8);
		$finish;
	end

endmodule	
