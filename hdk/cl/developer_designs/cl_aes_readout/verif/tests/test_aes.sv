// Amazon FPGA Hardware Development Kit
//
// Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License"). You may not use
// this file except in compliance with the License. A copy of the License is
// located at
//
//    http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
// implied. See the License for the specific language governing permissions and
// limitations under the License.


module test_aes();

import tb_type_defines_pkg::*;
`include "cl_common_defines.vh" // CL Defines with register addresses

// AXI ID
parameter [5:0] AXI_ID = 6'h0;

logic [31:0] rdata;
logic [15:0] vdip_value;
logic [15:0] vled_value;


   initial begin

      tb.power_up();

      tb.set_virtual_dip_switch(.dip(0));

      vdip_value = tb.get_virtual_dip_switch();

//      $display ("value of vdip:%0x", vdip_value);

      $display ("Writing KEY START");

      $display ("Writing KEY:0x0000_0000 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0000), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("THIS SHOULD BE COMMENT OUT AFTER TEST");
       tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      $display ("Writing KEY:0x0000_0001 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0001), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("THIS SHOULD BE COMMENT OUT AFTER TEST");
       tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      $display ("Writing KEY:0x0000_0002 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0002), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_0003 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0003), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_0004 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0004), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_0005 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0005), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_0006 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0006), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_0007 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0007), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_0008 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0008), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_0009 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0009), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_000A to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_000A), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_000B to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_000B), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_000C to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_000C), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_000D to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_000D), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_000E to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_000E), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY:0x0000_000F to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_000F), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing KEY COMPLETE");

      $display ("Writing PLAINTEXT START");

      $display ("Writing PLAINTEXT:0x0000_0000 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0000), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_0011 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0011), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_0022 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0022), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_0033 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0033), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_0044 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0044), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_0055 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0055), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_0066 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0066), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_0077 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0077), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_0088 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0088), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_0099 to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_0099), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_00AA to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_00AA), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_00BB to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_00BB), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_00CC to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_00CC), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_00DD to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_00DD), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_00EE to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_00EE), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT:0x0000_00FF to address 0x%x", `FIFO_ADDR);
      tb.poke(.addr(`FIFO_ADDR), .data(32'h0000_00FF), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register

      $display ("Writing PLAINTEXT COMPLETE");

      $display ("WAITING FOR ENCRYPTION...");

      $display ("Reading CIPHERTEXT:");

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      tb.peek(.addr(`FIFO_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
      $display ("Reading 0x%x from address 0x%x", rdata, `FIFO_ADDR);

      if (rdata == 32'h0000_005A) // Check ciphertext
        $display ("TEST PASSED");
      else
        $display ("TEST FAILED");
/*
      tb.peek_ocl(.addr(`VLED_REG_ADDR), .data(rdata));         // start read
      $display ("Reading 0x%x from address 0x%x", rdata, `VLED_REG_ADDR);

      if (rdata == 32'h0000_BEEF) // Check for LED register read
        $display ("TEST PASSED");
      else
        $display ("TEST FAILED");

      vled_value = tb.get_virtual_led();

        $display ("value of vled:%0x", vled_value);
*/
      tb.kernel_reset();

      tb.power_down();
      
      $finish;
   end

endmodule // test_aes
