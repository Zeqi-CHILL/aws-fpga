Author:			Zeqi Qin
Date:			04/02/2019

Files description: 	
(For reading convinence, files are listed in descending interesting order)

1.write_to_fifo.v		
This is the top level of custom logic. 
The functionality is to encrypt 128-bit plaintext with 128-bit key to get 128-bit cipher text.
It can work locally on Vivado. To implemented this custom logic on AWS F1 instance in the cloud, use the reference in File 11.

2.write_to_fifo_tb.v		
This is the test bench of file1 "write_to_fifo.v".

3.aes_top.v			
This is the wrapper of aes core.

4.aes_data_path.v		
5.byte_permutation_unit.v 	
6.key_expansion.v		
7.mixcolumn.v			
8.mux.v				
9.parallel_serial_converter.v	
10.sbox_case_4.v		
File 4-10 are all sub-modules instantiated in AES core "aes_top.v".

11.cl_fifo.sv			
This is the source from AWS: Interface between Shell and Custom logic
To perfom the custom logic on F1 instance in the cloud, it requires connect the I/0 ports in custom logic with shell interface "cl_fifo.sv".
So, The custom logic "write_to_fifo.v" has been instantiated in this shell interface.
To perfom the custom logic on F1 instance in the cloud, use this file as top level to perform all the execution via the virtual machine which F1 instance launches.

12.cl_fifo_defines.vh		
This is the source from AWS: Custom logic defines.

13.cl_id_defines.vh		
This is the source from AWS: Defines for ID0 and ID1 (PCI ID's).
