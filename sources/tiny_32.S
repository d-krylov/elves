#define BASE 0x05000000

.code32

.section   ".header", "a"

ELF_HEADER:
         
  // e_ident - 16 bytes

  .byte  0x7F
  .byte  'E'
  .byte  'L'
  .byte  'F'
  .byte  0x01  // EI_CLASS - 32-bit
  .byte  0x00  // EI_DATA
  .byte  0x00  // EI_VERSION
  .byte  0x00  // EI_OSABI
  .byte  0x00  // EI_ABIVERSION
  .byte  0x00  // 1 - EI_PAD + 0
  .byte  0x00  // 2 - EI_PAD + 1
  .byte  0x00  // 3 - EI_PAD + 2
  .byte  0x00  // 4 - EI_PAD + 3        
  .byte  0x00  // 5 - EI_PAD + 4
  .byte  0x00  // 8 - EI_PAD + 5
  .byte  0x05  // 9 - EI_PAD + 6

  .word  0x0002      //e_type
  .word  0x0003      //e_machine
  .long  BASE + 0x1b //e_version
  .long  BASE + 0x1b //e_entry
  .long  0x00000004  //e_phoff

  .set   START, . - ELF_HEADER + BASE

_start:

  mov   $BASE + MESSAGE_OFFSET, %ecx 
  mov   $MESSAGE_SIZE, %dl                                                                        
  int   $0x80
  .byte 0x25    // AND instruction
  .word 0x0020                        
  .word 0x0001

  inc   %eax      
  int   $0x80

  .set MESSAGE_OFFSET, .
  .string  "Hello\n"
  .set   MESSAGE_SIZE, . - MESSAGE_OFFSET