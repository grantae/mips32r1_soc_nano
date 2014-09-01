#!/bin/sh

###############################################################################
# make_project.sh
#
# Create the Quartus-II project files for the mips32r1 system-on-chip (SoC)
# on the Altera DE0-Nano FPGA.
#
# After running this script, use the Makefile in the new project directory to
# build the project and configure the FPGA.
#
###############################################################################

PROJECT_NAME="mips32r1_soc_nano"

# Relative path to the (future) project directory
PROJECT_PATH=proj

# Relative path to the (existing) source directory
SOURCE_PATH=src

# Relative path and name of the project settings script
SETTINGS_SCRIPT=scripts/settings.tcl

MAKEFILE_TEMPLATE=scripts/Makefile.template


#-------------------------------------------------------#

# Determine how to move between project and source paths
CURRENT_PATH_CAN=$(readlink -m .)
PROJECT_PATH_CAN=$(readlink -m $PROJECT_PATH)
PATH_DIFF=${PROJECT_PATH_CAN#$CURRENT_PATH_CAN}
PATH_LVLS=$(echo $PATH_DIFF | tr -dc '/' | wc -m)
PATH_BACK=$(printf '../%.0s' {1..$PATH_LVLS})

# Fill in the path to the BRAM memory contents file
sed "s|TODO_INIT_FILE_STRING_TODO|$PATH_BACK$SOURCE_PATH/BRAM/Memory_Contents.mif|g" \
    $SOURCE_PATH/BRAM/BRAM_64KB/BRAM_64KB.v.template > \
    $SOURCE_PATH/BRAM/BRAM_64KB/BRAM_64KB.v

# Create the project
mkdir -p $PROJECT_PATH
cd $PROJECT_PATH
quartus_sh -t "$PATH_BACK$SETTINGS_SCRIPT" "$PROJECT_NAME" "$PATH_BACK$SOURCE_PATH"
cd $PATH_BACK

# Create the Makefile
sed -e "s|TODO_PROJECT_TODO|$PROJECT_NAME|g" \
    -e "s|TODO_SOURCES_TODO|$PATH_BACK$SOURCE_PATH|g" \
    $MAKEFILE_TEMPLATE > $PROJECT_PATH/Makefile

