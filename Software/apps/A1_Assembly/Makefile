###############################################################################
#                                                                             #
#                           General Makefile for C                            #
#                       Modified for MIPS32 Crosstools                        #
#           Copyright (C) 2014 Grant Ayers <ayers@cs.stanford.edu>            #
#           Hosted at GitHub: https://github.com/grantea/makefiles            #
#                                                                             #
# This file is free software distributed under the BSD license. See LICENSE   #
# for more information.                                                       #
#                                                                             #
# This is a single-target, general-purpose Makefile designed for C projects   #
# which use the GNU GCC MIPS32 cross-compiler and tools.                      #
#                                                                             #
# Set the program name, source root directory, path to the MIPS compiler      #
# toolchain, and any desired build options. All dependencies (including       #
# header file changes) will be handled automatically.                         #
#                                                                             #
###############################################################################


#---------- Basic settings ----------#
PROGRAM_NAME = a1_assembly
SOURCE_BASE  = src
BUILD_BASE   = build


#---------- Source file names ----------#
CSRC_EXTS = .c
MASM_EXTS = .asm
LD_SCRIPT = mips_64KB.ls


#---------- Toolchain Location ----------#
MIPS_BASE = /home/User/root/proj/mips32/mips_tc
MIPS_BIN  = $(MIPS_BASE)/bin
MIPS_CC   = $(MIPS_BIN)/mips-elf-gcc-4.9.1


#---------- Compilation and linking ----------#
FLAGS_ARCH = -march=mips32 -EB -msoft-float -mno-mips16 -mno-branch-likely -mgpopt
FLAGS_LANG = -Wall -Wextra -Wfatal-errors -pedantic -std=c99
FLAGS_OPT  = -O2 -pipe
LD_LINK    = -nostdlib -nostartfiles -static
LD_LIBS    = -lm -lc -lgcc
INC_DIRS   = -I$(SOURCE_BASE)


#---------- No need to modify below ----------#

APP       := $(BUILD_BASE)/$(PROGRAM_NAME)
SRC_DIRS  := $(shell find $(SOURCE_BASE) -type d -print)
BLD_DIRS  := $(addprefix $(BUILD_BASE)/,$(SRC_DIRS))
CSRC_SRCS := $(foreach DIR,$(SRC_DIRS),$(foreach EXT,$(CSRC_EXTS),$(wildcard $(DIR)/*$(EXT))))
MASM_SRCS := $(foreach DIR,$(SRC_DIRS),$(foreach EXT,$(MASM_EXTS),$(wildcard $(DIR)/*$(EXT))))
CSRC_OBJS := $(addsuffix .o,$(addprefix $(BUILD_BASE)/,$(CSRC_SRCS)))
MASM_OBJS := $(addsuffix .o,$(addprefix $(BUILD_BASE)/,$(MASM_SRCS)))
CSRC_DEPS := $(CSRC_OBJS:.o=.d)
LD_SCRIPT := $(shell find $(SOURCE_BASE) -name "$(LD_SCRIPT)" -print)
LD_FLAGS  := $(FLAGS_ARCH) $(LD_LINK) $(LD_LIBS) -T $(LD_SCRIPT) -Wl,-Map,$(APP).map

.PHONY: all app binfiles clean

all: binfiles

binfiles: $(APP).lst $(APP).bin $(APP).hex

$(APP).lst: app
	@echo [LST] $@
	@$(MIPS_BIN)/mips-elf-objdump -d $(APP) > $@

$(APP).bin: app
	@echo [BIN] $@
	@$(MIPS_BIN)/mips-elf-objcopy -O binary $(APP) $@

$(APP).hex: $(APP).bin
	@echo [HEX] $@
	@xxd -p -c 32 $(APP).bin $@
	@echo '      '$@.tsv
	@cat $(APP).hex | sed 's/.\{8\}/&\t/g' > $(APP).hex.tsv

app: $(APP)

$(APP): $(CSRC_OBJS) $(MASM_OBJS)
	@echo [LD]'  '$@
	@$(MIPS_CC) $(CSRC_OBJS) $(MASM_OBJS) $(LD_FLAGS) -o $(APP)
	@echo '      '$@.map

$(CSRC_OBJS): $(BUILD_BASE)/%.o: % | $(BLD_DIRS)
	@echo [CC]'  '$<
	@$(MIPS_CC) $(INC_DIRS) $(FLAGS_ARCH) $(FLAGS_LANG) $(FLAGS_OPT) -MD -MP -c -o $@ $<

$(MASM_OBJS): $(BUILD_BASE)/%.o: % | $(BLD_DIRS)
	@echo [AS]'  '$<
	@$(MIPS_CC) $(INC_DIRS) $(FLAGS_ARCH) -x assembler -c -o $@ $<

$(BLD_DIRS):
	@mkdir -p $@

clean:
ifeq ($(SOURCE_BASE),$(BUILD_BASE))
	@rm -f $(CSRC_OBJS) $(MASM_OBJS) $(CSRC_DEPS) $(APP) $(APP).lst $(APP).map $(APP).bin $(APP).hex
else
	@rm -rf $(APP) $(APP).lst $(APP).map $(APP).bin $(APP).hex $(BUILD_BASE)
endif

-include $(CSRC_DEPS)
