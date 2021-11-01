
OUTPUT_ARCH( "riscv" )
ENTRY(__start)

__kernel_stack = 0x40010000 ;

SECTIONS {
    .text :
    {
        crt0.o (.text)
        *(.text*)
        . = ALIGN(0x10);
    }
    .rodata :
    {
      *(.rodata*)
          . = ALIGN(0x4);
        __erodata = .;
    }
    .data :
    {
      . = ALIGN(0x4);
      __data_start__ = .;
        *(.data*)
        *(.eh_frame*)
          . = ALIGN(0x4);
        __data_end__ = .;
    }
    .bss :
    {
      . = ALIGN(0x4);
      __bss_start__ = .;
        *(.bss)
         . = ALIGN(0x4);
        __bss_end__ = .;
          *.(COMMON)
    }
}