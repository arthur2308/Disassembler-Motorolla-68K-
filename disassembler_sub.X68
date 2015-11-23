*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


addr1   EQU     $7000
bit1    EQU     $FF0
bit2    EQU     $FF1
bit3    EQU     $FF2
bit4    EQU     $FF3

    ORG    $1000
START:                  ; first instruction of program

        *   this stores some test EA into memory
        LEA     addr1,A1
        MOVE.W  #$9339,(A1)+
        MOVE.L  #$5555A7FF,(A1)+
        MOVE.W  #$9078,(A1)+
        MOVE.W  #$5555,(A1)+
        
        MOVE.L  #$0,A1              This clears the memory at A1, not sure why i didn't it but its probably important
        
        MOVEA.L #addr1,A6           Moves starting addr into A6 register
        
        MOVE.B  (A6)+,D2            Moves data at current address to D1, then increments
        
        MOVE.L  #0,D3               Resets D3 register to 0
        *   this gets digit in 10's place
        MOVE.B  D2,D3               Copies data at D2 to D3
        DIVS.W  #$10,D3             Divide data by 16, leaving first digit of number
        *   this gets digit in 1's place
        MOVE.B  D3,D4               Copies digit to D4
        MULS.W  #$10,D4             Multiply by 10 to get X0
        SUB.B   D4,D2               Subtract to get digit in ones place
        
        *   D3 holds digit in 10's place
        *   D2 holds digit in 1's place

        *   Moves second nibble to D5 to be used later
        MOVE.B  D2,D5
        BRA     SUBCODE

*   This is where the table goes to detirmine which op-code to use
SUBCODE CMP.B   #$9,D3              Goes to sub section
        BEQ     SUB

        *   Grabs next two nibbles
SUB     MOVE.B  (A6)+,D2

        MOVE.L  #0,D3               Resets D3 register to 0
        *   this gets digit in 10's place
        MOVE.B  D2,D3               Copies data at D2 to D3
        DIVS.W  #$10,D3             Divide data by 16, leaving first digit of number
        *   this gets digit in 1's place
        MOVE.B  D3,D4               Copies digit to D4
        MULS.W  #$10,D4             Multiply by 10 to get X0
        SUB.B   D4,D2               Subtract to get digit in ones place
        
        *   D3 holds digit in 10's place
        *   D2 holds digit in 1's place

        MOVE.L  #$0,D4
        
        *   Converts nibble into 3-bit parts
        LSR.B   #1,D3
        BCC     SUB2
        ADD.B   #$2,D4
        
SUB2    LSR.B   #1,D3
        BCC     SUB3
        ADD.B   #$4,D4
        
SUB3    MOVE.B  D5,D1
        LSR.B   #1,D1
        BCC     SUB4
        ADD.B   #$4,D3

SUB4    CMP.B   #$7,D2
        BLT     SUB1
        ADD.B   #$1,D4
        SUB.B   #$8,D2

        *   Stores them into addr
SUB1    MOVE.B  D1,bit1
        MOVE.B  D3,bit2
        MOVE.B  D4,bit3
        MOVE.B  D2,bit4

        MOVE.L  #0,D1
        MOVE.L  #0,D2
        MOVE.L  #0,D3
        MOVE.L  #0,D4
        MOVE.L  #0,D5
        MOVE.L  #0,D6
        MOVE.L  #0,D7
        
*** sub display ***

        * This will display SUBA instead
        CMP.B   #$3,bit2
        BEQ     SUBA
        CMP.B   #$7,bit2
        BEQ     SUBA

        * Displays 'SUB.' 
        LEA     MSUB,A1
        MOVE.B  #14,D0
        TRAP    #15

        * This will find the size and stuff
        CMP.B   #$0,bit2
        BEQ     SUBSIZE1
        CMP.B   #$1,bit2
        BEQ     SUBSIZE2
        CMP.B   #$2,bit2
        BEQ     SUBSIZE3
        CMP.B   #$4,bit2
        BEQ     SUBSIZE4
        CMP.B   #$5,bit2
        BEQ     SUBSIZE5
        CMP.B   #$6,bit2
        BEQ     SUBSIZE6
   

*   Displays size, then does operation order

*   000 byte    EA,DN
SUBSIZE1
        LEA     MBYTE,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     SUBSIZE11,A2
        BRA     SUBEA
SUBSIZE11
        LEA     SUBSIZE12,A2
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBDN
SUBSIZE12
        BRA     EXIT


*   001 word    EA,DN
SUBSIZE2
        LEA     MWORD,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     SUBSIZE21,A2
        BRA     SUBEA
SUBSIZE21
        LEA     SUBSIZE22,A2
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBDN
SUBSIZE22
        BRA     EXIT

*   010 long    EA,DN
SUBSIZE3
        LEA     MLONG,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     SUBSIZE31,A2
        BRA     SUBEA
SUBSIZE31
        LEA     SUBSIZE32,A2
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBDN
SUBSIZE32
        BRA     EXIT


*   100 byte    DN,EA
SUBSIZE4
        LEA     MBYTE,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     SUBSIZE41,A2
        BRA     SUBDN
SUBSIZE41
        LEA     SUBSIZE42,A2
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBEA
SUBSIZE42
        BRA     EXIT


*   101 word    DN,EA
SUBSIZE5
        LEA     MWORD,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     SUBSIZE51,A2
        BRA     SUBDN
SUBSIZE51
        LEA     SUBSIZE52,A2
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBEA
SUBSIZE52
        BRA     EXIT


*   110 long    DN,EA
SUBSIZE6
        LEA     MLONG,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     SUBSIZE61,A2
        BRA     SUBDN
SUBSIZE61
        LEA     SUBSIZE62,A2
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBEA
SUBSIZE62
        BRA     EXIT

SUBA
        LEA     MSUBA,A1                    Displays 'SUBA.'
        MOVE.B  #14,D0
        TRAP    #15
        
        * Does the rest of SUBA
        CMP.B   #$3,bit2
        BEQ     SUBSIZE7
        CMP.B   #$7,bit2
        BEQ     SUBSIZE8

SUBSIZE7
        LEA     MWORD,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     SUBSIZE71,A2
        BRA     SUBEA
SUBSIZE71
        LEA     SUBSIZE72,A2
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBAN2
SUBSIZE72
        BRA     EXIT


SUBSIZE8
        LEA     MLONG,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     SUBSIZE71,A2
        BRA     SUBEA
SUBSIZE81
        LEA     SUBSIZE72,A2
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBAN2
SUBSIZE82
        BRA     EXIT


SUBJMPA2
        JMP     (A2)

*   Displays data register
SUBDN
        LEA     MDN,A1
        MOVE.B  #14,D0
        TRAP    #15

        MOVE.B  bit1,D1
        MOVE.B  #3,D0
        TRAP    #15
        
        BRA     SUBJMPA2

*   Displays data register
*   This is for Dn -> Dn cases. Source Dn uses bit4 as register instead of bit1
SUBDN2
        LEA     MDN,A1
        MOVE.B  #14,D0
        TRAP    #15

        MOVE.B  bit4,D1
        MOVE.B  #3,D0
        TRAP    #15
        
        BRA     SUBJMPA2

*   Displays address register
SUBAN
        LEA     MAN,A1
        MOVE.B  #14,D0
        TRAP    #15

        MOVE.B  bit4,D1
        MOVE.B  #3,D0
        TRAP    #15
        
        BRA     SUBJMPA2

*   Displays address register
*   This is for SUBA, SUBA puts An into bit1
SUBAN2
        LEA     MAN,A1
        MOVE.B  #14,D0
        TRAP    #15

        MOVE.B  bit1,D1
        MOVE.B  #3,D0
        TRAP    #15
        
        BRA     SUBJMPA2


*   Displays indirect address register
SUBANID
        LEA     OPENBRA,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     MAN,A1
        MOVE.B  #14,D0
        TRAP    #15

        MOVE.B  bit4,D1
        MOVE.B  #3,D0
        TRAP    #15

        LEA     CLOSEBRA,A1
        MOVE.B  #14,D0
        TRAP    #15

        BRA     SUBJMPA2

*   Displays indirect address register with post increment
SUBANIDPOS
        LEA     OPENBRA,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     MAN,A1
        MOVE.B  #14,D0
        TRAP    #15

        MOVE.B  bit4,D1
        MOVE.B  #3,D0
        TRAP    #15

        LEA     CLOSEBRA,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     POS,A1
        MOVE.B  #14,D0
        TRAP    #15

        BRA     SUBJMPA2

*   Displays indirect address register with pre decrement
SUBANIDNEG
        LEA     NEG,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     OPENBRA,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     MAN,A1
        MOVE.B  #14,D0
        TRAP    #15

        MOVE.B  bit4,D1
        MOVE.B  #3,D0
        TRAP    #15

        LEA     CLOSEBRA,A1
        MOVE.B  #14,D0
        TRAP    #15

        BRA     SUBJMPA2





*   Code to display EA
SUBEA
        *   This finds which mode to use
        CMP.B   #$0,bit3
        BEQ     SUBDN2
        CMP.B   #$1,bit3                BYTE SIZED OPERATIONS ARE NOT ALLOWED FOR An
        BEQ     SUBAN
        CMP.B   #$2,bit3
        BEQ     SUBANID
        CMP.B   #$3,bit3
        BEQ     SUBANIDPOS
        CMP.B   #$4,bit3
        BEQ     SUBANIDNEG
        CMP.B   #$5,bit3
        BEQ     EXIT
        CMP.B   #$6,bit3
        BEQ     EXIT
        CMP.B   #$7,bit3
        BEQ     SUBEAHEX


        

SUBEAHEX
        CMP.B   #$4,bit4            Branches to immediate data section of bit4 is 4
        BEQ     SUBEAID

        *   Else it will assume it is absolute addressing mode
        LEA     MHEX,A1
        MOVE.B  #14,D0
        TRAP    #15

        CMP.B   #$0,bit4
        BEQ     SUBEAHEX1
        CMP.B   #$1,bit4
        BEQ     SUBEAHEX2
        
        *   write immediate data code here
        LEA     HASH,A1
        MOVE.B  #14,D0
        TRAP    #15

        CMP.B   #$1,bit2
        BEQ     SUBEAHEX1
        CMP.B   #$5,bit2
        BEQ     SUBEAHEX1
        CMP.B   #$2,bit2
        BEQ     SUBEAHEX2
        CMP.B   #$6,bit2
        BEQ     SUBEAHEX2


SUBEAID
        BRA     EXIT

SUBEAHEX1  
        *absolute address word
        MOVE.B  #2,D7
        BRA     SUBEAHEX3

SUBEAHEX2  *absolute address long
        MOVE.B  #4,D7
        BRA     SUBEAHEX3

SUBEAHEX3
        CMP.B   #0,D7               Compares current addr to ending addr
        BEQ     SUBJMPA2            Branches to done if they are equal

    
        MOVE.B  (A6)+,D2            Moves data at current address to D1, then increments
        
        MOVE.L  #0,D3               Resets D3 register to 0
        *   this gets digit in 10's place
        MOVE.B  D2,D3               Copies data at D2 to D3
        DIVS.W  #$10,D3             Divide data by 16, leaving first digit of number
        *   this gets digit in 1's place
        MOVE.B  D3,D4               Copies digit to D4
        MULS.W  #$10,D4             Multiply by 10 to get X0
        SUB.B   D4,D2               Subtract to get digit in ones place
        
        *   D3 holds digit in 10's place
        *   D2 holds digit in 1's place
        
        MOVE.B  D3,D1               Displays digit in 10's place first

        *   converts digits 10+ into letters

        LEA     SUBEAHEX4,A3             Place address of TENS into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9

        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15
        
SUBEAHEX4    
        MOVE.B  D2,D1               Displays digit in 1's place second

        *   converts digits 10+ into letters
        LEA     SUBEAHEX5,A3           Places address of NEXT into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9
        
        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15
        
SUBEAHEX5         
* Display counter -- creates new line every 8 bytes
        * D7 is used as counter
        
        SUB.B   #1,D7                       
        BRA     SUBEAHEX3              Loops back to display next address

***   display EA ends here




        *   converts number 10-15 to A-F
CONV    CMP.B   #10,D1              Displays 10 as A
        BEQ     HEXA
        CMP.B   #11,D1              Displays 11 as B
        BEQ     HEXB
        CMP.B   #12,D1              Displays 12 as C
        BEQ     HEXC
        CMP.B   #13,D1              Displays 13 as D
        BEQ     HEXD
        CMP.B   #14,D1              Displays 14 as E
        BEQ     HEXE
        CMP.B   #15,D1              Displays 15 as F
        BEQ     HEXF

HEXA    LEA     DISPA,A1            Loads A character
        BRA     PRINT
  
HEXB    LEA     DISPB,A1            Loads B character
        BRA     PRINT

HEXC    LEA     DISPC,A1            Loads C character
        BRA     PRINT

HEXD    LEA     DISPD,A1            Loads D character
        BRA     PRINT

HEXE    LEA     DISPE,A1            Loads E character
        BRA     PRINT

HEXF    LEA     DISPF,A1            Loads F character
        BRA     PRINT

PRINT   MOVE.B  #14,D0              Sets trap task to #14
        TRAP    #15                 Prints out message in A1
        JMP     (A3)
  
  
  

EXIT    MOVE.B  #9,D0
        TRAP    #15

************************************ Output stuff **************************************
CR      EQU     $0D
LF      EQU     $0A

SPACE       DC.B    ' ',0
LINE        DC.B    '',CR,LF,0
TAB         DC.B    '   ',0
COMMA       DC.B    ',',0
OPENBRA     DC.B    '(',0
CLOSEBRA    DC.B    ')',0
POS         DC.B    '+',0
NEG         DC.B    '-',0
HASH        DC.B    '#',0

DISPA       DC.B    'A',0
DISPB       DC.B    'B',0
DISPC       DC.B    'C',0
DISPD       DC.B    'D',0
DISPE       DC.B    'E',0
DISPF       DC.B    'F',0

MHEX        DC.B    '$',0
MBYTE       DC.B    'B ',0
MWORD       DC.B    'W ',0
MLONG       DC.B    'L ',0
MDN         DC.B    'D',0
MAN         DC.B    'A',0

MSUB        DC.B    'SUB.',0
MSUBA       DC.B    'SUBA.',0





    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
