set project_name [lindex $quartus(args) 0]
project_open $project_name

# Always create the netlist first
create_timing_netlist
# Get domain summary object
set domain_list [get_clock_fmax_info]
foreach domain $domain_list {
	set name [lindex $domain 0]
	set fmax [lindex $domain 1]
	set restricted_fmax [lindex $domain 2]

	puts "Clock $name : Fmax = $fmax (Restricted Fmax = $restricted_fmax)"
}

# The following command is optional
delete_timing_netlist

project_close
