# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "./.Xil/Vivado-3268-ip-172-31-18-31.ec2.internal/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    set rt::partid xcvu9p-flgb2104-2-i

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common_vhdl.tcl
    set rt::defaultWorkLibName xil_defaultlib

    # Skipping read_* RTL commands because this is post-elab optimize flow
    set rt::useElabCache true
    if {$rt::useElabCache == false} {
      rt::read_verilog -sv -include {
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/src_register_slice/hdl
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/dest_register_slice/hdl
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/axi_register_slice/hdl
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_vio_counter/hdl/verilog
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/vio_0/hdl/verilog
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/vio_0/hdl
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/cl_debug_bridge/bd_0/ip/ip_0/hdl/verilog
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_0/hdl/verilog
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/axi_register_slice_light/hdl
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/interfaces
  } -define XSDB_SLV_DIS {
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/sh_ddr/synth/ccf_ctl.v
      /home/centos/aws-fpga/hdk/cl/developer_designs/cl_fifo_selfadd/build/src_post_encryption/cl_fifo.sv
      /home/centos/aws-fpga/hdk/cl/developer_designs/cl_fifo_selfadd/build/src_post_encryption/fifo_shanquan.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/sh_ddr/synth/flop_ccf.sv
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/lib/lib_pipe.sv
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/sh_ddr/synth/sh_ddr.sv
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/sh_ddr/synth/sync.v
      /home/centos/aws-fpga/hdk/cl/developer_designs/cl_fifo_selfadd/build/src_post_encryption/user_cl_top.v
      /home/centos/aws-fpga/hdk/cl/developer_designs/cl_fifo_selfadd/build/src_post_encryption/write_to_fifo.v
      /opt/Xilinx/Vivado/2018.2.op2258646/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv
      /opt/Xilinx/Vivado/2018.2.op2258646/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv
    }
      rt::read_verilog -include {
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/src_register_slice/hdl
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/dest_register_slice/hdl
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/axi_register_slice/hdl
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_vio_counter/hdl/verilog
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/vio_0/hdl/verilog
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/vio_0/hdl
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/cl_debug_bridge/bd_0/ip/ip_0/hdl/verilog
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_0/hdl/verilog
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/axi_register_slice_light/hdl
    /home/centos/aws-fpga/hdk/common/shell_v04261818/design/interfaces
  } -define XSDB_SLV_DIS {
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/src_register_slice/hdl/axi_infrastructure_v1_1_vl_rfs.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/src_register_slice/hdl/axi_register_slice_v2_1_vl_rfs.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/src_register_slice/synth/src_register_slice.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/dest_register_slice/synth/dest_register_slice.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/axi_register_slice/synth/axi_register_slice.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_vio_counter/hdl/ltlib_v1_0_vl_rfs.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_vio_counter/hdl/xsdbs_v1_0_vl_rfs.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_vio_counter/hdl/xsdbm_v3_0_vl_rfs.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_vio_counter/hdl/ila_v6_2_syn_rfs.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_vio_counter/synth/ila_vio_counter.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/vio_0/hdl/xsdbm_v2_0_vl_rfs.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/vio_0/hdl/vio_v3_0_syn_rfs.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/vio_0/synth/vio_0.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/cl_debug_bridge/bd_0/ip/ip_0/synth/bd_a493_xsdbm_0.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/cl_debug_bridge/bd_0/ip/ip_1/hdl/lut_buffer_v2_0_vl_rfs.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/cl_debug_bridge/bd_0/ip/ip_1/synth/bd_a493_lut_buffer_0.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/cl_debug_bridge/bd_0/synth/bd_a493.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/cl_debug_bridge/synth/cl_debug_bridge.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_0/synth/ila_0.v
      /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/axi_register_slice_light/synth/axi_register_slice_light.v
    }
      rt::read_vhdl -lib blk_mem_gen_v8_3_6 /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_vio_counter/hdl/blk_mem_gen_v8_3_vhsyn_rfs.vhd
      rt::read_vhdl -lib fifo_generator_v13_1_4 /home/centos/aws-fpga/hdk/common/shell_v04261818/design/ip/ila_vio_counter/hdl/fifo_generator_v13_1_vhsyn_rfs.vhd
      rt::read_vhdl -lib xpm /opt/Xilinx/Vivado/2018.2.op2258646/data/ip/xpm/xpm_VCOMP.vhd
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification true
    set rt::SDCFileList ./.Xil/Vivado-3268-ip-172-31-18-31.ec2.internal/realtime/cl_fifo_synth.xdc
    rt::sdcChecksum
    set rt::top cl_fifo
    rt::set_parameter enableIncremental true
    set rt::ioInsertion false
    set rt::reportTiming false
    rt::set_parameter elaborateOnly false
    rt::set_parameter elaborateRtl false
    rt::set_parameter eliminateRedundantBitOperator true
    rt::set_parameter elaborateRtlOnlyFlow false
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter ramStyle auto
    rt::set_parameter merge_flipflops false
    rt::set_parameter maxURamCascChainLength 2
# MODE: out_of_context
    rt::set_parameter webTalkPath {}
    rt::set_parameter enableSplitFlowPath "./.Xil/Vivado-3268-ip-172-31-18-31.ec2.internal/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
        set oldMIITMVal [rt::get_parameter maxInputIncreaseToMerge]; rt::set_parameter maxInputIncreaseToMerge 1000
        set oldCDPCRL [rt::get_parameter createDfgPartConstrRecurLimit]; rt::set_parameter createDfgPartConstrRecurLimit 1
        $rt::db readXRFFile
      rt::run_synthesis -module $rt::top
        rt::set_parameter maxInputIncreaseToMerge $oldMIITMVal
        rt::set_parameter createDfgPartConstrRecurLimit $oldCDPCRL
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    rt::HARTNDb_reportJobStats "Synthesis Optimization Runtime"
    rt::HARTNDb_stopSystemStats
    if { $rt::flowresult == 1 } { return -code error }


  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  rt::set_parameter helper_shm_key "" 
    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }

    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}
