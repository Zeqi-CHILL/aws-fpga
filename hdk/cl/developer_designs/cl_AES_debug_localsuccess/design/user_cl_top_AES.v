///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This file is a sample design of AES using FIFO interface.     
//Author:Zeqi Qin                                               
//Date:12/03/2018                                              
//Modified:01/04/2019                                           
//Update Description:
//The aes_8_bit is initiated in this top module. The initiated file can be found in aes_top_revised_cnt.v
//Since the AES module is extremely sensitive to the time that inputs flow in, the state machine has been modified to "read all the 16 pairs of inputs uninterruptly and then continuelly write outputs".
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module user_cl_top_AES (
    input wire clock,
    input wire reset_n,

    // data inputs from input FIFO 
    input wire                  data_empty,
    output reg                  data_rd,
    input [DATA_WIDTH-1:0]      data_din,

    // data outputs to output FIFO
    input wire                  data_full,
    output reg                  data_wr,
    output reg [DATA_WIDTH-1:0] data_dout
/*
    // control inputs (assuming FIFO interface for now
    // but there should never be more than one input at a time,
    // this is mostly for clock-domain crossing).
    input wire                  ctrl_empty,
    output reg                  ctrl_rd,
    input [DATA_WIDTH-1:0]      ctrl_din,

    // control outputs (assuing FIFO interface for now
    // but there should never be more than one output at a time,
    // this is mostly for clock-domain crossing).
    input wire                  ctrl_full,
    output reg                  ctrl_wr,
    output reg [DATA_WIDTH-1:0] ctrl_dout  
*/
);

// Parameters

	parameter DATA_WIDTH = 32;

// Add logic here...

	reg [7:0] key_in;  
   	reg [7:0] d_in;
   	wire [7:0] d_out;  
	wire d_vld;
	reg input_vld=1'b0;
	
	aes_8_bit aes_8bit_test(
	.rst(~reset_n),
	.clk(clock),
	.key_in(key_in), 
	.d_in(d_in),
	.d_out(d_out),
	.d_vld(d_vld),
	.input_vld(input_vld)   
	);

localparam IDLE=0,
	   INPUTS_TO_AES=1,
	   WAIT=2,
	   OUTPUTS_FROM_AES=3;

reg [7:0] state = IDLE;
reg waiting_for_aes = 0;

//Read Response
always @(posedge clock)
	begin
		data_rd <= 1'b0;
		data_wr <= 1'b0;
		if(!reset_n)
		      begin
			data_rd <= 1'b0;
			data_wr <= 1'b0;
			data_dout <= 32'ha0000000;
			waiting_for_aes <= 1'b0;
		      end
		else begin
		case(state)

		IDLE:
			begin
				if(!data_empty && !waiting_for_aes)
				begin
					waiting_for_aes <= 1'b1;
					state <= INPUTS_TO_AES;
				end
				else begin
					state <= IDLE;
 				end
			end

		INPUTS_TO_AES: 
			//data input to AES module			
			begin
				data_rd <=1;	
				d_in <= data_din[7:0];
				key_in <= data_din[15:8];
				waiting_for_aes <= 1'b1;
				input_vld <=1'b1;		 //input valid, the register "cnt" in AES module start counting
				if (data_din[31:16]==16'h1111)	 //The AES module is extremely sensitive to the time that inputs flow in. There are 16 pairs of key and data needed to be input to the AES module CONTINUOUSLY. Here to set the top 16 bits of data_din as a flag that all 16 pairs of inputs has been written to AES module. Then, the state can transfer to read the encrypted outputs.   
				begin				
				state <= WAIT;
				end
				else begin
				state <= INPUTS_TO_AES;
				data_dout <= 32'ha0a0a0a0;    //for convenience to debug whether the state mahine has stucked
				end
			end

		WAIT:
			begin
				state <= OUTPUTS_FROM_AES;	
			end

		OUTPUTS_FROM_AES:
			//results from aes		
			begin
				if(!data_full)
				begin
				data_wr <= 1'b1;
				waiting_for_aes <=1'b0;	
//				if(d_vld==1'b1)
//				begin			
				data_dout <= d_out;		
//				end			
					if(!reset_n)
					begin
					state <= IDLE;
					end
					else begin
					state <= OUTPUTS_FROM_AES;
					end
				end
				else begin
				//if fifo is full, no new results from aes
				data_dout <= 32'h0a0a0a0a;
				waiting_for_aes <=1'b0;
				state <= INPUTS_TO_AES;
				end
			end
		endcase
		end
	end
endmodule			
