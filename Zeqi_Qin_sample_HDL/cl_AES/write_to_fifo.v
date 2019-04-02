//***********************************************************************************************
//Project: 	cl_AES_128
//Author:	Zeqi Qin
//Date:		03/15/2019
//Revision:	03/28/2019
//Module Name:  write_to_fifo
//Description:  -This is the wrapper of AES core and FIFO bridge, which can 
//		 be simulate by the testbench "write_to_fifo_tb.v". 
//		-A state machine is built to transfer data between FIFO and AES core.
//Additional Comments:
//		-Why we need FIFO bridge: The AES core requires 16 sets of 8-bit
//	 	 key(16*8=128) and 8-bit plaintext(16*8=128) to be feeded in continuous
//		 clock cycles. Therefore two input-FIFO(one for key, the other for 
//		 plaintext) will be used to store input data untill we collect all 16 sets
//		 of them and then feed them to AES core. Samething for the output, an output-FIFO
// 		 will be used to collect all 16sets of cipher text(128-bit) and then read it out.
//***********************************************************************************************

`define FIFO_ADDR               32'h0000_0510		//here we define the register address where we would write the input data

module write_to_fifo #( 
parameter FIFO_WIDTH = 8,				//define parameter. For each fifo, each input data is 8-bit 
parameter FIFO_DEPTH = 16				//define parameter. For each fifo, we need 16 sets of 8-bit 
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
//declare wire&reg
//-------------------------------------------------

    	//ififo_key
	reg   [(FIFO_WIDTH-1):0] ififo_key_din;
	reg   ififo_key_wr_en;
	reg   ififo_key_rd_en;
	wire  [(FIFO_WIDTH-1):0] ififo_key_dout;
	wire  ififo_key_full;
	wire  ififo_key_empty;
	reg   ififo_key_input_vld;
	wire  ififo_key_data_valid;

    	//ififo_plaintext
	reg   [(FIFO_WIDTH-1):0] ififo_plaintext_din;
	reg   ififo_plaintext_wr_en;
	reg   ififo_plaintext_rd_en;
	wire  [(FIFO_WIDTH-1):0] ififo_plaintext_dout;
	wire  ififo_plaintext_full;
	wire  ififo_plaintext_empty;
	reg   ififo_plaintext_input_vld;
	wire  ififo_plaintext_data_valid;
	
	//ofifo
	wire  [(FIFO_WIDTH-1):0] ofifo_din;
	reg   ofifo_wr_en;
	reg   ofifo_rd_en;
	wire  [(FIFO_WIDTH-1):0] ofifo_dout;
	wire  ofifo_full;
	wire  ofifo_empty;
	wire  ofifo_data_valid;

	//aes_module
	wire  aes_d_vld;
	reg   aes_rst;
	reg   go_bit;
	reg   done_bit;
	    
	//all the next
	reg  ififo_key_wr_en_next;        
        reg  ififo_key_rd_en_next;    
        reg  [(FIFO_WIDTH-1):0] ififo_key_din_next;               
	reg  ififo_key_full_next;           
        reg  ififo_key_empty_next;  
        reg  ififo_key_input_vld_next;
        reg  ififo_plaintext_wr_en_next;    
        reg  ififo_plaintext_rd_en_next; 
        reg  [(FIFO_WIDTH-1):0] ififo_plaintext_din_next;     
        reg  ififo_plaintext_full_next;     
        reg  ififo_plaintext_empty_next; 
        reg  ififo_plaintext_input_vld_next; 
        reg  ofifo_wr_en_next;              
        reg  ofifo_rd_en_next;    
        reg  ofifo_din_next;    
        reg  ofifo_full_next;               
        reg  ofifo_empty_next;    
        reg  go_bit_next;                     
        reg  done_bit_next;                 
        reg  aes_rst_next;    
        reg  rvalid_next;   

	//I define a hello_world_register to easy check the logic if need
        wire [31:0] hello_world_q_byte_swapped;
        reg  [31:0] hello_world_q_internal;
        wire [31:0] hello_world_q_internal_next;

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
	.FIFO_WRITE_DEPTH(16),        // DECIMAL    //This design needs 16 sets of 8-bit key. So define FIFO_DEPTH as 16
	.FULL_RESET_VALUE(0),         // DECIMAL
	.PROG_EMPTY_THRESH(8),        // DECIMAL
	.PROG_FULL_THRESH(8),         // DECIMAL
	.RD_DATA_COUNT_WIDTH(1),      // DECIMAL
	.READ_DATA_WIDTH(8),          // DECIMAL    //This design reads 16 sets of 8-bit key. So define READ_DATA_WIDTH as 8
	.READ_MODE("std"),            // String
	.USE_ADV_FEATURES("0707"),    // String
	.WAKEUP_TIME(0),              // DECIMAL
	.WRITE_DATA_WIDTH(8),         // DECIMAL    //This design reads 16 sets of 8-bit key. WR_DATA_WIDTH = READ_DATA_WIDTH = 8
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
	.FIFO_WRITE_DEPTH(16),        // DECIMAL    //This design needs 16 sets of input plaintext. So define FIFO_DEPTH as 16
	.FULL_RESET_VALUE(0),         // DECIMAL
	.PROG_EMPTY_THRESH(8),        // DECIMAL
	.PROG_FULL_THRESH(8),         // DECIMAL
	.RD_DATA_COUNT_WIDTH(1),      // DECIMAL
	.READ_DATA_WIDTH(8),          // DECIMAL    //This design reads 16 sets of 8-bit plaintext. So define READ_DATA_WIDTH as 8
	.READ_MODE("std"),            // String
	.USE_ADV_FEATURES("0707"),    // String
	.WAKEUP_TIME(0),              // DECIMAL
	.WRITE_DATA_WIDTH(8),         // DECIMAL    //This design reads 16 sets of 8-bit plaintext. WR_DATA_WIDTH = READ_DATA_WIDTH = 8
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
	.FIFO_WRITE_DEPTH(16),        // DECIMAL    //This design needs 16 sets of output data
	.FULL_RESET_VALUE(0),         // DECIMAL
	.PROG_EMPTY_THRESH(8),        // DECIMAL
	.PROG_FULL_THRESH(8),         // DECIMAL
	.RD_DATA_COUNT_WIDTH(1),      // DECIMAL
	.READ_DATA_WIDTH(16),         // DECIMAL    //This design reads 16 sets of 8-bit ciphertext
	.READ_MODE("std"),            // String
	.USE_ADV_FEATURES("0707"),    // String
	.WAKEUP_TIME(0),              // DECIMAL
	.WRITE_DATA_WIDTH(16),        // DECIMAL    //This design reads 16 sets of 8-bit ciphertext
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

	aes_8_bit aes_8bit_init(
	.rst(~aes_rst),				    //This module is designed as low sensitive reset, while aes core is high sensitive reset, so that reverse the reset signal in the instantiation
	.clk(clk_main_a0),
	.key_in(ififo_key_dout), 		    
	.d_in(ififo_plaintext_dout),		    
	.d_out(ofifo_din),			    
	.d_vld(aes_d_vld)   		 	    //d_out is available to read when d_vld=1
	);

//---------------------------------------------
// state machine
//---------------------------------------------
// define states
//---------------------------------------------
localparam  IFIFO_COLLECT_KEY = 0,		    //state: FIFO1 is collecting key			
            IFIFO_COLLECT_PLAINTEXT = 1,	    //state: FIFO2 is collecting plaintext
            INIT_AES = 2,			    //state: all 128 key&plaintext are collected, release the reset signal in aes core
            WAIT_ENCRYPT = 3,			    //state: wait the aes core do the encryption
            CIPHER_TEXT_READY = 4,		    //state: ciphertext are ready when d_vld in aes core is equal to 1
            DONE_BIT_FLAG = 5,


reg [7:0] state = IFIFO_COLLECT_KEY;
reg [7:0] state_next = IFIFO_COLLECT_KEY;

//---------------------------------------------
// combinational logic
//---------------------------------------------
always @ (*)
	begin
	     ififo_key_wr_en_next         = 1'b0;   			//default settings in combinational logic
             ififo_key_rd_en_next         = 1'b0;        
             ififo_plaintext_wr_en_next   = 1'b0;
             ififo_plaintext_rd_en_next   = 1'b0;
             ofifo_wr_en_next             = 1'b0;
             ofifo_rd_en_next             = 1'b0;
             go_bit_next                  = 1'b0;         
             done_bit_next                = 1'b0;
             aes_rst_next                 = 1'b0;              
             rvalid_next                  = 1'b0;	

	     case(state)
	     
		IFIFO_COLLECT_KEY:
		begin
		    if(ififo_key_input_vld)	    			
            	       ififo_key_wr_en_next = ~ififo_key_full;                 
            	    if (wready & (wr_addr == `FIFO_ADDR ))
			begin
			   if (!ififo_key_full)				//write the key into fifo_key
                    	   begin			   		
			        ififo_key_din_next = wdata;   		
			        ififo_key_input_vld_next = 1'b1;
			        ififo_key_wr_en_next = 1'b0;
                    	   end
		       	   else begin					//Hold value in hello_register to aviod latch
        				hello_world_q_internal[31:0] = hello_world_q_internal[31:0];	
    				end
			end
			
           	    if (!ififo_key_full) 			
		         begin
		             state_next = IFIFO_COLLECT_KEY;		//keep the state in collecting KEY before the fifo_key is full
		         end
		    else if (ififo_key_full)                  		//if input-fifo is full, all 128-bit key has been collected
		         begin	
		             state_next = IFIFO_COLLECT_PLAINTEXT;  	//transfer the state to collect plaintext untill the fifo_key is full
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
		                ififo_plaintext_din_next = wdata;	//write the plaintext into fifo_plaintext
		                ififo_plaintext_input_vld_next = 1'b1;
		                ififo_plaintext_wr_en_next = 1'b0;
		            end
			else begin                   			// Hold Value to avoid latch
        				hello_world_q_internal[31:0] = hello_world_q_internal[31:0];
    			     end
		    end
			
		    if (!ififo_plaintext_full) 			
		         begin
		             state_next = IFIFO_COLLECT_PLAINTEXT;	//keep the state in collecting plaintext before the fifo_plaintext is full
		         end
		    else if (ififo_plaintext_full)             		//if input-fifo is full, all 128-bit plaintext has been collected
		         begin	
		             state_next = INIT_AES;  			//transfer the state to initilize the aes core (release the aes_reset signal)
		         end
		    end

            
		 INIT_AES: 
		 begin
		    if (ififo_key_rd_en & ififo_plaintext_rd_en)
			go_bit  = 1'b1;		           		//go_bit to flag that key&plaintext are started to feed in aes core
		    if (!ififo_key_empty |!ififo_plaintext_empty)
		        begin
		            ififo_key_rd_en_next = 1'b1;		//keep feeding the key&plaintext to aes core untill all data have been read
		            ififo_plaintext_rd_en_next = 1'b1;
		            if(go_bit)
		            begin
		                    aes_rst = 1'b1;			//release the reset signal to initilize the aes core
		            end
			    else begin
				    aes_rst = 1'b0;
			    end
		        end

			
		    if (!ififo_key_empty |!ififo_plaintext_empty) 	    
		        begin
		                ififo_key_rd_en_next = 1'b1;  
		                ififo_plaintext_rd_en_next = 1'b1;  
		                state_next = INIT_AES; 			//keep the state in init_aes until all data have been feed in aes core
		        end
		    else if (ififo_key_empty |ififo_plaintext_empty)	//if input-fifo is empty, it indicates all data has been feed to aes module
		        begin
		                 ififo_key_rd_en_next = 1'b0; 
		                 ififo_plaintext_rd_en_next = 1'b0;  
		                 state_next = WAIT_ENCRYPT; 		//transfer the state to wait for the ciphertext calculation
		        end		
	    	  end
	    	
		 
	          WAIT_ENCRYPT: 
		  begin 
                   	go_bit  = 1'b1;	
                     if (!aes_d_vld)					//keep the state in wait for ciphertext calculation if d_vld=0
                        begin
		                state_next = WAIT_ENCRYPT; 
		                if(go_bit)
		                begin
		                        aes_rst = 1'b1;
		                end	
                        end
                     else if (aes_d_vld)				//here to wait the aes_d_vld signal to indicate the available ciphertext 
                     begin
                        go_bit     = 1'b0;
                        state_next = CIPHER_TEXT_READY; 		//transfer the state to cipher_text_ready once d_vld=1 
                        ofifo_wr_en = 1'b1;
                     end
                   end
                

	    	CIPHER_TEXT_READY:
	    	begin
		    	go_bit  = 1'b1;	
		    	ofifo_wr_en = ~ofifo_full;			//the output fifo is ready to write the ciphertext in
               	   if (!ofifo_full)
		        begin
		            state_next = CIPHER_TEXT_READY; 
		            if(go_bit)
		                begin
		                        aes_rst = 1'b1;
		                end	
		        end
		   else if (ofifo_full)					//output_fifo_full indicates that 128-bit ciphertext has been collected 
		        begin
		            state_next = DONE_BIT_FLAG;
		        end
                end
            
            
	    	DONE_BIT_FLAG: 
	    	begin
			done_bit = ofifo_full;
			rdata[0] = done_bit;				//ciphertext valid, will use this signal to invoke other function in the future
			aes_rst = 0;					//aes module no longer needed, reset all signal
			ofifo_rd_en_next = ~ofifo_empty;     		//enable read operation to read the ciphertext until output fifo is empty

		endcase
	end


//---------------------------------------------
//sequential logic
//---------------------------------------------
always @ (posedge clk_main_a0)
	begin
	if (!rst_main_n_sync)
	     begin
		     state <= IFIFO_COLLECT_KEY;			//reset settings
	     	     ififo_key_wr_en            <= 	1'b0;
		     ififo_key_rd_en            <= 	1'b0;     
		     ififo_key_input_vld        <= 	1'b0;  
		     ififo_plaintext_wr_en      <= 	1'b0;
		     ififo_plaintext_rd_en      <= 	1'b0;
		     ififo_plaintext_input_vld  <= 	1'b0;  
		     ofifo_wr_en                <= 	1'b0;
		     ofifo_rd_en                <= 	1'b0;
		     go_bit                     <= 	1'b0;        
		     done_bit                   <= 	1'b0;
		     aes_rst                    <= 	1'b0;                 
		     rvalid                     <= 	1'b0;  
	     end
	else begin
		     state <= state_next;				//update the signal at posedge clock
		     ififo_key_wr_en            <=   	ififo_key_wr_en_next;
		     ififo_key_rd_en            <=   	ififo_key_rd_en_next;
		     ififo_key_din              <=   	ififo_key_din_next;
		     ififo_key_input_vld        <=   	ififo_key_input_vld_next;
		     ififo_plaintext_wr_en      <=  	ififo_plaintext_wr_en_next;
		     ififo_plaintext_rd_en      <=  	ififo_plaintext_rd_en_next;
		     ififo_plaintext_din        <=   	ififo_plaintext_din_next;
		     ififo_plaintext_input_vld  <=   	ififo_plaintext_input_vld_next;
		     ofifo_wr_en                <=   	ofifo_wr_en_next;
		     ofifo_rd_en                <=   	ofifo_rd_en_next;
           	     go_bit                     <=   	go_bit_next;
		     done_bit                   <=   	done_bit_next;
		     aes_rst                    <=   	aes_rst_next;
		     rvalid                     <=   	rvalid_next;		
		     hello_world_q_internal     <=   	hello_world_q_internal_next;	
	      end
	end

endmodule
