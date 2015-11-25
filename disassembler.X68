*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


addr1   EQU     $7000
*addr2   EQU     $7050
addr2   EQU     $70E4
bit0    EQU     $FF0
bit1    EQU     $FF1
bit2    EQU     $FF2
bit3    EQU     $FF3
bit4    EQU     $FF4

    ORG    $1000
START:                  ; first instruction of program

        *   this stores some test EA into memory
        *LEA     addr1,A1
        *MOVE.W  #$9361,(A1)+        *917C
        *MOVE.W  #$917C,(A1)+       
        *MOVE.L  #$5555A7FF,(A1)+
        *MOVE.W  #$9078,(A1)+
        *MOVE.W  #$5555,(A1)+
        
        *MOVE.L  #$0,A1              This clears the memory at A1, not sure why i didn't it but its probably important
        
        MOVEA.L #addr1,A6           Moves starting addr into A6 register
        
******************************************** displays address location***********************************************
        
        
        
        
NEWADDR
        MOVE.L  A6,D7               Loads memory to data register
        CMP.L   #addr2,D7
        BGT     EXIT
        
        
        MOVE.B  #2,D6               D7 is a counter, used to know loop back once
        MOVE.L  D7,D2               Copies opcode saved in D2 to D7
        SWAP    D2
        BRA     DISPADDR2           Skips the second part to do later

DISPADDR1
        MOVE.W  D7,D2
DISPADDR2
        MOVE.W  D2,D1               Copies data at D2 to D3
        MOVE.W  D2,D3
        MOVE.W  D2,D4
        MOVE.W  D2,D5

        LSR.W   #8,D1
        LSR.W   #4,D1
        LSL.W   #4,D3
        LSR.W   #8,D3
        LSR.W   #4,D3
        LSL.W   #8,D4
        LSR.W   #8,D4
        LSR.W   #4,D4
        LSL.W   #8,D5
        LSL.W   #4,D5
        LSR.W   #8,D5
        LSR.W   #4,D5
        
        
        LEA     DISPADDR3,A3        Place address of TENS into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9

        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15
        
DISPADDR3   
        MOVE.B  D3,D1               Displays digit in 1's place second

        *   converts digits 10+ into letters
        LEA     DISPADDR4,A3           Places address of NEXT into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9
        
        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15

DISPADDR4
        MOVE.B  D4,D1               Displays digit in 1's place second

        *   converts digits 10+ into letters
        LEA     DISPADDR5,A3           Places address of NEXT into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9
        
        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15

DISPADDR5
        MOVE.B  D5,D1               Displays digit in 1's place second

        *   converts digits 10+ into letters
        LEA     DISPADDR6,A3           Places address of NEXT into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9
        
        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15
        
DISPADDR6
* Display counter -- creates new line every 8 bytes
        * D6 is used as counter
        
        SUB.B   #1,D6
        CMP.B   #0,D6
        BNE     DISPADDR1

        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15
        
*********************************************************************************************************************

        CLR     D1
        CLR     D2
        CLR     D3
        CLR     D4
        CLR     D5
        CLR     D6

        MOVE.B  (A6)+,D2            Moves data at current address to D1, then increments
        
        MOVE.B  D2,D7
        LSL.W   #8,D7
        
        MOVE.B  D2,D3               Copies data at D2 to D3
        *   this gets digit in 10's place
        LSR.B   #4,D3               Shifts right to get rid of 1's place
        *   this gets digit in 1's place
        LSL.B   #4,D2               Shifts left to get rid of 10's place
        LSR.B   #4,D2               Shifts back right into 1's place
        
        *   D3 holds digit in 10's place
        *   D2 holds digit in 1's place

        *   Moves second nibble to D5 to be used later
        MOVE.B  D2,D5
        MOVE.B  D3,bit0
        BRA     CODE

*   This is where the table goes to detirmine which op-code to use
CODE    CMP.B   #$9,D3              Goes to sub section
        BEQ     SUB
        BRA     INVOPCODE

        *   Grabs next two nibbles
SUB     MOVE.B  (A6)+,D2

        ADD.B   D2,D7

        MOVE.B  D2,D3               Copies data at D2 to D3
        *   this gets digit in 10's place
        LSR.B   #4,D3               Shifts right to get rid of 1's place
        *   this gets digit in 1's place
        LSL.B   #4,D2               Shifts left to get rid of 10's place
        LSR.B   #4,D2               Shifts back right into 1's place


        
        *   D3 holds digit in 10's place
        *   D2 holds digit in 1's place

        
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

        * do this later
        CLR     D1
        MOVE.L  #0,D2
        MOVE.L  #0,D3
        MOVE.L  #0,D4
        MOVE.L  #0,D5
        MOVE.L  #0,D6

        
*** sub display ***

        * This will display SUBA instead  check this later
        CMP.B   #$3,bit2
        BEQ     SUBA
        CMP.B   #$7,bit2
        BEQ     SUBA


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
        BSR     SUBPRINT
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
        BRA     ENDNEWLINE


*   001 word    EA,DN
SUBSIZE2
        BSR     SUBPRINT
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
        BRA     ENDNEWLINE

*   010 long    EA,DN
SUBSIZE3
        BSR     SUBPRINT
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
        BRA     ENDNEWLINE


*   100 byte    DN,EA
SUBSIZE4
        BSR     SUBPRINT
        LEA     MBYTE,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15

        BSR     SUBERRORTEST1

        LEA     SUBSIZE41,A2
        BRA     SUBDN
SUBSIZE41
        LEA     SUBSIZE42,A2
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBEA
SUBSIZE42
        BRA     ENDNEWLINE


*   101 word    DN,EA
SUBSIZE5
        BSR     SUBERRORTEST1               * This does error testing
        BSR     SUBPRINT                    * Prints out 'SUB.'
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
        BRA     ENDNEWLINE


*   110 long    DN,EA
SUBSIZE6
        BSR     SUBERRORTEST1               * This does error testing
        BSR     SUBPRINT                    * Prints out 'SUB.'
        LEA     MLONG,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15

        BSR     SUBERRORTEST1

        LEA     SUBSIZE61,A2
        BRA     SUBDN
SUBSIZE61
        LEA     SUBSIZE62,A2
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBEA
SUBSIZE62
        BRA     ENDNEWLINE

*   This section is for SUBA
SUBA
        LEA     MSUBA,A1                    Displays 'SUBA.'
        MOVE.B  #14,D0
        TRAP    #15
        
        * Does the rest of SUBA
        CMP.B   #$3,bit2
        BEQ     SUBSIZE7
        CMP.B   #$7,bit2
        BEQ     SUBSIZE8

*   SUBA Word   ea,An
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
        BRA     ENDNEWLINE

*   SUBA longword   ea,An
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
        BRA     ENDNEWLINE


SUBJMPA2
        JMP     (A2)

SUBPRINT
        * Displays 'SUB.' 
        LEA     MSUB,A1
        MOVE.B  #14,D0
        TRAP    #15

        RTS

SUBERRORTEST1
        * test for DN or AN register, branches to invalid op code if true
        CMP.B   #0,bit3
        BEQ     INVOP
        CMP.B   #1,bit3
        BEQ     INVOP
        
        * check if destination is immediate data
        CMP.B   #7,bit3
        BNE     SUBERRORTEST11
        CMP.B   #0,bit4
        BEQ     SUBERRORTEST11
        CMP.B   #1,bit4
        BEQ     SUBERRORTEST11
        BRA     INVOP
        
SUBERRORTEST11
        RTS

INVOPCODE
        ADD.B   (A6)+,D7

INVOP
        LEA     MDATA,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        MOVE.B  #2,D6               D6 is a counter, used to know loop back once
        
        MOVE.W  D7,D2               Copies opcode saved in D2 to D7
        LSR.W   #8,D2               Shifts D2 right 8 spaces to get the first byte of the word
        BRA     INVOP2              Skips the second part to do later

INVOP1
        MOVE.B  D7,D2
INVOP2
        MOVE.B  D2,D3               Copies data at D2 to D3
        *   this gets digit in 10's place
        LSR.B   #4,D3               Shifts right to get rid of 1's place
        *   this gets digit in 1's place
        LSL.B   #4,D2               Shifts left to get rid of 10's place
        LSR.B   #4,D2               Shifts back right into 1's place

        
        *   D3 holds digit in 10's place
        *   D2 holds digit in 1's place
        
        MOVE.B  D3,D1               Displays digit in 10's place first

        *   converts digits 10+ into letters

        LEA     INVOP3,A3        Place address of TENS into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9

        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15
        
INVOP3   
        MOVE.B  D2,D1               Displays digit in 1's place second

        *   converts digits 10+ into letters
        LEA     INVOP4,A3           Places address of NEXT into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9
        
        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15
        
INVOP4
* Display counter -- creates new line every 8 bytes
        * D6 is used as counter
        
        SUB.B   #1,D6
        CMP.B   #0,D6
        BEQ     ENDNEWLINE
        BRA     INVOP1              Loops back to display next address


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
SUBEAID2
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

        CMP.B   #$1,bit2            * SUB word
        BEQ     SUBEAHEX1
        CMP.B   #$5,bit2            * SUB word
        BEQ     SUBEAHEX1
        CMP.B   #$3,bit2            * SUBA word
        BEQ     SUBEAHEX1
        CMP.B   #$2,bit2            * SUB longword
        BEQ     SUBEAHEX2
        CMP.B   #$6,bit2            * SUB longword
        BEQ     SUBEAHEX2
        CMP.B   #$7,bit2            * SUBA longword
        BEQ     SUBEAHEX2


SUBEAID
        LEA     HASH,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBEAID2

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
        
        MOVE.B  D2,D3               Copies data at D2 to D3
        *   this gets digit in 10's place
        LSR.B   #4,D3               Shifts right to get rid of 1's place
        *   this gets digit in 1's place
        LSL.B   #4,D2               Shifts left to get rid of 10's place
        LSR.B   #4,D2               Shifts back right into 1's place

        
        *   D3 holds digit in 10's place
        *   D2 holds digit in 1's place
        
        MOVE.B  D3,D1               Displays digit in 10's place first

        *   converts digits 10+ into letters

        LEA     SUBEAHEX4,A3        Place address of TENS into A3 to continue from there after conversion
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


ENDNEWLINE
        LEA     NEWLINE,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     NEWADDR

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
NEWLINE        DC.B    '',CR,LF,0
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

MDATA       DC.B    'DATA',0
MSUB        DC.B    'SUB.',0
MSUBA       DC.B    'SUBA.',0
MERROR      DC.B    'ERROR',0





    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
