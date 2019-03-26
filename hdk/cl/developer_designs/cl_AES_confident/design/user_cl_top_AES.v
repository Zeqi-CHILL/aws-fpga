///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This file is a sample design of AES using FIFO interface.     
//Author:Zeqi Qin                                               
//Date:12/03/2018                                              
//Modified:03/26/2019                                           
//Update Description:
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module user_cl_top_AES (
    input wire clock,
    input wire rst,				//low sensitive

    // data inputs from input FIFO 
    input wire                  data_empty,
    output reg                  data_wr,
    input [DATA_WIDTH-1:0]      data_din,

    // data outputs to output FIFO
    input wire                  data_full,
    output reg                  data_rd,
    output reg [DATA_WIDTH-1:0] data_dout,
    output reg			data_vld
);

// Parameters
	parameter DATA_WIDTH = 16;

// define wires

	reg [7:0] key_in;  
   	reg [7:0] d_in;
   	wire [7:0] d_out;  
	wire d_vld;
	assign data_vld = d_vld;
	
	aes_8_bit aes_8bit_init(
	.rst(~rst),				//high sensitive
	.clk(clock),
	.key_in(key_in), 
	.d_in(d_in),
	.d_out(d_out),
	.d_vld(d_vld)   
	);

localparam IDLE=0,
	   IFIFO_TO_AES=1,
	   WAIT=2,
	   AES_TO_OFIFO=3;

reg [4:0] state = IDLE;
reg waiting_for_encrypt = 0;

//---------------------------------------------
// state machine
// combinational logic
//---------------------------------------------
always @ (*)
	begin
	if (!rst)
		begin
			next_state <= IDLE;	
		end
	else begin
		case(state)
		   IDLE:
			if (!ififo_empty & !waiting_for_encypt) begin
				next_state <= IFIFO_TO_AES;			
			end
			else begin
				next_state <= IDLE;
			end

		   IFIFO_TO_AES:
			if (ififo_empty) begin
				next_state <= WAIT;
			end
			else begin
				next_state <= IFIFO_TO_AES;
			end

		   WAIT:
			if (!d_vld) begin
				next_state <= WAIT;
			end
			else if (d_vld)	begin
				next_state <= AES_TO_OFIFO;
			end

		   AES_TO_OFIFO:
			if (!ofifo_full) begin
				next_state <= AES_TO_OFIFO;
			end
			else if (ofifo_full) begin
				next_state <= WAIT;				
			end
		endcase
	end
	end


//---------------------------------------------
//sequential logic
//---------------------------------------------
always @ (posedge clock)
	begin
	if (!rst)
		begin
			state <= IDLE;
		end
	else	begin
			state <= next_state;
		end
	end

//---------------------------------------------
//output logic
//---------------------------------------------
always @ (posedge clock)
	begin
	if (!rst)
		begin
			data_dout <= 8'h00;
			waiting_for_encrypt <= 0;
		end
	else begin
		case(state)
		   IDLE:
			//do nothing?

		   IFIFO_TO_AES:
			waiting_for_encrypt <= 1;
			key_in <= data_din[15:8];
			d_in   <= data_din[7:0];

		   WAIT:
			if (d_vld) begin
			waiting_for_encrypt <= 0;
			end	
			else begin
			waiting_for_encrypt <= 1;
			end
	
		   AES_TO_OFIFO:
			if(!data_full) begin
			data_dout <= d_out; 
			end
			else if (data_full) begin
			data_dout <= data_dout;
			end
		endcase
		end
	end

/*
//Read Response
always @(posedge clock)
	begin
		data_wr <= 1'b0;
		data_rd <= 1'b0;
		if(!reset_n)
		      begin
			data_wr <= 1'b0;
			data_rd <= 1'b0;
			data_dout <= 32'h00000000;
			waiting_for_encrypt <= 1'b0;
		      end
		else begin
		case(state)

		IDLE:
			begin
				if(!data_empty && !waiting_for_encrypt)
				begin
					waiting_for_encrypt <= 1'b1;
					state <= IFIFO_TO_AES;
				end
				else begin
					state <= IDLE;
 				end
			end

		IFIFO_TO_AES: 
			//data input to adder			
			begin
				data_wr <=1;	
				d_in <= data_din[7:0];
				key_in <= data_din[15:8];
				waiting_for_encrypt <= 1'b1;
				if (data_din[31:16]==16'h1111)	
				begin				
				state <= WAIT;
				end
				else begin
				state <= IFIFO_TO_AES;
				end
			end

		WAIT:
			begin
				state <= AES_TO_OFIFO;	
			end

		AES_TO_OFIFO:
			//results from adder		
			begin
				if(!data_full)
				begin
				data_rd <= 1'b1;
				data_dout <= d_out;
				waiting_for_encrypt <=1'b0;
					if(!reset_n)
					begin
					state <= IDLE;
					end
					else begin
					state <= AES_TO_OFIFO;
					end
				end
				else begin
				//if fifo is full, no new results from aes
				data_dout <= 32'h0000000c;
				waiting_for_encrypt <=1'b0;
				state <= IFIFO_TO_AES;
				end
			end
		endcase
		end
	end
*/
endmodule			
