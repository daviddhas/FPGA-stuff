load_package flow 
load_package report
set project_name [lindex $quartus(args) 0]
project_open $project_name
execute_flow -compile
#################################################
# Report Generation
#################################################
load_report

# Shortcut of get_fitter_resource_usage command
set cmd     get_fitter_resource_usage

# Get total registers, logic elements, and DSP block 9-bit elements.
set registers [$cmd -reg]
set les       [$cmd -le -used]
set io_pin    [$cmd -io_pin -available]
set mem_bit   [$cmd -mem_bit -percentage]
set dsp       [$cmd -resource "DSP block 9*"]
puts "Registers usage: $registers"
puts "Total used logic elements: $les"
puts "Total available I/O pins: $io_pin"
puts "Total used memory bits in percentage: ${mem_bit}%"
puts "DSP block 9-bit elements: $dsp"

unload_report

######

#################################################
# Timing Analysis
#################################################

exec quartus_sta -t timing.tcl $project_name

project_close
