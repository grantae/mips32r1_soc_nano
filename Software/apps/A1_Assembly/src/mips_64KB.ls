/* Linker script for MIPS32 (Single Core) using 64 KB of memory */


/* Entry Point
 *
 * Set it to be the label "boot" (likely in boot.asm)
 *
 */
ENTRY(boot)


/* Memory Section
 *
 * Configuration for 64KB of memory:
 * 
 * Instruction Memory starts at address 0.
 *
 * Data Memory ends 64KB later, at address 0x00010000 (the last
 * usable word address is 0x0000fffc).
 *
 *   Instructions :    0x00000000 -> 0x000037fc    ( 14KB)
 *   Data / BSS   :    0x00003800 -> 0x000057fc    (  8KB)
 *   Stack / Heap :    0x00005800 -> 0x0000fffc    ( 42KB)
 * 
 *
 */

/* Sections
 *
 */

SECTIONS
{
	_sp = 0x00010000;

	. = 0 ;
	
    .text :
	{
        *(.vectors)
        . = 0x10 ;
        *(.boot)
		*(.*text*)
	}

	. = 0x00003800 ;

	.data :
	{
		*(.rodata*)
		*(.data*)
	}

	_gp = ALIGN(16) + 0x5000;

	.got :
	{
		*(.got)
	}

	.sdata :
	{
		*(.*sdata*)
	}

	_bss_start = . ;

	.sbss :
	{
		*(.*sbss)
	}

	.bss :
	{
		*(.*bss)
	}

	_bss_end = . ;

    . = 0x10000 ;
}
