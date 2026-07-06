# Project settings
set project_name "pong"
set fpga_part "xc7a35tcpg236-1"

# Set project root
set script_dir [file normalize [file dirname [info script]]]
set project_root [file dirname $script_dir]

# Create project and directory structure
set build_dir "$project_root/build"
create_project $project_name $build_dir -part $fpga_part -force

# Add design sources
set rtl_dir "$project_root/src"
set rtl_files [glob -nocomplain "$rtl_dir/*.v" "$rtl_dir/mem/*.mem"]
add_files $rtl_files

# Add constraints
set constr_dir "$project_root/constraints"
set constr_files [glob -nocomplain "$constr_dir/*.xdc"]
add_files -fileset constrs_1 $constr_files

# Set top module
set top_module "top"
set_property top $top_module [current_fileset]

# Add dimulation sources
set sim_dir "$project_root/sim"
set sim_files [glob -nocomplain "$sim_dir/*.v" "$sim_dir/*.wcfg"]
add_files -fileset sim_1 $sim_files

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1