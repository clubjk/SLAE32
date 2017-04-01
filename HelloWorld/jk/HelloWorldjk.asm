; HelloWorldjk.asm
; Created by the Scary Clubjk



global _start

section .text

_start

	; print hello world on screen

	mov eax, 0x4 ;because write system call fd  is 4
	mov ebx, 0x1 ;because stdout is 1
	mov ecx, message ;moves the value of the variable "message" to ecx
	;mov edx, 20   ;defines the length of the "message", count them (20)
	mov edx, mlen
	int 0x80    ; invokes the system call with the above arguments

	
	; exit the program gracefully
	
	mov eax, 0x1   ;because exit system call fd is 1
	mov ebx, 0x5   ;ending return value arbitrarily choose 5
	int 0x80       ;invokes the system call





section .data


	message: db "Hello World From JK!"
	mlen equ $-message













