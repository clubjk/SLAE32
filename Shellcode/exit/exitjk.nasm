; Filename: exit.nasm
; Author:  Vivek Ramachandran
; Website:  http://securitytube.net
; Training: http://securitytube-training.com 
;
;
; Purpose: 

global _start			

section .text
_start:

	xor eax, eax ;(clears the eax register w zeroes)
	mov al, 1
	xor ebx, ebx ;(clears the ebx register w zeroes)
	mov bl, 10
	int 0x80


