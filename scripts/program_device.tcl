# Design settings
set design_name "pong"

# Get project root
set script_dir [file normalize [file dirname [info script]]]
set project_root [file dirname $script_dir]

# Connect to device 
open_hw_manager
connect_hw_server
current_hw_target
open_hw_target

# Program device
set bitstream "$project_root/output/$design_name.bit"
set_property PROGRAM.FILE $bitstream [current_hw_device]
program_hw_devices [current_hw_device]