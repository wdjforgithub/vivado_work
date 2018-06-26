# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/wdj/source/vivado_work/helloworld/helloworld.cache/wt [current_project]
set_property parent.project_path C:/Users/wdj/source/vivado_work/helloworld/helloworld.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
set_property ip_output_repo c:/Users/wdj/source/vivado_work/helloworld/helloworld.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib C:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/hdl/helloworldip_wrapper.v
add_files C:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/helloworldip.bd
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_microblaze_0_0/helloworldip_microblaze_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_microblaze_0_0/helloworldip_microblaze_0_0_ooc_debug.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_microblaze_0_0/helloworldip_microblaze_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_mdm_1_0/helloworldip_mdm_1_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_mdm_1_0/helloworldip_mdm_1_0_ooc_trace.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_mdm_1_0/helloworldip_mdm_1_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_clk_wiz_1_0/helloworldip_clk_wiz_1_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_clk_wiz_1_0/helloworldip_clk_wiz_1_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_clk_wiz_1_0/helloworldip_clk_wiz_1_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_rst_clk_wiz_1_100M_0/helloworldip_rst_clk_wiz_1_100M_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_rst_clk_wiz_1_100M_0/helloworldip_rst_clk_wiz_1_100M_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_rst_clk_wiz_1_100M_0/helloworldip_rst_clk_wiz_1_100M_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_axi_uartlite_0_0/helloworldip_axi_uartlite_0_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_axi_uartlite_0_0/helloworldip_axi_uartlite_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_axi_uartlite_0_0/helloworldip_axi_uartlite_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_mig_7series_0_0_1/helloworldip_mig_7series_0_0/user_design/constraints/helloworldip_mig_7series_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_mig_7series_0_0_1/helloworldip_mig_7series_0_0/user_design/constraints/helloworldip_mig_7series_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_mig_7series_0_0_1/helloworldip_mig_7series_0_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_rst_mig_7series_0_81M_1/helloworldip_rst_mig_7series_0_81M_1_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_rst_mig_7series_0_81M_1/helloworldip_rst_mig_7series_0_81M_1.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_rst_mig_7series_0_81M_1/helloworldip_rst_mig_7series_0_81M_1_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_xbar_0/helloworldip_xbar_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_dlmb_v10_0/helloworldip_dlmb_v10_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_dlmb_v10_0/helloworldip_dlmb_v10_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_ilmb_v10_0/helloworldip_ilmb_v10_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_ilmb_v10_0/helloworldip_ilmb_v10_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_dlmb_bram_if_cntlr_0/helloworldip_dlmb_bram_if_cntlr_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_ilmb_bram_if_cntlr_0/helloworldip_ilmb_bram_if_cntlr_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_lmb_bram_0/helloworldip_lmb_bram_0_ooc.xdc]
set_property used_in_synthesis false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_cc_0/helloworldip_auto_cc_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_cc_0/helloworldip_auto_cc_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_cc_0/helloworldip_auto_cc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_pc_0/helloworldip_auto_pc_0_ooc.xdc]
set_property used_in_synthesis false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_ds_1/helloworldip_auto_ds_1_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_ds_1/helloworldip_auto_ds_1_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_ds_1/helloworldip_auto_ds_1_ooc.xdc]
set_property used_in_synthesis false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_ds_0/helloworldip_auto_ds_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_ds_0/helloworldip_auto_ds_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_ds_0/helloworldip_auto_ds_0_ooc.xdc]
set_property used_in_synthesis false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_us_0/helloworldip_auto_us_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_us_0/helloworldip_auto_us_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/ip/helloworldip_auto_us_0/helloworldip_auto_us_0_ooc.xdc]
set_property used_in_implementation false [get_files -all C:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/sources_1/bd/helloworldip/helloworldip_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/constrs_1/imports/vivado_work/Nexys4DDR_Master.xdc
set_property used_in_implementation false [get_files C:/Users/wdj/source/vivado_work/helloworld/helloworld.srcs/constrs_1/imports/vivado_work/Nexys4DDR_Master.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top helloworldip_wrapper -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef helloworldip_wrapper.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file helloworldip_wrapper_utilization_synth.rpt -pb helloworldip_wrapper_utilization_synth.pb"