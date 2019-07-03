add_files -norecurse ./converge_ctrl.v
add_files -norecurse ./leaf_interface.v
add_files -norecurse ./Output_Port.v
add_files -norecurse ./write_b_out.v
add_files -norecurse ./read_b_in.v
add_files -norecurse ./Config_Controls.v
add_files -norecurse ./Input_Port.v
add_files -norecurse ./Output_Port_Cluster.v
add_files -norecurse ./write_b_in.v
add_files -norecurse ./Stream_Flow_Control.v
add_files -norecurse ./ExtractCtrl.v
add_files -norecurse ./Input_Port_Cluster.v
add_files -norecurse ./output_FB_dul.v
set logFileId [open ./runLogoutput_FB_dul.log "a"]
set start_time [clock seconds]
set_param general.maxThreads  8 
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY XPM_FIFO} [current_project]
add_files  -norecurse ./leaf.v
synth_design -top leaf -part  xc7a15tcpg236-3 -mode out_of_context
write_checkpoint -force output_FB_dul_leaf_netlist.dcp
set end_time [clock seconds]
set total_seconds [expr $end_time - $start_time]
puts $logFileId "syn: $total_seconds seconds"
report_utilization -hierarchical > utilization.rpt
