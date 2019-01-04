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

FIFO_Shanquan fifo_cl_to_fifotest_inst(
    .clock (clk_main_a0),
    .reset (~rst_main_n_sync),
    .wr (fifo_cl_to_fifotest_wr),
    .rd (fifo_cl_to_fifotest_rd),
    .din (fifo_cl_to_fifotest_din),
    .empty (fifo_cl_to_fifotest_empty),
    .full (fifo_cl_to_fifotest_full),
    .dout (fifo_cl_to_fifotest_dout),
    .size (fifo_cl_to_fifotest_size)// debug
    );

FIFO_Shanquan fifo_fifotest_to_cl_inst(
    .clock (clk_main_a0),
    .reset (~rst_main_n_sync),
    .wr (fifo_fifotest_to_cl_wr),
    .rd (fifo_fifotest_to_cl_rd),
    .din (fifo_fifotest_to_cl_din),
    .empty (fifo_fifotest_to_cl_empty),
    .full (fifo_fifotest_to_cl_full),
    .dout (fifo_fifotest_to_cl_dout),
    .size (fifo_fifotest_to_cl_size)// debug
    );

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
//define wires
reg fifo_fifotest_to_cl_rd;
reg  [31:0] fifo_cl_to_fifotest_din;
reg fifo_cl_to_fifotest_wr;


wire fifo_cl_to_fifotest_rd;
wire fifo_cl_to_fifotest_empty;
wire fifo_cl_to_fifotest_full;
wire [31:0] fifo_cl_to_fifotest_dout;
wire [7:0] fifo_cl_to_fifotest_size;

wire fifo_fifotest_to_cl_wr;
wire [31:0] fifo_fifotest_to_cl_din;
wire fifo_fifotest_to_cl_empty;
wire fifo_fifotest_to_cl_full;
wire [31:0] fifo_fifotest_to_cl_dout;
wire [7:0] fifo_fifotest_to_cl_size;



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



endmodule
