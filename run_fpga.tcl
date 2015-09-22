#! ~/altera/15.0/quartus/bin/quartus_sh -t 
#################################################
# Initial Declarations
#################################################

load_package flow
load_package report
package require ::quartus::flow
package require cmdline
variable ::argv0 $::quartus(args)
set options {
{ "project.arg" "" "Project name" }
{ "board.arg" "" "board" }
}

set usage "You need to specify -project (Top Module Name) -board (sockit only now)"
array set optshash [::cmdline::getoptions ::argv $options $usage]
puts "The project name is $optshash(project)"
puts "The verilog is $optshash(project).sv"
puts "The FPGA Board is $optshash(board)"
project_new $optshash(project) -overwrite
set usage "You need to specify options and values"

#################################################
# Assign family, device, and top-level file
################################################
if {"sockit" eq $optshash(board)} {

######################### SocKit ####################################
set_global_assignment -name FAMILY CycloneV
set_global_assignment -name DEVICE 5CSXFC6D6F31C8ES
set_location_assignment -to clk Pin_J14

} else {
######################### SocKit ####################################
set_global_assignment -name FAMILY CycloneV
set_global_assignment -name DEVICE 5CSXFC6D6F31C8ES
set_location_assignment -to clk Pin_J14
puts "$optshash(board) FPGA Board is not updated to the list yet"
break
}

###################### Defaults #######################################
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name SYSTEMVERILOG_FILE $optshash(project).sv
set_global_assignment -name SYSTEMVERILOG_FILE ./fhw.sv
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files

##########################################################################
#Compile the project
#######################################################################
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

##########################################################################
#Report Timing (Fmax) 
#######################################################################
load_report
# Set panel name and id
set panel "*Timing Analyzer Summary"
set id    [get_report_panel_id $panel]

# If the specified panel exists, write it to
# fmax.htm and fmax.xml.
# Otherwise, print out an error message
if {$id != -1} {
    write_report_panel -file fmax.htm -html -id $id
    write_report_panel -file fmax.xml -xml -id $id
} else {
    puts "Error: report panel could not be found."
}

unload_report

#################################################
# Program the FPGA
#################################################

exec quartus_pgm --mode=jtag -c "CV SoCKit" --operation=p\;output_files/$optshash(project).sof


#close project
project_close 
