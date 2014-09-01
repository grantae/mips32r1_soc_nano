###############################################################################
# File         : boot.asm
# Project      : MIPS32 Release 1
# Creator(s)   : Grant Ayers (ayers@cs.stanford.edu)
# Date         : 1 June 2015
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   A very simple routine for testing the basic functionality of the processor.
#   Writes the value 0x55 to memory address 0xc0000000, which is the MMIO
#   address for the LEDs on SoC designs.
#
#   Replace this code with any basic test, but note that this routine runs in
#   kernel mode and does not initialize the processor, stack, or memory
#   sections in any way.
#
###############################################################################


    .section .boot, "wx"
    .balign 4
    .global boot
    .ent    boot
    .set    noreorder
boot:
    ori $t0, $zero, 0x55        # Load the pattern '01010101' for the LEDs
    lui $t1, 0xc000             # The LEDs are at address 0xC0000000
    sw  $t0, 0($t1)             # Write the LEDs

$done:
    j   $done                   # Loop forever doing nothing
    nop

    .end boot
