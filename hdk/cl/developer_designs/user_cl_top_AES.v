///////////////////////////////////////////////////////////////////
//This file is a sample design of AES using FIFO interface.     ///
//Author:Zeqi Qin                                               ///
//Date:11/01/2018                                               ///
//Modified:11/19/2018                                           ///
///////////////////////////////////////////////////////////////////


module user_cl_top_AES_8bit (
    input wire clock,
    input wire reset_n,

    // data inputs from input FIFO 
    input wire                  data_empty,
    output reg                  data_rd,
    input [DATA_WIDTH-1:0]      data_din,

    // data outputs to output FIFO
    input wire                  data_full,
    output reg                  data_wr,
    output reg [DATA_WIDTH-1:0] data_dout,
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
);

// Parameters

	parameter DATA_WIDTH = 32;

// Add logic here...

        //AES PORTS
	reg [7:0] key_in;  
   	reg [7:0] d_in;
   	wire [7:0] d_out;  
	wire d_vld;
	
	aes_8_bit aes_8bit_test(
	.rst(reset_n),
	.clk(clock),
	.key_in(key_in), 
	.d_in(d_in),
	.d_out(d_out),
	.d_vld(d_vld)   
	);

//state machine
	parameter SIZE = 16; 
	reg [SIZE-1:0] state;
	reg [SIZE-1:0] next_state;
	
	//JUST FOR STATUS FLAGS	
	reg S0;
	reg S1;
	reg S2;
	reg S3;
	reg S4;

//state S1-S2:data input from input fifo
//state S2-S4:data output to output fifo
	parameter S0_IDLE = 4'b0000;		//reset
	parameter S1_DATA_INPUT_ENABLE = 4'b0001; //usr data input enable
	parameter S2_DATA_INPUT_FROM_FIFO = 4'b0010; //data input from input fifo
	parameter S3_DATA_OUTPUT_ENABLE = 4'b0011; //usr data output enable
	parameter S4_DATA_OUTPUT_TO_FIFO = 4'b0100; //data output to output fifo

//combinational logic
	always @ (*)  //any change in varialbe
 	begin
		next_state <= 4'b0000;
		case(state)
		S0_IDLE:
			     if(~data_empty)   //if fifo is not empty and AES is not in the read process, data inputs available
				begin
				next_state <= S1_DATA_INPUT_ENABLE;		
				end
			     else if(data_empty || data_full)   //back to idle after rd/wr
				begin
				next_state <= S0_IDLE;
				end
		S1_DATA_INPUT_ENABLE:
			     if(~data_empty)
				begin
				next_state <= S2_DATA_INPUT_FROM_FIFO;
				end
			     else
				begin
				next_state <= S0_IDLE;
				end
		S2_DATA_INPUT_FROM_FIFO:
			     if(data_rd== 1'b1)
				begin
				next_state <= S2_DATA_INPUT_FROM_FIFO; 
				end
			     else if (~data_full)
				begin
				next_state <= S3_DATA_OUTPUT_ENABLE;  //keep at S3 until all input data setup
				end
		S3_DATA_OUTPUT_ENABLE:
			     if(~data_full)
				begin
				next_state <= S4_DATA_OUTPUT_TO_FIFO;
			 	end
			     else if (data_full)
				begin
				next_state <= S3_DATA_OUTPUT_ENABLE;    //if data full, wait at state S3, outut enable
				end
		S4_DATA_OUTPUT_TO_FIFO:
			     if(data_wr == 1'b1)          
				begin
				next_state <= S4_DATA_OUTPUT_TO_FIFO;
			 	end
			     else   //do not know when the outputs are all set. just wait for reset signal to back to S0_idle		
				begin
				next_state <= S0_IDLE;
			 	end
		endcase
	end
//sequencial logic
	always @ (posedge clock)
	begin
	     if (reset_n == 1'b1) 
	     begin
		  state <= S0_IDLE;
	     end else 
	     begin
		  state <= next_state;
	     end
	end

//output logic 
	always @ (posedge clock)
	begin
	   if (reset_n == 1'b1)
	 	     begin    
		        data_rd<=1'b0;
		     end
	    else begin
//			data_rd<=1'b0; //default		   
		   case(state)
			S0_IDLE:
				begin
				data_rd<=1'b0; 
				S0<=1'b1;   //just use for test state status
				end
			S1_DATA_INPUT_ENABLE:
				begin
				if(~data_empty) ////if fifo is not empty, set data_rd=1
				data_rd<=1'b1; 
				S1<=1'b1;   //just use for test state status
				end
			S2_DATA_INPUT_FROM_FIFO:
				begin 
				key_in <= data_din[15:8] ;  //read the data
				d_in <= data_din[7:0] ;     //read the data
				if(data_din[31:16]==16'h1111)  //all input data has been setup, shoule be able to read output now  //!revised
					begin				
					data_rd<=1'b0;
					end
				S2<=1'b1;  //just use for test state status
				end	
			S3_DATA_OUTPUT_ENABLE:
				begin
				data_wr<=1'b1;	
				S3<=1'b1; //just use for test state status
				end
			S4_DATA_OUTPUT_TO_FIFO:
				begin
				data_dout <= d_out;    //write the output data to fifo
				S4<=1'b1; //just use for test state status
				end
		      endcase
		  end
	 end

endmodule
