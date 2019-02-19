`define RO_ADDR			32'h0000_0508
`define HELLO_WORLD_REG_ADDR    32'h0000_0500
`define VLED_REG_ADDR           32'h0000_0504
`define UNIMPLEMENTED_REG_VALUE 32'hdeaddead
module enable_RO(
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

powerwaster powerwaster_inst #(parameter N_PWELEMS = 1)(
    .enable(enable),
    .pw_out(pw_out)
    );

reg [31:0] hello_world_q_internal;
wire [31:0] hello_world_q_byte_swapped;
assign hello_world_q = hello_world_q_internal;

reg enable;
wire pw_out;

always @(posedge clk_main_a0)
   if (!rst_main_n_sync) begin                    // Reset
      hello_world_q_internal[31:0] <= 32'h0000_0000;
   end
   else if (wready & (wr_addr == `HELLO_WORLD_REG_ADDR)) begin  
      hello_world_q_internal[31:0] <= wdata[31:0];
   end
   else if (wready & (wr_addr == `RO_ADDR)) begin
      enable <= wdata[31:0];
   end
   else begin                                // Hold Value
      hello_world_q_internal[31:0] <= hello_world_q_internal[31:0];
   end

assign hello_world_q_byte_swapped[31:0] = {hello_world_q[7:0],   hello_world_q[15:8],
                                           hello_world_q[23:16], hello_world_q[31:24]};

always @(posedge clk_main_a0)
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
      rdata  <= (araddr_q == `HELLO_WORLD_REG_ADDR) ? hello_world_q_byte_swapped[31:0]:
		(araddr_q == `RO_ADDR) ? pw_out:
                (araddr_q == `VLED_REG_ADDR       ) ? {16'b0,vled_q[15:0]            }:
                                                      `UNIMPLEMENTED_REG_VALUE        ;
      rresp  <= 0;
   end
