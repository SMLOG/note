#!/usr/bin/bash
cat>boot.S<<'EOF'

#define BOOTSEG 0x07C0
          .code16
          .section ".bstext", "ax"
          .global bootsect_start
bootsect_start:
          # Normalize the start address
          ljmp    $BOOTSEG, $start2
start2:
          movw    %cs, %ax
          movw    %ax, %ds
          movw    %ax, %es
          movw    %ax, %ss
          xorw    %sp, %sp
          sti
          cld
          movw    $bugger_off_msg, %si
  msg_loop:
          lodsb
          andb    %al, %al
          jz      bs_die
          movb    $0xe, %ah
          movw    $7, %bx
          int     $0x10
          jmp     msg_loop
  
  bs_die:
          # Allow the user to press a key, then reboot
          xorw    %ax, %ax
          int     $0x16
          int     $0x19
  
          # int 0x19 should never return.  In case it does anyway,
          # invoke the BIOS reset code...
          ljmp    $0xf000,$0xfff0
  
  bugger_off_msg:
          .ascii  "Hello Boot and hello world!!\r\n"
          .ascii  "by harvey\r\n"
          .ascii  "\n"
          .byte   0
 
          .org 510
          .word 0xAA55
EOF

cpp boot.S >bootsect.S
as -32 -gstabs -o boot.o bootsect.S
cat>boot.Id<<'EOF'


OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(bootsect_start)
 
SECTIONS
{
    . = 0;
    .boot : {*(.bstext)}
    . = ASSERT(. <= 512, "Boot too big!");
}   
EOF
ld -o boot boot.o -Tboot.Id
objdump -h boot
ndisasm boot
dd if=/dev/zero of=flp.img bs=512 count=2880

dd if=boot ibs=512 skip=8 of=flp.img obs=512 seek=0 count=1

qemu-system-x86_64 -boot order=a -fda flp.img -nographic
