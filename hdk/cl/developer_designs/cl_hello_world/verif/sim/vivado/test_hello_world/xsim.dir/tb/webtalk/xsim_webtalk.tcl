webtalk_init -webtalk_dir /home/centos/aws-fpga/hdk/cl/developer_designs/cl_hello_world/verif/sim/vivado/test_hello_world/xsim.dir/tb/webtalk/
webtalk_register_client -client project
webtalk_add_data -client project -key date_generated -value "Sat Mar 23 19:37:43 2019" -context "software_version_and_target_device"
webtalk_add_data -client project -key product_version -value "XSIM v2018.2_AR71275_op (64-bit)" -context "software_version_and_target_device"
webtalk_add_data -client project -key build_version -value "2258646" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_platform -value "LIN64" -context "software_version_and_target_device"
webtalk_add_data -client project -key registration_id -value "" -context "software_version_and_target_device"
webtalk_add_data -client project -key tool_flow -value "xsim" -context "software_version_and_target_device"
webtalk_add_data -client project -key beta -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key route_design -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_family -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_device -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_package -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_speed -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key random_id -value "84acbd6e-6a3a-4f92-aaa7-c6b9d87b9201" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_id -value "670e24c3-4b73-414d-b73d-820b196c9237" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_iteration -value "6" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_name -value "CentOS" -context "user_environment"
webtalk_add_data -client project -key os_release -value "CentOS Linux release 7.6.1810 (Core)" -context "user_environment"
webtalk_add_data -client project -key cpu_name -value "Intel(R) Xeon(R) CPU E5-2666 v3 @ 2.90GHz" -context "user_environment"
webtalk_add_data -client project -key cpu_speed -value "2900.016 MHz" -context "user_environment"
webtalk_add_data -client project -key total_processors -value "1" -context "user_environment"
webtalk_add_data -client project -key system_ram -value "31.000 GB" -context "user_environment"
webtalk_register_client -client xsim
webtalk_add_data -client xsim -key Command -value "xsim" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key trace_waveform -value "true" -context "xsim\\usage"
webtalk_add_data -client xsim -key runtime -value "5330 ns" -context "xsim\\usage"
webtalk_add_data -client xsim -key iteration -value "0" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Time -value "13.17_sec" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Memory -value "242512_KB" -context "xsim\\usage"
webtalk_transmit -clientid 1107678211 -regid "" -xml /home/centos/aws-fpga/hdk/cl/developer_designs/cl_hello_world/verif/sim/vivado/test_hello_world/xsim.dir/tb/webtalk/usage_statistics_ext_xsim.xml -html /home/centos/aws-fpga/hdk/cl/developer_designs/cl_hello_world/verif/sim/vivado/test_hello_world/xsim.dir/tb/webtalk/usage_statistics_ext_xsim.html -wdm /home/centos/aws-fpga/hdk/cl/developer_designs/cl_hello_world/verif/sim/vivado/test_hello_world/xsim.dir/tb/webtalk/usage_statistics_ext_xsim.wdm -intro "<H3>XSIM Usage Report</H3><BR>"
webtalk_terminate
