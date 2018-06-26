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
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/wdj/source/vivado_work/smallcar/smallcar.cache/wt [current_project]
set_property parent.project_path C:/Users/wdj/source/vivado_work/smallcar/smallcar.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
set_property ip_output_repo c:/Users/wdj/source/vivado_work/smallcar/smallcar.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/wdj/source/vivado_work/smallcar/Control.v
  C:/Users/wdj/source/vivado_work/smallcar/GetAction.v
  C:/Users/wdj/source/vivado_work/smallcar/HongWai.v
  C:/Users/wdj/source/vivado_work/smallcar/PWM.v
  C:/Users/wdj/source/vivado_work/smallcar/SEGOUT.v
  C:/Users/wdj/source/vivado_work/smallcar/Speed.v
  C:/Users/wdj/source/vivado_work/smallcar/autoTracking.v
  C:/Users/wdj/source/vivado_work/smallcar/avoidObject.v
  C:/Users/wdj/source/vivado_work/smallcar/bin2BCD.v
  C:/Users/wdj/source/vivado_work/smallcar/createCLK.v
  C:/Users/wdj/source/vivado_work/smallcar/createEn.v
  C:/Users/wdj/source/vivado_work/smallcar/divFrequence.v
  C:/Users/wdj/source/vivado_work/smallcar/getBCDDistData.v
  C:/Users/wdj/source/vivado_work/smallcar/getDistanceData.v
  C:/Users/wdj/source/vivado_work/smallcar/getSpeed.v
  C:/Users/wdj/source/vivado_work/smallcar/getTemperature.v
  C:/Users/wdj/source/vivado_work/smallcar/miniCarAction.v
  C:/Users/wdj/source/vivado_work/smallcar/selectAction.v
  C:/Users/wdj/source/vivado_work/smallcar/temperMode.v
  C:/Users/wdj/source/vivado_work/smallcar/miniCarTop.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/wdj/source/vivado_work/smallcar/Nexys4DDR_Master.xdc
set_property used_in_implementation false [get_files C:/Users/wdj/source/vivado_work/smallcar/Nexys4DDR_Master.xdc]


synth_design -top miniCarTop -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef miniCarTop.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file miniCarTop_utilization_synth.rpt -pb miniCarTop_utilization_synth.pb"
