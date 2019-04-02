//----------------------------------------------------------------------------
//Project: 	cl_AES_128
//Author:	Zeqi Qin
//Date:		03/15/2019
//Midify:	03/26/2019
//Description:  This is the AES core with FIFO bridge. This is module can be simulated locally and will be instantiate in cl_fifo.sv 
//----------------------------------------------------------------------------

`define FIFO_ADDR               32'h0000_0510

module write_to_fifo #( 
parameter FIFO_WIDTH = 8,
parameter FIFO_DEPTH = 16
)
(
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


//-------------------------------------------------
//define start here
//-------------------------------------------------

    //ififo_key
	reg  [(FIFO_WIDTH-1):0] ififo_key_din;
	reg  ififo_key_wr_en;
	reg  ififo_key_rd_en;
	wire [(FIFO_WIDTH-1):0] ififo_key_dout;
	wire  ififo_key_full;
	wire  ififo_key_empty;
	reg ififo_key_input_vld;
	wire ififo_key_data_valid;

    //ififo_plaintext
	reg  [(FIFO_WIDTH-1):0] ififo_plaintext_din;
	reg  ififo_plaintext_wr_en;
	reg  ififo_plaintext_rd_en;
	wire [(FIFO_WIDTH-1):0] ififo_plaintext_dout;
	wire  ififo_plaintext_full;
	wire  ififo_plaintext_empty;
	reg ififo_plaintext_input_vld;
	wire ififo_plaintext_data_valid;
	
	//ofifo
	wire [(FIFO_WIDTH-1):0] ofifo_din;
	reg  ofifo_wr_en;
	reg  ofifo_rd_en;
	wire [(FIFO_WIDTH-1):0] ofifo_dout;
	wire  ofifo_full;
	wire  ofifo_empty;
	wire ofifo_data_valid;

	    //aes_module
	    wire aes_d_vld;
	    reg  aes_rst;
	    reg  go_bit;
	    reg  done_bit;
	    
	    //all the next
		reg ififo_key_wr_en_next;        
	    reg ififo_key_rd_en_next;    
	    reg [(FIFO_WIDTH-1):0] ififo_key_din_next;               
	    reg ififo_key_full_next;           
	    reg ififo_key_empty_next;  
	    reg ififo_key_input_vld_next;
	    reg ififo_plaintext_wr_en_next;    
	    reg ififo_plaintext_rd_en_next; 
	    reg [(FIFO_WIDTH-1):0] ififo_plaintext_din_next;     
	    reg ififo_plaintext_full_next;     
	    reg ififo_plaintext_empty_next; 
	    reg ififo_plaintext_input_vld_next; 
	    reg ofifo_wr_en_next;              
	    reg ofifo_rd_en_next;    
	    reg ofifo_din_next;    
	    reg ofifo_full_next;               
	    reg ofifo_empty_next;    
	    reg go_bit_next;                     
	    reg done_bit_next;                 
	    reg aes_rst_next;    
	 //   reg aes_d_vld_next;                                
	    reg rvalid_next;   
	    
	    //from C program
	    wire ack_calling_decryption;

	    //not sure
	    wire [31:0] hello_world_q_byte_swapped;
	    reg  [31:0] hello_world_q_internal;
	    wire  [31:0] hello_world_q_internal_next;

//--------------------------------------------------
// xpm_fifo_sync: Synchronous FIFO
// Xilinx Parameterized Macro, version 2018.3
//--------------------------------------------------
// instantiate input fifo_key
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
	.READ_DATA_WIDTH(8),          // DECIMAL    //This design reads 16 sets of 8-bit data,key&data 16
	.READ_MODE("std"),            // String
	.USE_ADV_FEATURES("0707"),    // String
	.WAKEUP_TIME(0),              // DECIMAL
	.WRITE_DATA_WIDTH(8),         // DECIMAL    //This design reads 16 sets of 8-bit data,key&data 16
	.WR_DATA_COUNT_WIDTH(1)       // DECIMAL
	)
	key_xpm_fifo_sync_inst (
	.data_valid(ififo_key_data_valid), 
	.dout(ififo_key_dout), 
	.empty(ififo_key_empty), 
	.full(ififo_key_full),
	.din(ififo_key_din), 
	.rd_en(ififo_key_rd_en),
	.rst(~rst_main_n_sync),
	.wr_clk(clk_main_a0),
	.wr_en(ififo_key_wr_en) 
	);

//--------------------------------------------------
// instantiate input fifo_plaintext
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
	.READ_DATA_WIDTH(8),          // DECIMAL    //This design reads 16 sets of 8-bit data,key&data 16
	.READ_MODE("std"),            // String
	.USE_ADV_FEATURES("0707"),    // String
	.WAKEUP_TIME(0),              // DECIMAL
	.WRITE_DATA_WIDTH(8),         // DECIMAL    //This design reads 16 sets of 8-bit data,key&data 16
	.WR_DATA_COUNT_WIDTH(1)       // DECIMAL
	)
	plaintext_xpm_fifo_sync_inst (
	.data_valid(ififo_plaintext_data_valid), 
	.dout(ififo_plaintext_dout), 
	.empty(ififo_plaintext_empty), 
	.full(ififo_plaintext_full),
	.din(ififo_plaintext_din), 
	.rd_en(ififo_plaintext_rd_en),
	.rst(~rst_main_n_sync),
	.wr_clk(clk_main_a0),
	.wr_en(ififo_plaintext_wr_en) 
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
	.data_valid(ofifo_data_valid), 
	.dout(ofifo_dout), 
	.empty(ofifo_empty), 
	.full(ofifo_full),
	.din(ofifo_din), 
	.rd_en(ofifo_rd_en),
	.rst(~rst_main_n_sync),
	.wr_clk(clk_main_a0),
	.wr_en(ofifo_wr_en) 
	);

//---------------------------------------------
// initiate aes module
//---------------------------------------------
/*
user_cl_top_AES user_cl_top_AES_init(
	.clock(clk_main_a0),
	.rst(aes_rst),
	.data_empty(ififo_key_empty),
	.data_wr(ififo_key_rd),
	.data_din(ififo_key_dout),
	.data_full(ofifo_full),
	.data_rd(ofifo_wr),
	.data_dout(ofifo_din),
	.data_vld(aes_d_vld)
);
*/

	aes_8_bit aes_8bit_init(
	.rst(~aes_rst),				//high sensitive
	.clk(clk_main_a0),
	.key_in(ififo_key_dout), 
	.d_in(ififo_plaintext_dout),
	.d_out(ofifo_din),
	.d_vld(aes_d_vld)   
	);

//---------------------------------------------
// define states
//---------------------------------------------
localparam  IFIFO_COLLECT_KEY = 0,
            IFIFO_COLLECT_PLAINTEXT = 1,
            INIT_AES = 2,
            WAIT_ENCRYPT = 3,
            CIPHER_TEXT_READY = 4,
            DONE_BIT_FLAG = 5,
            SW_READ_FROM_OFIFO = 6;

reg [7:0] state = IFIFO_COLLECT_KEY;
reg [7:0] state_next = IFIFO_COLLECT_KEY;

//---------------------------------------------
// state machine
// combinational logic
//---------------------------------------------
always @ (*)
	begin
			 ififo_key_wr_en_next         = 1'b0;
             ififo_key_rd_en_next         = 1'b0;        
//             ififo_key_full_next          = 1'b0;
//             ififo_key_empty_next         = 1'b1; 
             ififo_plaintext_wr_en_next   = 1'b0;
             ififo_plaintext_rd_en_next   = 1'b0;
//             ififo_plaintext_full_next    = 1'b0;
//             ififo_plaintext_empty_next   = 1'b1; 
             ofifo_wr_en_next             = 1'b0;
             ofifo_rd_en_next             = 1'b0;
 //            ofifo_full_next              = 1'b0;
//             ofifo_empty_next             = 1'b1;  
             go_bit_next                  = 1'b0;         
             done_bit_next                = 1'b0;
             aes_rst_next                 = 1'b0;    
 //            aes_d_vld_next               = 1'b0;             
             rvalid_next                  = 1'b0;	

		case(state)
		IFIFO_COLLECT_KEY:
		begin
		    if(ififo_key_input_vld)	    
            ififo_key_wr_en_next = ~ififo_key_full;                 
            if (wready & (wr_addr == `FIFO_ADDR ))
			begin
				if (!ififo_key_full)
                    begin			   		
                        ififo_key_din_next = wdata;   //wdata[7:0]??	
                        ififo_key_input_vld_next = 1'b1;
                        ififo_key_wr_en_next = 1'b0;
                    end
				else begin                    // Hold Value
        				hello_world_q_internal[31:0] = hello_world_q_internal[31:0];
    				 end
			end
			
            if (!ififo_key_full) 			
                 begin
                     state_next = IFIFO_COLLECT_KEY;
                 end
            else if (ififo_key_full)             //if input-fifo is full, all key&plaintext has been collected
                 begin	
                     state_next = IFIFO_COLLECT_PLAINTEXT;  
                 end
            end
 
 		IFIFO_COLLECT_PLAINTEXT:
		begin	
			if(ififo_plaintext_input_vld)	         
            ififo_plaintext_wr_en_next = ~ififo_plaintext_full;          
            if (wready & (wr_addr == `FIFO_ADDR ))
			begin
                    if (!ififo_plaintext_full)
                    begin
                        ififo_plaintext_din_next = wdata;
                        ififo_plaintext_input_vld_next = 1'b1;
                        ififo_plaintext_wr_en_next = 1'b0;
                    end
				else begin                    // Hold Value
        				hello_world_q_internal[31:0] = hello_world_q_internal[31:0];
    				 end
			end
			
            if (!ififo_plaintext_full) 			
                 begin
                     state_next = IFIFO_COLLECT_PLAINTEXT;
                 end
            else if (ififo_plaintext_full)             //if input-fifo is full, all key&plaintext has been collected
                 begin	
                     state_next = INIT_AES;  
                 end
            end

            
	    INIT_AES: 
	    begin
	        if(ififo_key_rd_en & ififo_plaintext_rd_en)
	        go_bit  = 1'b1;		           
	    	if (!ififo_key_empty |!ififo_plaintext_empty)
                begin
                    ififo_key_rd_en_next = 1'b1;
                    ififo_plaintext_rd_en_next = 1'b1;
                    if(go_bit)
                    begin
                            aes_rst = 1'b1;
                    end
                end

			
			if (!ififo_key_empty |!ififo_plaintext_empty) 
			    
                begin
                        ififo_key_rd_en_next = 1'b1;  
                        state_next = INIT_AES; 
                end
			else if (ififo_key_empty |ififo_plaintext_empty)		//if input-fifo is empty, it indicates all data has been feed to aes module
                begin
                         ififo_key_rd_en_next = 1'b0; 
                         state_next = WAIT_ENCRYPT; 
                end		
	    end
	    	
		 WAIT_ENCRYPT: 
		    begin 
                   	go_bit  = 1'b1;	
                if (!aes_d_vld)
                    begin
                        state_next = WAIT_ENCRYPT; 
                    if(go_bit)
                        begin
                                aes_rst = 1'b1;
                        end	
                    end
                else if (aes_d_vld)
                    begin
                        go_bit     = 1'b0;
                        state_next = CIPHER_TEXT_READY; 
                        ofifo_wr_en = 1'b1;
                    end
                end
                

	    	CIPHER_TEXT_READY: 
	    	
	    	begin
	    	go_bit  = 1'b1;	
	    	ofifo_wr_en = ~ofifo_full;
                if (!ofifo_full)
                begin
                    state_next = CIPHER_TEXT_READY; 
                    if(go_bit)
                        begin
                                aes_rst = 1'b1;
                        end	
                end
			else if (ofifo_full)
                begin
                    state_next = DONE_BIT_FLAG;
                end
            end
            
            
	    	DONE_BIT_FLAG: 
	    	
	    	begin
			done_bit = ofifo_full;
			rdata[0] = done_bit;		//valid? 
			aes_rst = 0;	//aes module no longer needed, reset all signal
			ofifo_rd_en_next = ~ofifo_empty;     ///just check the output , should be comment out for ack signal!*********
	    	if (!ack_calling_decryption)    //********global define???************
			begin
				state_next = DONE_BIT_FLAG;
			end
			else if (ack_calling_decryption)
			begin
				state_next = SW_READ_FROM_OFIFO;
			end
			end

	    	SW_READ_FROM_OFIFO:
	    	begin
			ofifo_rd_en = ofifo_empty? 0:1;
			if (rvalid && rready) begin
            		rvalid = 0;
                	rdata  = 32'h00000000;
			end
			else if (arvalid_q) begin
				if (araddr_q == `FIFO_ADDR) begin
				rvalid = 1;
				rdata = ofifo_dout;			
				end
			end
	    	 if (!ofifo_empty)
			begin
				state_next = SW_READ_FROM_OFIFO;				
			end
			else if (ofifo_empty)
			begin
				state_next = IFIFO_COLLECT_KEY;        //*************go back to IFIFO_COLLECT_DATA???*********
			end
			end
		endcase
	end


//---------------------------------------------
//sequential logic
//---------------------------------------------
always @ (posedge clk_main_a0)
	begin
	if (!rst_main_n_sync)
		begin
			 state <= IFIFO_COLLECT_KEY;
			 ififo_key_wr_en            <= 1'b0;
             ififo_key_rd_en            <= 1'b0;     
             ififo_key_input_vld        <= 1'b0;  
//             ififo_key_full          <= 1'b0;
//             ififo_key_empty         <= 1'b1; 
             ififo_plaintext_wr_en      <= 1'b0;
             ififo_plaintext_rd_en      <= 1'b0;
             ififo_plaintext_input_vld  <= 1'b0;  
 //           ififo_plaintext_full    <= 1'b0;
 //            ififo_plaintext_empty   <= 1'b1; 
             ofifo_wr_en                <= 1'b0;
             ofifo_rd_en                <= 1'b0;
 //            ofifo_full              <= 1'b0;
 //            ofifo_empty             <= 1'b1;   
             go_bit                     <= 1'b0;        
             done_bit                   <= 1'b0;
             aes_rst                    <= 1'b0;                 
             rvalid                     <= 1'b0;
                  
		end
	else	begin
			state <= state_next;
			ififo_key_wr_en            <=   ififo_key_wr_en_next;
			ififo_key_rd_en            <=   ififo_key_rd_en_next;
			ififo_key_din              <=   ififo_key_din_next;
			ififo_key_input_vld        <=   ififo_key_input_vld_next;
//			ififo_key_full          <=   ififo_key_full_next;
 //           ififo_key_empty         <=   ififo_key_empty_next;
			ififo_plaintext_wr_en      <=   ififo_plaintext_wr_en_next;
			ififo_plaintext_rd_en      <=   ififo_plaintext_rd_en_next;
			ififo_plaintext_din        <=   ififo_plaintext_din_next;
			ififo_plaintext_input_vld  <=   ififo_plaintext_input_vld_next;
//			ififo_plaintext_full    <=   ififo_plaintext_full_next;
 //           ififo_plaintext_empty   <=   ififo_plaintext_empty_next;
			ofifo_wr_en                <=   ofifo_wr_en_next;
			ofifo_rd_en                <=   ofifo_rd_en_next;
//			ofifo_full              <=   ofifo_full_next;
//			ofifo_empty             <=   ofifo_empty_next;
//			ofifo_din               <=   ofifo_din_next;
            go_bit                     <=   go_bit_next;
			done_bit                   <=   done_bit_next;
			aes_rst                    <=   aes_rst_next;
//			aes_d_vld               <=   aes_d_vld_next;
			rvalid                     <=   rvalid_next;		
			hello_world_q_internal     <=   hello_world_q_internal_next;	
		end
	end


//assign hello_world_q_byte_swapped[31:0] = {hello_world_q[7:0],   hello_world_q[15:8],
//                                           hello_world_q[23:16], hello_world_q[31:24]};


//cipher text from aes module is ready for reading, C programe calling the decryption function

endmodule
