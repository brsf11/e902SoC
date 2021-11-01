CC      = ~/Xuantie-900-gcc-elf-newlib-x86_64-V2.0.3/bin/riscv64-unknown-elf-gcc
AS      = ~/Xuantie-900-gcc-elf-newlib-x86_64-V2.0.3/bin/riscv64-unknown-elf-as
LINK    = ~/Xuantie-900-gcc-elf-newlib-x86_64-V2.0.3/bin/riscv64-unknown-elf-ld
OBJDUMP = ~/Xuantie-900-gcc-elf-newlib-x86_64-V2.0.3/bin/riscv64-unknown-elf-objdump
OBJCOPY = ~/Xuantie-900-gcc-elf-newlib-x86_64-V2.0.3/bin/riscv64-unknown-elf-objcopy

CFLAGS = -march=rv32ec -mabi=ilp32e
LINKFLAGS = -Tlinker.lcf -nostartfiles -march=rv32ec -mabi=ilp32e

LINKLIBS = -lc -lgcc

HEXFLAGS	= -O verilog

SSRC = $(wildcard *.S)
sSRC = $(wildcard *.s)
CSRC = $(wildcard *.c)

OBJECTS = $(SSRC:%.S=%.o) $(sSRC:%.s=%.o) $(CSRC:%.c=%.o)

%.o : %.c
	${CC} -c ${CFLAGS} -o $@ $<

%.o : %.c %.h
	${CC} -c ${CFLAGS} -o $@ $<

%.o : %.s
	${CC} -c ${CFLAGS} -o $@ $<

%.o : %.S
	${CC} -c ${CFLAGS} -o $@ $<

${FILE}.elf : ${OBJECTS} link.ld
	${CC} ${LINKFLAGS} ${LINKLIBS} ${OBJECTS} -o $@ -lm 

${FILE}.hex : ${FILE}.elf
	${OBJCOPY} ${HEXFLAGS} $< ../build/code.hex


.PHONY :all
all : ${FILE}.hex ${FILE}.elf
