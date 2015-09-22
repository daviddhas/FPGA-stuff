The script can be run using
1) Copy the design.sv, fhw.sv, timing.tcl and run_fpga.tcl to a new folder
2) Now run
quartus_sh -t run_fpga.tcl -project (design_name) -board sockit

design_name is the name of the verilog design without the .sv extension For example. Tuples.sv is compiled as

quartus_sh -t run_fpga.tcl -project Tuples -board sockit

The resources used are also displayed
To get the detailedresources used, Check output_files/(Design name).fit.summary

3) To get the fmax values,
quartus_sta -t timing.tcl (design_name)

To Recompile with new Verilog Files 

1) Replace the verilog files in the project
2) quartus_sh -t recompile.tcl (design name)

Note: This script does both and execute the full flow and run timing.tcl
