; HelloWorldShellcode.nasm 
; Author: John Kennedy



global _start

section .text

_start:

	jmp short call_shellcode

shellcode:

	; print hello world on the screen

	xor eax, eax
	mov al, 0x4

	xor ebx, ebx
	mov bl, 0x1

	;mov ecx, message    old command
	pop ecx    ;puts address of the shellcode from stack to ecx

	xor edx, edx
	mov dl, 13

	int 0x80


	; exit the program gracefully

	xor eax, eax
	mov al, 0x1

	xor ebx, ebx

	int 0x80


call_shellcode:

	call shellcode
	message: db "Hello World!", 0xA
	




