module write_to_adder(
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

//define wires

	reg [31:0] hello_world_q_internal;
	wire [31:0] hello_world_q_byte_swapped;
	assign hello_world_q = hello_world_q_internal;

	reg  [3:0] add_in1;
	reg  [3:0] add_in2;
	wire [4:0] add_out;

//instantiate CL logic
adder adder_inst(
	.clock (clk_main_a0),
	.reset (rst_main_n_sync),
	.add_in1 (add_in1),
	.add_in2 (add_in2),
	.add_out (add_out)
	);

//write inputs to CL
always @(posedge clk_main_a0) begin
    if (!rst_main_n_sync) begin                    	 // Reset
        hello_world_q_internal[31:0] <= 32'h0000_0000;
    end
    else if (wready & (wr_addr == `HELLO_WORLD_REG_ADDR || wr_addr == `PLUS_ONE_ADDR || wr_addr == `TIMES_TWO_ADDR)) begin
        hello_world_q_internal[31:0] <= wdata[31:0];
    end
    else if (wready & (wr_addr == `FIFO_ADDR)) begin     //write data to CL
		add_in1 <= wdata[3:0];
		add_in2 <= wdata[7:4];	
    end
    else begin                                		  // Hold Value
        hello_world_q_internal[31:0] <= hello_world_q_internal[31:0];
    end
end

assign hello_world_q_byte_swapped[31:0] = {hello_world_q_internal[7:0],   hello_world_q_internal[15:8],
                                           hello_world_q_internal[23:16], hello_world_q_internal[31:24]};

//read outputs from CL
always @(posedge clk_main_a0) begin
   if (!rst_main_n_sync)
   begin
      rvalid <= 0;
      rdata  <= 0;
      rresp  <= 0;
   end
   else if (rvalid && rready)
   begin
      rvalid <= 0;
      rdata  <= 0;
      rresp  <= 0;
   end
   else if (arvalid_q) 
   begin
      rvalid <= 1;
      rdata  <= (araddr_q == `FIFO_ADDR) ? add_out:
                (araddr_q == `VLED_REG_ADDR       ) ? {16'b0,vled_q[15:0]            }:
                                                      `UNIMPLEMENTED_REG_VALUE        ;
      rresp  <= 0;
   end
end

/*
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
        rdata  <= 32'h0000000a;
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
                rdata  <= 32'h000000a0;
                not_waiting_for_fifo <= 1;
                state <= IDLE;
            end
        	else if (arvalid_q && not_waiting_for_fifo) begin
        		if((araddr_q == `FIFO_ADDR) && !fifo_fifotest_to_cl_empty) begin
        			fifo_fifotest_to_cl_rd <= 1; 
        			not_waiting_for_fifo <= 0;
        			rdata <= 32'h00000a00;
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
