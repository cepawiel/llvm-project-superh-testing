
CFLAGS= -O2 -v --target=superh -integrated-as

OBJDUMP=/opt/toolchains/dc/sh-elf/bin/sh-elf-objdump
SH_GCC=/opt/toolchains/dc/sh-elf/bin/sh-elf-g++

CLANG_BIN=../llvm-project/build/bin/clang
LLC_BIN=../llvm-project/build/bin/llc


SOURCE_DIR=source
OUTPUT_DIR=output
DECOMP_DIR=decomp
GCC_DIR=gcc

CPP_FILES := $(shell find source -name '*.c' -print)
LL_FILES  := $(patsubst $(SOURCE_DIR)/%.c,$(OUTPUT_DIR)/%.ll,$(CPP_FILES))
ASM_FILES := $(patsubst $(SOURCE_DIR)/%.c,$(OUTPUT_DIR)/%.s,$(CPP_FILES))
OBJ_FILES := $(patsubst $(SOURCE_DIR)/%.c,$(OUTPUT_DIR)/%.o,$(CPP_FILES))
DECOMP_FILES := $(patsubst $(SOURCE_DIR)/%.c,$(DECOMP_DIR)/%.s,$(CPP_FILES))
GCC_ASM_FILES := $(patsubst $(SOURCE_DIR)/%.c,$(GCC_DIR)/%.s,$(CPP_FILES))

.PHONY: all clean ll asm obj decomp gcc_asm

all: ll asm obj decomp gcc_asm

ll: $(LL_FILES)
asm: $(ASM_FILES)
obj: $(OBJ_FILES)
decomp: $(DECOMP_FILES)
gcc_asm: $(GCC_ASM_FILES)

$(OUTPUT_DIR)/%.ll: $(SOURCE_DIR)/%.c
	$(CLANG_BIN) $(CFLAGS) -S -emit-llvm $< -o $@

$(OUTPUT_DIR)/%.s: $(OUTPUT_DIR)/%.ll
#	llc -filetype=asm add.ll -debug-only=isel -o add.s > dagsel.txt 2>&1
#   $(LLC_BIN) -debug -print-before-all -print-after-all -filetype=asm $< -o $@
	$(LLC_BIN) -filetype=asm $< -o $@

$(OUTPUT_DIR)/%.o: $(OUTPUT_DIR)/%.ll
	$(LLC_BIN) -filetype=obj $< -o $@

$(DECOMP_DIR)/%.s: $(OUTPUT_DIR)/%.o
	$(OBJDUMP) -x $< > $@
	$(OBJDUMP) -d -M intel -S $< >> $@
#	$(OBJDUMP) -s -j .rodata.cst4 $< >> $@

$(GCC_DIR)/%.s: $(SOURCE_DIR)/%.c
	$(SH_GCC) -S -O2 $< -o $@

# $(GCC_DIR)/%.o: $(SOURCE_DIR)/%.c
# 	$(SH_GCC) -O2 $< -o $@

# $(GCC_DIR)/%.s: $(GCC_DIR)/%.o
# 	$(OBJDUMP) -x $< > $@
# 	$(OBJDUMP) -d -M intel -S $< >> $@

clean: 
	rm $(DECOMP_DIR)/asm/*.s $(DECOMP_DIR)/*.s $(OUTPUT_DIR)/* $(GCC_DIR)/*