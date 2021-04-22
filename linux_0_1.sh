#!/usr/bin/bash

#sudo apt-get install bochs
#sudo apt-get update
#sudo apt-get install bochs
cat>bochsrc<<-'EOF'
	megs:32
	romimage:file=/usr/share/bochs/BIOS-bochs-latest
	vgaromimage: file=/usr/share/bochs/VGABIOS-lgpl-latest
	floppya:1_44=boot.img,status=inserted
	boot:floppy
	log:bochsout.txt
	mouse:enabled=0
EOF
#sudo apt-get install ubuntu-desktop
#curl -OsSL http://oldlinux.org/download/linux-0.1x.zip
#curl -OL http://oldlinux.org/Linux.old/bochs/linux-0.12-080324.zip
#sudo apt-get install nasm
cat >boot.asm<<'EOF'
     org 0100h
     mov ax,cs
     mov ds,ax
     mov es,ax
     call DispStr
     jmp $
 DispStr:
     mov ax,BootMessage
     mov bp,ax
     mov cx,16
     mov ax,01301h
     mov bx,000ch
     mov dl,0
     int 10h
     ret
 BootMessage:    db     "Hello, My world!!"
 times 510-($-$$)    db 0
 dw 0xaa55
EOF

nasm boot.asm -o boot.bin
bximage 
dd if=boot.img of=boot.img bs=512 count=1 conv=notrunc

cat >code.asm<<-'EOF'
         ;代码清单7-1
         ;文件名：c07_mbr.asm
         ;文件说明：硬盘主引导扇区代码
         ;创建日期：2011-4-13 18:02

         jmp near start

 message db '1+2+3+...+100='

 start:
         mov ax,0x7c0           ;设置数据段的段基地址 
         mov ds,ax

         mov ax,0xb800          ;设置附加段基址到显示缓冲区
         mov es,ax

         ;以下显示字符串 
         mov si,message          
         mov di,0
         mov cx,start-message
     @g:
         mov al,[si]
         mov [es:di],al
         inc di
         mov byte [es:di],0x07
         inc di
         inc si
         loop @g

         ;以下计算1到100的和 
         xor ax,ax
         mov cx,1
     @f:
         add ax,cx
         inc cx
         cmp cx,100
         jle @f

         ;以下计算累加和的每个数位 
         xor cx,cx              ;设置堆栈段的段基地址
         mov ss,cx
         mov sp,cx

         mov bx,10
         xor cx,cx
     @d:
         inc cx
         xor dx,dx
         div bx
         or dl,0x30
         push dx
         cmp ax,0
         jne @d

         ;以下显示各个数位 
     @a:
         pop dx
         mov [es:di],dl
         inc di
         mov byte [es:di],0x07
         inc di
         loop @a

         jmp near $ 


times 510-($-$$) db 0
	 db 0x55,0xaa
EOF
nasm -f bin code.asm -o code.bin -l code.lst
dd if=code.bin of=boot.img
dd if=/dev/zero of=boot.img bs=512 count=2880
dd if=code.bin ibs=512 skip=8 of=boot.img obs=512 seek=0 count=1
#apt-get install build-essential nasm
#sudo apt-get install build-essential nasm
#sudo apt install qemu-system-x86
qemu-system-x86_64  -fda boot.img -boot order=a  -nographic
#ndisasm code.bin 
#ndisasm -o 0x11  code.bin 


#cd linux0.1src/
#vi config.inc
#vi bootsect.asm
#vi setup.asm
#vi head.asm
#vi makefile
#nasm bootsect.asm -o bootsect.bin
#nasm setup.asm -o setup.bin
#nasm head.asm -o head.bin
#nasm head.asm -o head.bin
#ndisasm bootsect.bin
#nasm -f elf test02.asm -o test02.o
#gcc -m32 test02.o -o test02
#gcc -m32 test01.c -o test01
#gcc -lgcc --verbose
#sudo apt-get libgcc-dev
#sudo apt-get install libgcc-dev
#sudo apt-get install libgcc
#sudo apt-get install libgcc-dev
#sudo apt-get reinstall build-essential nasm
#gcc -m32 test01.c -o test01
#sudo apt-get install gcc-multilib -y
#ld -s test02.o -o test02
#nasm -f test02.asm 
#nasm -f elf test02.asm 
#ld -s -o hello test02.o 
#nasm -f elf test02.asm 
#ld -s -o hello test02.o 
#nasm -f elf helloword.asm 
#ld -m elf_i386 helloword.o -o helloworld
