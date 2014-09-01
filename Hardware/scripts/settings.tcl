# Create a Quartus II project for mips32r1 on the DE0 Nano.
#
# Arg 1: Project name
# Arg 2: Source directory

if { $::argc != 2 } {
    puts "Error: Insufficient or invalid options passed to script \"[file tail $argv0]\"."
    exit 1
}

set proj [lindex $::argv 0]
set src  [lindex $::argv 1]
set family "Cyclone IV E"
set part   "EP4CE22F17C6"
set top    "Top"


# Create a new project
project_new -family $family -part $part $proj
set_global_assignment -name TOP_LEVEL_ENTITY $top


# Read the LIST file which contains a list of HDL sources.
set fp [open "$src/LIST" r]
set file_data [read $fp]
close $fp

# Add each source file to the project
set data [split $file_data "\n"]
foreach line $data {
    set trimmed [string trim $line]
    if { [string length $trimmed] > 0 } {
        set firstchar [string index $trimmed 0]
        if { $firstchar != "#" } {
            set ext [string tolower [file extension $trimmed]]
            if { $ext == ".v" } {
                set_global_assignment -name VERILOG_FILE "$src/$trimmed"
            } elseif { $ext == ".vhdl" } {
                set_global_assignment -name VHDL_FILE "$src/$trimmed"
            } elseif { $ext == ".qip" } {
                set_global_assignment -name QIP_FILE "$src/$trimmed"
            } elseif { $ext == ".mif" } {
                set_global_assignment -name MIF_FILE "$src/$trimmed"
            } else {
                puts "Error: Unknown or unhandled file type \"$ext\"."
            }
            set_global_assignment -name SEARCH_PATH "[file dirname "$src/$trimmed"]/"
        }
    }
}

# Pin constraints
set_location_assignment PIN_L3 -to LED[7]
set_location_assignment PIN_B1 -to LED[6]
set_location_assignment PIN_F3 -to LED[5]
set_location_assignment PIN_D1 -to LED[4]
set_location_assignment PIN_A11 -to LED[3]
set_location_assignment PIN_B13 -to LED[2]
set_location_assignment PIN_A13 -to LED[1]
set_location_assignment PIN_A15 -to LED[0]
set_location_assignment PIN_M15 -to Switch[3]
set_location_assignment PIN_B9 -to Switch[2]
set_location_assignment PIN_T8 -to Switch[1]
set_location_assignment PIN_M1 -to Switch[0]
set_location_assignment PIN_E9 -to UART_Rx
set_location_assignment PIN_F9 -to UART_Tx
set_location_assignment PIN_R8 -to clock_50MHz
set_location_assignment PIN_J15 -to reset_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to Switch[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to Switch[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to Switch[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to Switch[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to UART_Rx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to UART_Tx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clock_50MHz
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to reset_n

