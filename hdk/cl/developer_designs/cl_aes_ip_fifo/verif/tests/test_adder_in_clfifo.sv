module test_adder_in_clfifo();

import tb_type_defines_pkg::*;
`include "cl_common_defines.vh" // CL Defines with register addresses

// AXI ID
parameter [5:0] AXI_ID = 6'h0;

logic [31:0] rdata;
logic [15:0] vdip_value;
logic [15:0] vled_value;
`define FIFO_ADDR               32'h0000_0510

   initial begin

      tb.power_up();

      tb.set_virtual_dip_switch(.dip(0));

      vdip_value = tb.get_virtual_dip_switch();

      $display ("value of vdip:%0x", vdip_value);

      $display ("Writing 0x0000012 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h00000012), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      if (rdata == 32'h00000003) // Check for byte addition in register read
        $display ("TEST PASSED");
      else
        $display ("TEST FAILED");

      tb.peek_ocl(.addr(`VLED_REG_ADDR), .data(rdata));         // start read
      $display ("Reading 0x%x from address 0x%x", rdata, `VLED_REG_ADDR);

      if (rdata == 32'h0000_BEEF) // Check for LED register read
        $display ("TEST PASSED");
      else
        $display ("TEST FAILED");

      vled_value = tb.get_virtual_led();

      $display ("value of vled:%0x", vled_value);

      tb.kernel_reset();

      tb.power_down();
      
      $finish;
   end

endmodule // test_cl_adder
