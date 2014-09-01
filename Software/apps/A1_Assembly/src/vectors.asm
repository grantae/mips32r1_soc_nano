###############################################################################
# File         : vectors.asm
# Project      : MIPS32 Release 1
# Creator(s)   : Grant Ayers (ayers@cs.stanford.edu)
# Date         : 1 June 2014
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Exception and Interrupt Vector place holders
#
#   - The exception vector begins at address 0x0.
#   - The interrupt vector begins at address 0x8.
#   - Each vector has room for two instructions (8 bytes) with which it must
#     jump to its demultiplexing routine. The demultiplexing routine calls
#     individual exception-specific handlers.
#   - The linker script must ensure that this code is placed at the correct
#     address.
#
#   In this simplified version the exception vectors halt the processor
#   by entering an idle loop. This is intended only for simple unit tests. 
#
###############################################################################


    .section .vectors, "wx"
	.balign	4
	.ent	exception_vector
	.set	noreorder
exception_vector:
	j	exception_vector
	nop
	.end	exception_vector


	.ent	interrupt_vector
interrupt_vector:
	j	interrupt_vector
	nop
	.end	interrupt_vector
