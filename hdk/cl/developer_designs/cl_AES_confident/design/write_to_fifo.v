`define HELLO_WORLD_REG_ADDR    32'h0000_0500
`define FIFO_ADDR               32'h0000_0510
`define PLUS_ONE_ADDR           32'h0000_0508
`define TIMES_TWO_ADDR		32'h0000_050C

module write_to_fifo(
    input wire clk_main_a0,
    input wire rst_main_n_sync,
    input wire [31:0] wr_addr ,
    input wire wready,
    input wire [31:0] wdata,
    
    input wire rready,
    
    input wire arvalid_q,
    input wire [31:0] araddr_q,
    input wire [15:0] vled_q,

    output reg [1:0] rresp,
    output reg rvalid,
    output reg [31:0] rdata,
    output wire [31:0] hello_world_q
   );

//********???*********************
//input wire ack_calling_decryption;
//check FIFO_READ_LATENCY is better to set 1 or 0???
//********???*********************

//--------------------------------------------------
//define wires
//--------------------------------------------------
	//ports for ififo
	reg [(WRITE_DATA_WIDTH-1):0] ififo_din;
	reg ififo_injectsbiterr;
	reg ififo_injectdbiterr;
//	reg ififo_rst;            //use global rst
//	reg ififo_wr_clk;         //use global clock
	reg ififo_wr_en;
	reg ififo_rd_en;
	reg ififo_sleep;

	wire [(READ_DATA_WIDTH-1):0] ififo_dout;
	wire [(WR_DATA_COUNT_WIDTH – 1):0] ififo_wr_data_count;
	wire [(RD_DATA_COUNT_WIDTH – 1):0] ififo_rd_data_count;
	wire ififo_sbiterr;
	wire ififo_dbiterr;
	wire ififo_rd_rst_busy;
	wire ififo_wr_rst_busy;
	wire ififo_full;
	wire ififo_empty;
	wire ififo_overflow;
	wire ififo_underflow;
	wire ififo_prog_full;
	wire ififo_prog_empty;
	wire ififo_wr_ack;
	wire ififo_data_valid;
	wire ififo_almost_full;
	wire ififo_almost_empty;

	//ports for ofifo
	reg [(WRITE_DATA_WIDTH-1):0] ofifo_din;
	reg ofifo_injectsbiterr;
	reg ofifo_injectdbiterr;
//	reg ofifo_rst;		    //use global rst
//	reg ofifo_wr_clk;           //use global clock
	reg ofifo_wr_en;
	reg ofifo_rd_en;
	reg ofifo_sleep;

	wire [(READ_DATA_WIDTH-1):0] ofifo_dout;
	wire [(WR_DATA_COUNT_WIDTH – 1):0] ofifo_wr_data_count;
	wire [(RD_DATA_COUNT_WIDTH – 1):0] ofifo_rd_data_count;
	wire ofifo_sbiterr;
	wire ofifo_dbiterr;
	wire ofifo_rd_rst_busy;
	wire ofifo_wr_rst_busy;
	wire ofifo_full;
	wire ofifo_empty;
	wire ofifo_overflow;
	wire ofifo_underflow;
	wire ofifo_prog_full;
	wire ofifo_prog_empty;
	wire ofifo_wr_ack;
	wire ofifo_data_valid;
	wire ofifo_almost_full;
	wire ofifo_almost_empty;
	
	//ports for aes_top_level
	wire aes_d_vld;
	wire aes_rst;
	 
	//intermidiate ports
	reg done_bit;

//--------------------------------------------------
// xpm_fifo_sync: Synchronous FIFO
// Xilinx Parameterized Macro, version 2018.3
//--------------------------------------------------
// instantiate input fifo
//--------------------------------------------------
	xpm_fifo_sync #(
	.DOUT_RESET_VALUE("0"),	      // String
	.ECC_MODE("no_ecc"),	      // String
	.FIFO_MEMORY_TYPE("auto"),    // String
	.FIFO_READ_LATENCY(0),        // DECIMAL    //read the data immediately after rd_en
	.FIFO_WRITE_DEPTH(16),        // DECIMAL    //This design needs 16 sets of input data
	.FULL_RESET_VALUE(0),         // DECIMAL
	.PROG_EMPTY_THRESH(8),        // DECIMAL
	.PROG_FULL_THRESH(8),         // DECIMAL
	.RD_DATA_COUNT_WIDTH(1),      // DECIMAL
	.READ_DATA_WIDTH(16),          // DECIMAL    //This design reads 16 sets of 8-bit data,key&data 16
	.READ_MODE("std"),            // String
	.USE_ADV_FEATURES("0707"),    // String
	.WAKEUP_TIME(0),              // DECIMAL
	.WRITE_DATA_WIDTH(16),         // DECIMAL    //This design reads 16 sets of 8-bit data,key&data 16
	.WR_DATA_COUNT_WIDTH(1)       // DECIMAL
	)
	input_xpm_fifo_sync_inst (
	.almost_empty(ififo_almost_empty), 
	.almost_full(ififo_almost_full), 
	.data_valid(ififo_data_valid), 
	.dbiterr(ififo_dbiterr), 
	.dout(ififo_dout), 
	.empty(ififo_empty), 
	.full(ififo_full),
	.overflow(ififo_overflow),
	.prog_empty(ififo_prog_empty),
	.prog_full(ififo_prog_full),
	.rd_data_count(ififo_rd_data_count), 
	.rd_rst_busy(ififo_rd_rst_busy), 
	.sbiterr(ififo_sbiterr), 
	.underflow(ififo_underflow),
	.wr_ack(ififo_wr_ack),
	.wr_data_count(ififo_wr_data_count),
	.wr_rst_busy(ififo_wr_rst_busy),
	.din(ififo_din), 
	.injectdbiterr(ififo_injectdbiterr), 
	.injectsbiterr(ififo_injectsbiterr), 
	.rd_en(ififo_rd_en),
	.rst(~rst_main_n_sync),
	.sleep(ififo_sleep), 
	.wr_clk(clk_main_a0),
	.wr_en(ififo_wr_en) 
	);

//--------------------------------------------------
// instantiate output fifo
//--------------------------------------------------
	xpm_fifo_sync #(
	.DOUT_RESET_VALUE("0"),	      // String
	.ECC_MODE("no_ecc"),	      // String
	.FIFO_MEMORY_TYPE("auto"),    // String
	.FIFO_READ_LATENCY(0),        // DECIMAL    //read the data immediately after rd_en
	.FIFO_WRITE_DEPTH(16),        // DECIMAL    //This design needs 16 sets of input data
	.FULL_RESET_VALUE(0),         // DECIMAL
	.PROG_EMPTY_THRESH(8),        // DECIMAL
	.PROG_FULL_THRESH(8),         // DECIMAL
	.RD_DATA_COUNT_WIDTH(1),      // DECIMAL
	.READ_DATA_WIDTH(16),          // DECIMAL    //This design reads 16 sets of 8-bit data
	.READ_MODE("std"),            // String
	.USE_ADV_FEATURES("0707"),    // String
	.WAKEUP_TIME(0),              // DECIMAL
	.WRITE_DATA_WIDTH(16),         // DECIMAL    //This design reads 16 sets of 8-bit data
	.WR_DATA_COUNT_WIDTH(1)       // DECIMAL
	)
	output_xpm_fifo_sync_inst (
	.almost_empty(ofifo_almost_empty), 
	.almost_full(ofifo_almost_full), 
	.data_valid(ofifo_data_valid), 
	.dbiterr(ofifo_dbiterr), 
	.dout(ofifo_dout), 
	.empty(ofifo_empty), 
	.full(ofifo_full),
	.overflow(ofifo_overflow),
	.prog_empty(ofifo_prog_empty),
	.prog_full(ofifo_prog_full),
	.rd_data_count(ofifo_rd_data_count), 
	.rd_rst_busy(ofifo_rd_rst_busy), 
	.sbiterr(ofifo_sbiterr), 
	.underflow(ofifo_underflow),
	.wr_ack(ofifo_wr_ack),
	.wr_data_count(ofifo_wr_data_count),
	.wr_rst_busy(ofifo_wr_rst_busy),
	.din(ofifo_din), 
	.injectdbiterr(ofifo_injectdbiterr), 
	.injectsbiterr(ofifo_injectsbiterr), 
	.rd_en(ofifo_rd_en),
	.rst(~rst_main_n_sync),
	.sleep(ofifo_sleep), 
	.wr_clk(clk_main_a0),
	.wr_en(ofifo_wr_en) 
	);

//---------------------------------------------
// initiate aes module
//---------------------------------------------
user_cl_top_AES user_cl_top_AES_init(
	.clock(clk_main_a0),
	.rst(aes_rst),
	.data_empty(ififo_empty),
	.data_wr(ififo_rd),
	.data_din(ififo_dout),
	.data_full(ofifo_full),
	.data_rd(ofifo_wr),
	.data_dout(ofifo_din),
	.data_vld(aes_d_vld)
);

//---------------------------------------------
// define states
//---------------------------------------------
local param IFIFO_COLLECT_DATA = 0,
	    INIT_AES = 1,
	    WAIT_ENCRYPT = 2,
	    CIPHER_TEXT_READY = 3,
	    DONE_BIT_FLAG = 4,
	    SW_READ_FROM_OFIFO = 5;

reg [7:0] state = IFIFO_COLLECT_DATA;

//---------------------------------------------
// state machine
// combinational logic
//---------------------------------------------
always @ (*)
	begin
	if (!rst_main_n_sync)
		begin
			next_state <= IFIFO_COLLECT_DATA;
		end
	else begin
		case(state)
		IFIFO_COLLECT_DATA:	if (!ififo_full) 
			begin
				next_state <= IFIFO_COLLECT_DATA;
			end
			else if (ififo_full)             //if input-fifo is full, all key&plaintext has been collected
			begin	
				next_state <= INIT_AES;  
			end

	    	INIT_AES: if (!ififo_empty)
			begin
			        next_state <= INIT_AES; 
			end
			else if (ififo_empty)		//if input-fifo is empty, it indicates all data has been feed to aes module
			begin
			        next_state <= WAIT_ENCRYPT; 
			end			
	    	
		WAIT_ENCRYPT: if (!aes_d_vld)
			begin
				next_state <= WAIT_ENCRYPT; 
			end
			else if (aes_d_vld)
			begin
				next_state <= CIPHER_TEXT_READY; 
			end

	    	CIPHER_TEXT_READY: if (!ofifo_full)
			begin
				next_state <= CIPHER_TEXT_READY; 
			end
			else if (ofifo_full)
			begin
				next_state <= DONE_BIT_FLAG;
			end

	    	DONE_BIT_FLAG: if (!ack_calling_decryption)    //********global define???************
			begin
				next_state <= DONE_BIT_FLAG;
			end
			else if (ack_calling_decryption)
			begin
				next_state <= SW_READ_FROM_OFIFO;
			end

	    	SW_READ_FROM_OFIFO: if (!ofifo_empty)
			begin
				next_state <= SW_READ_FROM_OFIFO;				
			end
			else if (ofifo_empty)
			begin
				next_state <= IFIFO_COLLECT_DATA;        //*************go back to IFIFO_COLLECT_DATA???*********
			end
		endcase
	end
	end


//---------------------------------------------
//sequential logic
//---------------------------------------------
always @ (posedge clk_main_a0)
	begin
	if (!rst_main_n_sync)
		begin
			state <= IFIFO_COLLECT_DATA;
		end
	else	begin
			state <= next_state;
		end
	end


//---------------------------------------------
//output logic
//---------------------------------------------
always @ (posedge clk_main_a0)
	begin
	if (!rst_main_n_sync)
		begin
		//what signal should be reset???
		rvalid <= 32'h0000_0000;		
		rdata <= 32'h0000_0000;
        	hello_world_q_internal[31:0] <= 32'h0000_0000;		
		end
	else begin
		ififo_wr_en <= 0;       //reset wr flag signal?
		ififo_rd_en <= 0;
		ofifo_wr_en <= 0;
		ofifo_rd_en <= 0;

		case(state)
		    IFIFO_COLLECT_DATA:
			ififo_wr_en <= ififo_full? 0:1;
			if (wready & (wr_addr == `HELLO_WORLD_REG_ADDR ))
			begin
				hello_world_q_internal[31:0] <= wdata[31:0];
			end
			else if (wready & (wr_addr == `FIFO_ADDR ))
			begin
				if (!ififo_full)
				begin					
					ififo_din <= wdata;   //wdata[7:0]??	
				end
				else begin                    // Hold Value
        				hello_world_q_internal[31:0] <= hello_world_q_internal[31:0];
    				end
			end

		    INIT_AES:
			aes_rst <= 1;  //reset signal is low sensitive, set 1 means not reset
			ififo_rd_en <= 1;
			if (ififo_empty) begin
			ififo_rd_en <= 0;          //make sense?
			end

		    WAIT_ENCRYPT:
			//nothing to do?

		    CIPHER_TEXT_READY:
			ofifo_wr_en <= ofifo_full? 0:1;

		    DONE_BIT_FLAG:
			done_bit <= ofifo_full? 1:0;
			rdata[0] <= done_bit;		//valid? 
			aes_rst <= 0;	//aes module no longer needed, reset all signal

		    SW_READ_FROM_OFIFO:
			ofifo_rd_en <= ofifo_empty? 0:1;
			if (rvalid && rready) begin
            		rvalid <= 0;
                	rdata  <= 32'h00000000;
			end
			else if (arvalid_q) begin
				if (araddr_q == `FIFO_ADDR) begin
				rvalid <= 1;
				rdata <= ofifo_dout;			
				end
			end
		endcase
	     end
	end

assign hello_world_q_byte_swapped[31:0] = {hello_world_q_internal[7:0],   hello_world_q_internal[15:8],
                                           hello_world_q_internal[23:16], hello_world_q_internal[31:24]};



//cipher text from aes module is ready for reading, C programe calling the decryption function









 
/*
user_cl_top_AES user_cl_top_AES_inst(
    .clock (clk_main_a0),
    .reset_n (rst_main_n_sync),
    .data_empty (fifo_cl_to_fifotest_empty),
    .data_rd (fifo_cl_to_fifotest_rd),
    .data_din (fifo_cl_to_fifotest_dout),
    .data_full (fifo_fifotest_to_cl_full),
    .data_wr (fifo_fifotest_to_cl_wr),
    .data_dout (fifo_fifotest_to_cl_din)
    );

reg [31:0] hello_world_q_internal;
wire [31:0] hello_world_q_byte_swapped;
assign hello_world_q = hello_world_q_internal;


always @(posedge clk_main_a0) begin
    fifo_cl_to_fifotest_wr <= 0;

    if (!rst_main_n_sync) begin                    // Reset
        hello_world_q_internal[31:0] <= 32'h0000_0000;
    end
    else if (wready & (wr_addr == `HELLO_WORLD_REG_ADDR || wr_addr == `PLUS_ONE_ADDR || wr_addr == `TIMES_TWO_ADDR)) begin  //write wdata to address
        hello_world_q_internal[31:0] <= wdata[31:0];
    end
    else if (wready & (wr_addr == `FIFO_ADDR)) begin
    //wdata into FIFO
    //if fifo is not full, then send wdata to din_cl_to_fifotest and set wr_cl_to_fifo_test to 1.
        if(!fifo_cl_to_fifotest_full) begin
            fifo_cl_to_fifotest_din <= wdata;
            fifo_cl_to_fifotest_wr <= 1;
        end
    end
    else begin                                // Hold Value
        hello_world_q_internal[31:0] <= hello_world_q_internal[31:0];
    end
end

assign hello_world_q_byte_swapped[31:0] = {hello_world_q_internal[7:0],   hello_world_q_internal[15:8],
                                           hello_world_q_internal[23:16], hello_world_q_internal[31:24]};





localparam WAIT = 0,
           IDLE = 1,
           READ_FIFO = 2;

reg [7:0] state = IDLE;

//reg rst_fifo = 1;
reg not_waiting_for_fifo = 1;
// Read Response
always @(posedge clk_main_a0) begin
    fifo_fifotest_to_cl_rd <= 0;
    //rst_fifo <= 0;
    rresp <= 0;
    //rvalid <= 0; 

    if (!rst_main_n_sync) begin
        rvalid <= 0;
        rdata  <= 0;
        not_waiting_for_fifo <= 1;
        //rst_fifo <= 1;
    end
    else begin
    	case(state)
        WAIT: begin
        	state <= READ_FIFO;
        end

        IDLE: begin
            if (rvalid && rready) begin
            	rvalid <= 0;
                rdata  <= 0;
                not_waiting_for_fifo <= 1;
                state <= IDLE;
            end
        	else if (arvalid_q && not_waiting_for_fifo) begin
        		if((araddr_q == `FIFO_ADDR) && !fifo_fifotest_to_cl_empty) begin
        			fifo_fifotest_to_cl_rd <= 1; 
        			not_waiting_for_fifo <= 0;
        			
        			state <= WAIT;
        		end
        		else if((araddr_q == `FIFO_ADDR) && fifo_fifotest_to_cl_empty) begin
        			not_waiting_for_fifo <= 1;
                    rvalid <= 1;
                    rdata <= 32'hdead_0000;
                    state <= IDLE;
        		end
        		else begin
        			not_waiting_for_fifo <= 1;
                    rvalid <= 1; 
                    rdata <= 32'haaaa_aaaa;
                    state <= IDLE;
        		end
        	end
        	else begin
        		rvalid <= 0;
                rdata <= 32'hcccc_cccc;
                not_waiting_for_fifo <= 1;
                state <= IDLE;
        	end
        end
        
        READ_FIFO: begin
        	rvalid <= 1;
            rdata <= fifo_fifotest_to_cl_dout;
            not_waiting_for_fifo <= 1;
            state <= IDLE;
        end
        endcase
    end
end
*/


endmodule
