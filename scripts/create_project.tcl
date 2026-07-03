# Project settings
set project_name "pong"
set fpga_part "xc7a35tcpg236-1"

# Determine project root
set script_dir [file normalize [file dirname [info script]]]
set project_root [file dirname $script_dir]

# Create project and directory structure
create_project $project_name "$project_root/build" -part $fpga_part -force

# Add design sources
set rtl_files [glob -nocomplain "$project_root/rtl/*.v"]
add_files -norecurse $rtl_files

# Add constraints
set xdc_files [glob -nocomplain "$project_root/constraints/*.xdc"]
add_files -fileset constrs_1 $xdc_files

# Add IP
set_property ip_repo_paths [list "$project_root/ip"] [current_project]
update_ip_catalog

# Set top module
set top_module "top"
set_property top $top_module [current_fileset]