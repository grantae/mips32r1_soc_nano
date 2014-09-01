###############################################################################
# TITLE: Boot Up Code
# AUTHOR: Grant Ayers (ayers@cs.utah.edu)
# DATE: 19 July 2011
# FILENAME: boot.asm
# PROJECT: University of Utah XUM Single Core
# DESCRIPTION:
#   Initializes the global pointer and stack pointer.
#   Zeros BSS memory region and jumps to main().
#
###############################################################################


    .section .boot, "wx"
    .balign 4
    .global boot
    .ent    boot
    .set    noreorder
boot:
    la  $t0, _bss_start         # Defined in linker script
    la  $t1, _bss_end
    la  $sp, _sp
    la  $gp, _gp

$bss_clear:
    beq $t0, $t1, $cp0_setup    # Loop until BSS is cleared
    nop
    sb  $0, 0($t0)
    j   $bss_clear
    addiu   $t0, $t0, 1

$cp0_setup:
    la      $26, $run           # Load the address of $run into
    mtc0    $26, $30, 0         #   the ErrorEPC
    
    mfc0    $26, $13, 0         # Load Cause register
    lui     $27, 0x0080         # Use "special" interrupt vector
    or      $26, $26, $27
    mtc0    $26, $13, 0         # Commit new Cause register
    
    mfc0    $26, $12, 0         # Load Status register
    lui     $27, 0x0018         # Set read-only Status bits (16 MSB)
    ori     $27, $27, 0x0006    # Set read-only Status bits (16 LSB)
    and     $26, $26, $27       # Clear writable Status bits
    add     $27, $0, $0         # Blank slate for writable Status bits
    ori     $27, $27, 0x1000    # Enable CP0 in User mode (>>16)
#   ori     $27, $27, 0x0200    # Enable Reverse (little) Endian in User Mode (>>16)
    ori     $27, $27, 0x0040    # Bootstrap (not normal) exception vectors (>>16)
    sll     $27, $27, 16        # Properly place 16 MSB
    ori     $27, $27, 0xff01    # Enable all interrupts (comment for none)
#   ori     $27, $27, 0x0010    # Base mode is User (comment for Kernel)
    or      $26, $26, $27       # Set writable Status bits
    mtc0    $26, $12, 0         # Commit new Status register


    #lui    $26, 0x0000         # 1ms timer (50 MHz)
    #ori    $26, $26, 0xc350    
    #lui    $26, 0x0007         # 10ms timer (50 MHz)
    #ori    $26, $26, 0xa120
    lui    $26, 0x004c         # 100ms timer (50 MHz)
    ori    $26, $26, 0x4b40
    #lui    $26, 0x00be         # 250ms timer (50 MHz)
    #ori    $26, 0xbc20
    #lui    $26, 0x017d         # 500ms timer (50 MHz)
    #ori    $26, 0x7840
    #lui    $26, 0x02fa         # 1 sec timer (50 MHz)
    #ori    $26, $26, 0xf080
    mtc0   $26, $11, 0         # Set Compare register to timer value
    
    eret                        # Return from Reset Exception

$run:
    jal main
    nop

$done:
    j   $done
    nop

    .end boot

