///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This file is a sample design of AES using FIFO interface.     
//Author:Zeqi Qin                                               
//Date:12/03/2018                                              
//Modified:01/04/2019                                           
//Update Description:
//Since the aes_self module are very sensitive to the clock cycle, 
//the state machine has been modified to "read all the 16 pairs of inputs uninterruptly and then continuelly write 16 outputs".
//Origianl: IDLE-INPUTS-WAIT-OUTPUTS and then reapeat 16 times
//Modified: IDLE-INPUTS*16-WAIT-OUTPUTS*16
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
	
	aes_8_bit aes_8bit_test(
	.rst(~reset_n),
	.clk(clock),
	.key_in(key_in), 
	.d_in(d_in),
	.d_out(d_out),
	.d_vld(d_vld)   
	);

localparam IDLE=0,
	   INPUTS_TO_AES=1,
	   WAIT=2,
	   OUTPUTS_FROM_AES=3;

reg [7:0] state = IDLE;
reg waiting_for_adder = 0;

//Read Response
always @(posedge clock)
	begin
		data_rd <= 1'b0;
		data_wr <= 1'b0;
		if(!reset_n)
		      begin
			data_rd <= 1'b0;
			data_wr <= 1'b0;
			data_dout <= 32'hc0000000;
			waiting_for_adder <= 1'b0;
		      end
		else begin
		case(state)

		IDLE:
			begin
				if(!data_empty && !waiting_for_adder)
				begin
					waiting_for_adder <= 1'b1;
					state <= INPUTS_TO_AES;
				end
				else begin
					state <= IDLE;
 				end
			end

		INPUTS_TO_AES: 
			//data input to adder			
			begin
				data_rd <=1;	
				d_in <= data_din[7:0];
				key_in <= data_din[15:8];
				waiting_for_adder <= 1'b1;
				if (data_din[31:16]==16'h1111)	
				begin				
				state <= WAIT;
				end
				else begin
				state <= INPUTS_TO_AES;
				end
			end

		WAIT:
			begin
				state <= OUTPUTS_FROM_AES;	
			end

		OUTPUTS_FROM_AES:
			//results from adder		
			begin
				if(!data_full)
				begin
				data_wr <= 1'b1;
				data_dout <= d_out;
				waiting_for_adder <=1'b0;
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
				data_dout <= 32'h0000000c;
				waiting_for_adder <=1'b0;
				state <= INPUTS_TO_AES;
				end
			end
		endcase
		end
	end
endmodule			
