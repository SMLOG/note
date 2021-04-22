#!/usr/bin/bash
cat>boot.asm<<'EOF'

; filename boot.asm

org 7c00h   ; bis start address

; int 10 
mov ax, cs
mov es, ax
mov ax, msg
mov bp, ax
mov cx, msgLen
mov ax, 1301h  ;AH=13h表示向TTY显示字符，AL=01h表示显示方式（字符串是否包含显示属性，01h表示不包含）
mov bx, 000fh  ;AH=13h表示向TTY显示字符，AL=01h表示显示方式（字符串是否包含显示属性，01h表示不包含）
mov dl, 0
int 10h

msg: db "Hello world!\n" ,0ah,0dh
msgLen: equ $ -msg

times 510 - ($ - $$) db 0
dw 0xaa55

EOF
nasm boot.asm -o boot.bin
wc -c boot.bin 
ndisasm boot.bin -o 0x7c00
dd if=boot.bin of=a.img
dd if =boot.bin ibs=512 of=floopy obs=512 count=1 seek=0 conv=notrunc
wc -c a.img 
file a.img 
qemu-system-i386 -m 256 -fda boot.bin -boot a -M pc -nographic
qemu-system-i386 -m 256 -fda a.img -boot a  -nographic
#ctrl+ a + h
