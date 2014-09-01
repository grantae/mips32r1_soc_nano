MIPS32 Release 1 SoC for the DEO-Nano
=====================================

This is a System-on-Chip (SoC) version of the mips32r1\_core project for
Altera's DEO-Nano development board.

Features
--------

- Pipelined MIPS32 bare-metal processor from https://github.com/grantea/mips32r1_core
- 50 MHz core with 100 MHz I/O datapath
- 64 KB Block RAM footprint
- LED, switch, and UART (+bootloader) hardware and MMIO drivers

Software Toolchain Details
--------------------------

- Full C compiler support based on Binutils (2.24), GCC (4.9.1), and Newlib (2.1.0)
- Toolchain can be built in most Unix-like environments (Linux, BSD, Cygwin, etc.)
- Big- and little-endian support
- Software floating-point support
- Newlib library stubs (printf, etc.) are left unchanged

Requirements
------------

- DE0-Nano development board
- Altera Quartus II software
- A compiler and build utilities (make, etc.) to build the toolchain
- (Optional) Serial port to 3.3V UART hardware for live reconfiguration

Getting Started
---------------

`Hardware/README` contains instructions for building the SoC.

`Software/toolchain/README` contains instructions for building the cross compiler tools.

`Software/apps/` contains software which can be compiled for the SoC.
