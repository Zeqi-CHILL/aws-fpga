cl_AES

Original AES module:
afi-074664911c14799d0
agfi-0130662ea23a9d541
Test Feedback: Outputs are available but the value are not the same as in the local simulation.

AES module with the timing conflicts of "cnt" fixed:
afi-00df394e7d20f83aa
agfi-0ff78efa28905f228
Test Feedback: Outputs are not availble.

the simulation of AES with FIFO can be found in user_cl_top_AES_with_fifo_local_test.vcd
Simulate top file: write_to_fifo.v
Testbench:write_to_fifo_tb.v
