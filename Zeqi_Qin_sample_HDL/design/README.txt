Author:			Zeqi Qin
Date:			04/01/2019
Files description: 	/*For reading convinence, files are listed in descending interesting order*/
			write_to_fifo.v			//top level of custom logic: warpper of FIFO and AES
			aes_top.v			//top level of AES module
			aes_data_path.v			//sub-module instantiated in AES 
			byte_permutation_unit.v 	//sub-module instantiated in AES
			key_expansion.v			//sub-module instantiated in AES
			mixcolumn.v			//sub-module instantiated in AES
			mux.v				//sub-module instantiated in AES
			parallel_serial_converter.v	//sub-module instantiated in AES
			sbox_case_4.v			//sub-module instantiated in AES
			cl_fifo.sv			//source from AWS: Interface between Shell and Custom logic
			cl_fifo_defines.vh		//source from AWS: Custom logic defines
			cl_id_defines.vh		//source from AWS: Defines for ID0 and ID1 (PCI ID's)
