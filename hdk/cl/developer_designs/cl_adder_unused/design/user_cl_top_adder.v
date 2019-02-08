///////////////////////////////////////////////////////////////////
//This file is a sample design of ADDER using FIFO interface.   ///
//Author:Zeqi Qin                                               ///
//Date:12/03/2018                                               ///
//Modified:12/05/2018                                           ///
///////////////////////////////////////////////////////////////////


module user_cl_top_adder (
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

	adder adder_inst(
	.clock(clock),
	.reset(reset_n),
	.add_in1(add_in1),
	.add_in2(add_in2),
	.add_out(add_out)
	);

	//define ADDER wires
	reg  [3:0] add_in1;
	reg  [3:0] add_in2;
	wire [4:0] add_out;

localparam IDLE=0,
	   INPUTS_TO_ADDER=1,
	   WAIT=2,
	   OUTPUTS_FROM_ADDER=3;

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
			data_dout <= 0;
			waiting_for_adder <= 1'b0;
		      end
		else begin
		case(state)

		IDLE:
			begin
				if(!data_empty && !waiting_for_adder)
				begin
					waiting_for_adder <= 1'b1;
					state <= INPUTS_TO_ADDER;
				end
				else begin
					state <= IDLE;
 				end
			end

		INPUTS_TO_ADDER: 
			//data input to adder			
			begin
				data_rd <=1;	
				add_in1 <= data_din[3:0];
				add_in2 <= data_din[7:4];
				waiting_for_adder <= 1'b1;	
				state <= WAIT;
			end

		WAIT:
			begin
				state <= OUTPUTS_FROM_ADDER;	
			end

		OUTPUTS_FROM_ADDER:
			//results from adder		
			begin
				if(!data_full)
				begin
				data_wr <= 1'b1;
				data_dout <= add_out;
				waiting_for_adder <=1'b0;
				state <= IDLE;
				end
				else begin
				//if fifo is full, no new results from adder
				data_dout <= 0;
				waiting_for_adder <=1'b0;
				state <= INPUTS_TO_ADDER;
				end
			end
		endcase
		end
	end
endmodule			
