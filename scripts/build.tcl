# Build settings
set design_name "pong"
set fpga_part "xc7a35tcpg236-1"
set top_module "top"

# Get project root
set script_dir [file normalize [file dirname [info script]]]
set project_root [file dirname $script_dir]

# Read design sources
set src_dir "$project_root/src"
set src_files [glob "$src_dir/*.v"]
read_verilog $src_files

# Read memory files
set mem_dir "$src_dir/mem"
set mem_files [glob "$mem_dir/*.mem"]
read_mem $mem_files

# Read constraints
set constr_dir "$project_root/constraints"
set constr_files [glob "$constr_dir/*.xdc"]
read_xdc $constr_files

# Run synthesis
synth_design -top $top_module -part $fpga_part

# Run place and route
opt_design
place_design
route_design

# Create output directory
set output_dir "$project_root/output"
file mkdir $output_dir 

# Generate reports
report_utilization -file "$output_dir/utilization.rpt"
report_timing_summary -file "$output_dir/timing_summary.rpt"
report_drc -file "$output_dir/drc.rpt"

# Write bitstream
write_bitstream -force "$output_dir/$design_name.bit"