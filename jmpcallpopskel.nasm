; Filename: execvejk.nasm
; Author:  clubjk
; Blog:  jkcybersecurity.org
; Twitter:clubjk 
;
;
; Purpose: Return a /bin/bash shell

global _start			

section .text
_start:

	jmp short call_shellcode

shellcode:


call_shellcode:
	
	call shellcode
	message: db "/bin/bash/ABBBBCCCC"

	
	


