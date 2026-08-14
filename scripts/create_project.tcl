# Project settings
set project_name "pong"
set fpga_part "xc7a35tcpg236-1"
set top_module "top"

# Set project root
set script_dir [file normalize [file dirname [info script]]]
set project_root [file dirname $script_dir]

# Create project and directory structure
set build_dir "$project_root/build"
create_project $project_name $build_dir -part $fpga_part -force

# Add design sources
set src_dir "$project_root/src"
add_files [glob "$src_dir/*.sv"]
add_files [glob "$src_dir/*/*.sv"]
add_files [glob "$src_dir/*/*/*.mem"]

# Add constraints
set constr_dir "$project_root/constraints"
add_files -fileset constrs_1 [glob "$constr_dir/*.xdc"]

# Set top module
set_property top $top_module [current_fileset]