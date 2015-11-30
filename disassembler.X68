*-----------------------------------------------------------
* Title      : Disassembler
* Written by : Team A (Phat, Felicia, Arthur)
* Date       : Thanksgiving 2015 (We started earlier but I happen to be filling this in today)
* Description: Converts assembly language written in hex to readable human code (CSS422 Project)
*-----------------------------------------------------------


********************************
* INFO:
* bit0-4 are used to store information about binary op-code split into it's split-up stage
* They are stored at the end of the code. (You can find code for storage at the end, after all the messages.)
*   bit0 - Store first hex of op code
*   bit1 - Store first 'bit' of a split op code
*   bit2 - Store second 'bit' of a split op code
*   bit3 - Store third 'bit' of a split op code
*   bit4 - Store fourth 'bit' of a split op code
* 
* 
* 
* COMPLETED WORK:
* SUB
* SUBA
* AND
* ADD   - NOT TESTED
* SUBI
* ORI   - EORI and CMPI uses the same logic as these two
* NOT
* 
* 
****************************************************************************


* sets start and end address
* temp hard code
* make UI later for input
addr1   EQU     $7000
*addr2   EQU     $7050
addr2   EQU     $725A


    ORG    $1000
START:                  ; first instruction of program

        


        *   this stores some test EA into memory
        *LEA     addr1,A1
        *MOVE.W  #$0440,(A1)+        *917C
        *MOVE.W  #$917C,(A1)+       
        *MOVE.L  #$5555A7FF,(A1)+
        *MOVE.W  #$9078,(A1)+
        *MOVE.W  #$5555,(A1)+
        
        *MOVE.L  #$0,A1              This clears the memory at A1, not sure why i didn't it but its probably important
        
        MOVE.W  #$3846, $7000
        
******************************************** displays address location***********************************************
* This displays the address location of the op-code being worked on
* A6 is used as current address

        MOVEA.L #addr1,A6            Moves starting addr into A6 register
        
NEWADDR
        MOVE.L  A6,D7               Loads the current address into D7
        CMP.L   #addr2,D7            Compares current address to end address
        BGT     DONE                Branches to done if current address > end address
        
        
        MOVE.B  #2,D6               D6 is a counter, used for looping
        MOVE.L  D7,D2               Copies opcode saved in D7 to D2 to be manipulated
        SWAP    D2                  Swaps the location to be displayed (Display first word of a long word)
        BRA     DISPADDR2           Skips the second part to do later

DISPADDR1
        MOVE.W  D7,D2
DISPADDR2
        MOVE.W  D2,D1               D1 will be the first byte of the word
        MOVE.W  D2,D3               D3 will be the second byte of the word
        MOVE.W  D2,D4               D4 will be the third byte of the word
        MOVE.W  D2,D5               D5 will be the fourth byte of the word

        LSR.W   #8,D1               Shifts D1 right 12 times to move the first byte of the word to the last byte
        LSR.W   #4,D1
        LSL.W   #4,D3               Shifts D3 left 4 times to get rid of the first byte
        LSR.W   #8,D3                 Then shifts D3 right 12 times to move it to the last byte
        LSR.W   #4,D3
        LSL.W   #8,D4               Shifts D4 to the left 8 times to get rid of first 2 bytes
        LSR.W   #8,D4                 Then shifts it right 12 times to move it to the last byte
        LSR.W   #4,D4
        LSL.W   #8,D5               Shifts D5 to the left 12 times to get rid of the first 3 bytes
        LSL.W   #4,D5                 Then shifts it back to the left 12 times to move it to the last byte position
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
* Splits the first byte of the op code into nibbles
* then sends it to the branch-table to jump to the appropiate section to be decoded

        CLR.L   D1                  Clears the data registers
        CLR.L   D2
        CLR.L   D3
        CLR.L   D4
        CLR.L   D5
        CLR.L   D6
        MOVE.W  (A6),D6
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
        *   Goes to a branch-table to figure out which op code it is
        BRA     CODE

******************************************************************************************************
*   This is where the table goes to detirmine which op-code to use
CODE    
        CMP.B   #$0,D3              Goes to immediate operation section
        BEQ     IMD
        CMP.B   #$4,D3              Goes to miscellaneous section
        BEQ     MISC
        CMP.B   #$9,D3              Goes to sub section
        BEQ     SUB
        CMP.B   #$C,D3              Goes to sub but displays as AND
        BEQ     SUB
        CMP.B   #$D,D3              Goes to sub but displays as ADD
        BEQ     SUB
        CMP.B   #$1,D3
        BEQ     MOVB                Goes to movb
        CMP.B   #$3,D3
        BEQ     MOVW                Goes to movb
        CMP.B   #$2,D3
        BEQ     MOVL                Goes to movb

        BRA     INVOPCODE

MOVW
        
        
        LSR.B   #1, D2
        MOVE.B  D2, bit1
        
        MOVE.B  (A6), D2
        LSL.B   #5, D2
        LSR.B   #5, D2
        MOVE.B  D2, bit4
        
        MOVE.B  (A6), D2
        LSL.B   #2, D2
        LSR.B   #5, D2
        MOVE.B  D2, bit3
        
        LSL.W   #7, D6
        LSR.W   #8, D6 
        LSR.W   #5, D6 
        MOVE.B  D6, bit2

        CMP.B   #$1, bit2
        BEQ     MOVEAW

        LEA MMOVEW, A1
        MOVE.B  #14, D0
        TRAP    #15 

        CMP.B   #$0, bit3           
        BEQ     MOVBDN1
        CMP.B   #$1, bit3
        BEQ     MOVEAN1
        CMP.B   #$2, bit3
        BEQ     MOVEIAN1
        CMP.B   #$3, bit3
        BEQ     MOVEIANI1
        CMP.B   #$4, bit3
        BEQ     MOVEIAND1
        CMP.B   #$7, bit3
        BEQ     ADDIMD
        
        * Add INVOP 
MOVEAW
        LEA MMOVEAW, A1
        MOVE.B  #14, D0
        TRAP    #15 
        
        CMP.B   #$0, bit3           
        BEQ     MOVBDN1
        CMP.B   #$1, bit3
        BEQ     MOVEAN1
        CMP.B   #$2, bit3
        BEQ     MOVEIAN1
        CMP.B   #$3, bit3
        BEQ     MOVEIANI1
        CMP.B   #$4, bit3
        BEQ     MOVEIAND1
        CMP.B   #$7, bit3
        BEQ     ADDIMD

MOVL
        LSR.B   #1, D2
        MOVE.B  D2, bit1
        
        MOVE.B  (A6), D2
        LSL.B   #5, D2
        LSR.B   #5, D2
        MOVE.B  D2, bit4
        
        MOVE.B  (A6), D2
        LSL.B   #2, D2
        LSR.B   #5, D2
        MOVE.B  D2, bit3
        
        LSL.W   #7, D6
        LSR.W   #8, D6 
        LSR.W   #5, D6 
        MOVE.B  D6, bit2
        
        CMP.B   #$1, bit2
        BEQ     MOVEAL

        LEA MMOVEL, A1
        MOVE.B  #14, D0
        TRAP    #15 
        
        CMP.B   #$0, bit3           
        BEQ     MOVBDN1
        CMP.B   #$1, bit3
        BEQ     MOVEAN1
        CMP.B   #$2, bit3
        BEQ     MOVEIAN1
        CMP.B   #$3, bit3
        BEQ     MOVEIANI1
        CMP.B   #$4, bit3
        BEQ     MOVEIAND1
        CMP.B   #$7, bit3
        BEQ     ADDIMD
        
MOVEAL
        LEA MMOVEAL, A1
        MOVE.B  #14, D0
        TRAP    #15 
        
        CMP.B   #$0, bit3           
        BEQ     MOVBDN1
        CMP.B   #$1, bit3
        BEQ     MOVEAN1
        CMP.B   #$2, bit3
        BEQ     MOVEIAN1
        CMP.B   #$3, bit3
        BEQ     MOVEIANI1
        CMP.B   #$4, bit3
        BEQ     MOVEIAND1
        CMP.B   #$7, bit3
        BEQ     ADDIMD        

MOVB
        LEA MMOVEB, A1
        MOVE.B  #14, D0
        TRAP    #15 
        
        LSR.B   #1, D2
        MOVE.B  D2, bit1
        
        MOVE.B  (A6), D2
        LSL.B   #5, D2
        LSR.B   #5, D2
        MOVE.B  D2, bit4
        
        MOVE.B  (A6), D2
        LSL.B   #2, D2
        LSR.B   #5, D2
        MOVE.B  D2, bit3
        
        LSL.W   #7, D6
        LSR.W   #8, D6 
        LSR.W   #5, D6 
        MOVE.B  D6, bit2
        
        CMP.B   #$0, bit3           
        BEQ     MOVBDN1
        CMP.B   #$1, bit3
        BEQ     MOVEAN1
        CMP.B   #$2, bit3
        BEQ     MOVEIAN1
        CMP.B   #$3, bit3
        BEQ     MOVEIANI1
        CMP.B   #$4, bit3
        BEQ     MOVEIAND1
        CMP.B   #$7, bit3
        BEQ     ADDIMD

ADDIMD
    CMP.B   #$0, bit4
    BEQ     ADDIMD0
    CMP.B   #$1, bit4
    BEQ     ADDIMD1
    CMP.B   #$3, bit4
    BEQ     ADDIMD3

ADDIMD0
    * TODO 
ADDIMD1 
    * TODO
ADDIMD3
    * TODO    
MOVEAN1
    LEA TAB, A1
    MOVE.B  #14,D0
    TRAP    #15

    LEA DISPA,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  bit4, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA COMMA, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    CMP.B   #$0,bit2
    BEQ     MOVBDN2
    CMP.B   #$1,bit2
    BEQ     MOVEAN2
    CMP.B   #$2, bit2 
    BEQ     MOVIAN2
    CMP.B   #$3, bit2 
    BEQ     MOVIANI2
    CMP.B   #$4, bit2 
    BEQ     MOVIAND2
    
MOVEIAN1
    LEA TAB, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA OPENBRA, A1
    MOVE.B  #14,D0
    TRAP    #15

    LEA DISPA,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  bit4, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA CLOSEBRA, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA COMMA, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    CMP.B   #$0,bit2
    BEQ     MOVBDN2
    CMP.B   #$1,bit2
    BEQ     MOVEAN2
    CMP.B   #$2, bit2 
    BEQ     MOVIAN2
    CMP.B   #$3, bit2 
    BEQ     MOVIANI2
    CMP.B   #$4, bit2 
    BEQ     MOVIAND2

MOVEIANI1
    LEA TAB, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA OPENBRA, A1
    MOVE.B  #14,D0
    TRAP    #15

    LEA DISPA,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  bit4, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA CLOSEBRA, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA POS, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA COMMA, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    CMP.B   #$0,bit2
    BEQ     MOVBDN2
    CMP.B   #$1,bit2
    BEQ     MOVEAN2
    CMP.B   #$2, bit2 
    BEQ     MOVIAN2
    CMP.B   #$3, bit2 
    BEQ     MOVIANI2
    CMP.B   #$4, bit2 
    BEQ     MOVIAND2

MOVEIAND1
    LEA TAB, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA NEG, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA OPENBRA, A1
    MOVE.B  #14,D0
    TRAP    #15

    LEA DISPA,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  bit4, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA CLOSEBRA, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA COMMA, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    CMP.B   #$0,bit2
    BEQ     MOVBDN2
    CMP.B   #$1,bit2
    BEQ     MOVEAN2
    CMP.B   #$2, bit2 
    BEQ     MOVIAN2
    CMP.B   #$3, bit2 
    BEQ     MOVIANI2
    CMP.B   #$4, bit2 
    BEQ     MOVIAND2

MOVBDN1
    LEA TAB, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA DISPD, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  bit4, D1
    MOVE.B  #3,D0
    TRAP    #15
    
    LEA COMMA, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    CMP.B   #$0,bit2
    BEQ     MOVBDN2
    CMP.B   #$1,bit2
    BEQ     MOVEAN2
    CMP.B   #$2, bit2 
    BEQ     MOVIAN2
    CMP.B   #$3, bit2 
    BEQ     MOVIANI2
    CMP.B   #$4, bit2 
    BEQ     MOVIAND2
    
MOVEAN2
    LEA DISPA,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  bit1, D1
    MOVE.B  #3, D0
    TRAP    #15

    MOVE.B  (A6)+, $7500            * Kind of sketch but makes it work 
    BRA     ENDNEWLINE    
    
MOVIAN2
    LEA OPENBRA, A1
    MOVE.B  #14,D0
    TRAP    #15

    LEA DISPA,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  bit1, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA CLOSEBRA, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  (A6)+, $7500            * Kind of sketch but makes it work 
    BRA     ENDNEWLINE

MOVIANI2
    LEA OPENBRA, A1
    MOVE.B  #14,D0
    TRAP    #15

    LEA DISPA,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  bit1, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA CLOSEBRA, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA POS, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  (A6)+, $7500            * Kind of sketch but makes it work 
    BRA     ENDNEWLINE

MOVIAND2
    LEA NEG, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA OPENBRA, A1
    MOVE.B  #14,D0
    TRAP    #15

    LEA DISPA,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  bit1, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA CLOSEBRA, A1
    MOVE.B  #14,D0
    TRAP    #15

    MOVE.B  (A6)+, $7500            * Kind of sketch but makes it work 
    BRA     ENDNEWLINE

MOVBDN2
    LEA DISPD, A1
    MOVE.B  #14,D0
    TRAP    #15
        
    MOVE.B  bit1, D1
    MOVE.B  #3,D0
    TRAP    #15   
    
    MOVE.B  (A6)+, $7500            * Kind of sketch but makes it work 
    BRA     ENDNEWLINE
    
    
******************************************************************************************************
*   Immediate data arithmetic operations
*   SUBI

IMD     MOVE.B  D5,bit1
        MOVE.B  (A6)+,D2

        ADD.B   D2,D7

        MOVE.B  D2,D3               Copies data at D2 to D3
        *   this gets digit in 10's place
        LSR.B   #4,D3               Shifts right to get rid of 1's place
        *   this gets digit in 1's place
        LSL.B   #4,D2               Shifts left to get rid of 10's place
        LSR.B   #4,D2               Shifts back right into 1's place

        *   D3 holds digit in 10's place
        *   D2 holds digit in 1's place

        LSR.B   #1,D3
        BCC     IMD2
        ADD.B   #$2,D4
IMD2    LSR.B   #1,D3
        BCC     IMD3
        ADD.B   #$4,D4
IMD3    CMP.B   #$7,D2
        BLT     IMD4
        ADD.B   #$1,D4
        SUB.B   #$8,D2

        *   Stores them into addr
IMD4    MOVE.B  D3,bit2
        MOVE.B  D4,bit3
        MOVE.B  D2,bit4

**************************
* This finds the size of the operation

        CMP.B   #$0,bit2
        BEQ     IMDBYTE
        CMP.B   #$1,bit2
        BEQ     IMDWORD
        CMP.B   #$2,bit2
        BEQ     IMDLONG
        BRA     INVOP

*************************************************************
* Display IMD op-code
IMDPRINT
        CMP.B   #$0,bit1
        BEQ     IMDPRINTORI
        CMP.B   #$4,bit1
        BEQ     IMDPRINTSUBI
        CMP.B   #$6,bit1
        BEQ     IMDPRINTNOT

IMDPRINTORI
        LEA     MORI,A1
        BRA     IMDPRINTEND

IMDPRINTSUBI
        LEA     MSUBI,A1
        BRA     IMDPRINTEND

* NOT isn't part of immediate operation, but they share similar structure so I put it here too
IMDPRINTNOT
        LEA     MNOT,A1
        BRA     IMDPRINTEND

IMDPRINTEND
        MOVE.B  #14,D0
        TRAP    #15
        RTS

*************************************************************
* Immediate data operation size BYTE
IMDBYTE
        BSR     IMDPRINT
        LEA     MBYTE,A1

        * Moves size to D4, needed to use DISPEA
        MOVE.B  #$1,D4
        BRA     IMDEA

*************************************************************
* Immediate data operation size WORD
IMDWORD
        BSR     IMDPRINT
        LEA     MWORD,A1

        MOVE.B  D3,D4
        BRA     IMDEA


*************************************************************
* Immediate data operation size LONG
IMDLONG
        BSR     IMDPRINT
        LEA     MLONG,A1
        

        * Moves size to D4, needed to use DISPEA
        MOVE.B  D3,D4

IMDEA
        * This prints out the size and creates tab
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15
        * Loads return address into A2
        LEA     IMDEA2,A2
        BRA     DISPEA
IMDEA2
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     IMDEA3,A2
        BRA     SUBEA
IMDEA3
        BRA     ENDNEWLINE

******************************************************************************************************
* Miscellaneous section
*   Not goes here

MISC
        MOVE.B  D5,bit1
        MOVE.B  (A6)+,D2

        ADD.B   D2,D7

        MOVE.B  D2,D3               Copies data at D2 to D3
        *   this gets digit in 10's place
        LSR.B   #4,D3               Shifts right to get rid of 1's place
        *   this gets digit in 1's place
        LSL.B   #4,D2               Shifts left to get rid of 10's place
        LSR.B   #4,D2               Shifts back right into 1's place

        *   D3 holds digit in 10's place
        *   D2 holds digit in 1's place

        LSR.B   #1,D3
        BCC     MISC2
        ADD.B   #$2,D4
MISC2   LSR.B   #1,D3
        BCC     MISC3
        ADD.B   #$4,D4
MISC3   CMP.B   #$7,D2
        BLT     MISC4
        ADD.B   #$1,D4
        SUB.B   #$8,D2

        *   Stores them into addr
MISC4   MOVE.B  D3,bit2
        MOVE.B  D4,bit3
        MOVE.B  D2,bit4

**************************
* This finds the size of the operation

        CMP.B   #$6,bit1
        BEQ     MISCNOT
        BRA     INVOP

******************************************************
* NOT
* Reuses some of IMD section to display because they have similar format
*  (I was kinda lazy too)
MISCNOT
        CMP.B   #$0,bit2
        BEQ     MISCBYTE
        CMP.B   #$1,bit2
        BEQ     MISCWORD
        CMP.B   #$2,bit2
        BEQ     MISCLONG

*************************************************************
* Immediate data operation size BYTE
MISCBYTE
        BSR     IMDPRINT
        LEA     MBYTE,A1

        * Moves size to D4, needed to use DISPEA
        MOVE.B  #$1,D4
        BRA     MISCEA

*************************************************************
* Immediate data operation size WORD
MISCWORD
        BSR     IMDPRINT
        LEA     MWORD,A1

        MOVE.B  D3,D4
        BRA     MISCEA


*************************************************************
* Immediate data operation size LONG
MISCLONG
        BSR     IMDPRINT
        LEA     MLONG,A1

        * Moves size to D4, needed to use DISPEA
        MOVE.B  D3,D4

MISCEA
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15

        LEA     MISCEA2,A2
        BRA     SUBEA
MISCEA2
        BRA     ENDNEWLINE


******************************************************************************************************
* SUB section

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

        
******************************************************************************************************
* After spliting the op-code into SUB's defined groupings
*   This figures out which operation it is and goes to that sub-routine

        * This will display SUBA instead  -- check this later
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
   
******************************************************************************************************
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

*************************************************
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

*************************************************
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

*************************************************
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

*************************************************
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

*************************************************
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

****************************************************************************
*   This section is for SUBA
*   Displays 'SUBA.' then decodes the op-code as SUBA
SUBA
        LEA     MSUBA,A1                    Displays 'SUBA.'
        MOVE.B  #14,D0
        TRAP    #15
        
        * Does the rest of SUBA
        CMP.B   #$3,bit2
        BEQ     SUBSIZE7
        CMP.B   #$7,bit2
        BEQ     SUBSIZE8

*************************************************
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

*************************************************
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

*************************************************
* Jumps to memory location at A2
SUBJMPA2
        JMP     (A2)

*************************************************
* Prints out opcode name
SUBPRINT
        CMP.B   #$9,bit0                Prints SUB
        BEQ     SUBPRINTSUB
        CMP.B   #$C,bit0                Prints AND
        BEQ     SUBPRINTAND
        CMP.B   #$D,bit0                Prints ADD
        BEQ     SUBPRINTADD



SUBPRINTSUB   * Displays 'SUB.' 
        LEA     MSUB,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBPRINTEND

SUBPRINTAND   * Displays 'AND.' 
        LEA     MAND,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBPRINTEND

SUBPRINTADD   * Displays 'ADD.' 
        LEA     MADD,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     SUBPRINTEND


SUBPRINTEND
        RTS


*******************************************************************
* Error testing for DN->EA operations
*  Data register, address register, and immediate data cannot be destinations
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


******************************************************************************************************
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




******************************************************************************************************
* Displays the EA as hex numbers
* 
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
        BEQ     ERROR
        CMP.B   #$6,bit3
        BEQ     ERROR
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

        CMP.B   #$0,bit2            * SUB byte displays as word
        BEQ     SUBEAHEX1
        CMP.B   #$4,bit2            * SUB byte displays as word
        BEQ     SUBEAHEX1
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

******************************************************************************************************
* Displays the EA as hex numbers
* INPUT: Size of EA in D4; 1 = word, 2 = longword
* OUTPUT: Displays size of EA reading from A6
* Jumps to location stored in A2 when finished
DISPEA
        LEA     MHEX,A1
        MOVE.B  #14,D0
        TRAP    #15

        CMP.B   #$2,D4              Branches to longword display if size is 2
        BEQ     DISPEALONG          Else it will assume word length

DISPEAWORD
        *absolute address word
        MOVE.B  #2,D7
        BRA     DISPEA3
 
DISPEALONG
        *absolute address long
        MOVE.B  #4,D7
        BRA     DISPEA3

DISPEA3
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

        LEA     DISPEA4,A3        Place address of TENS into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9

        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15
  
DISPEA4
        MOVE.B  D2,D1               Displays digit in 1's place second

        *   converts digits 10+ into letters
        LEA     DISPEA5,A3           Places address of NEXT into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9
        
        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15
      
DISPEA5
* Display counter -- creates new line every 8 bytes
        * D7 is used as counter
        
        SUB.B   #1,D7                       
        BRA     DISPEA3              Loops back to display next address

***   display EA ends here


********************************************************************
* Invalid op-code handling
* Displays DATA YYYY
*  YYYY represents the op-code that failed
INVOPCODE
        ADD.B   (A6)+,D7

INVOP
        LEA     MDATA,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     TAB,A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     MHEX,A1
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


******************************************************************************************************
* Creates a new line after an op-code is displayed, loops back to start to display next code
ENDNEWLINE
        LEA     NEWLINE,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     NEWADDR

******************************************************************************************************
* Converts decimal number into hex and displays it
*   converts number 10-15 to A-F
*   INPUT: decimal number in D1
*   OUTPUT: HEX number to output
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

ERROR   LEA     MERROR,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     EXIT

DONE    LEA     MDONE,A1
        MOVE.B  #14,D0
        TRAP    #15

EXIT    MOVE.B  #9,D0
        TRAP    #15

************************************ Output stuff **************************************
* Stuff for output

CR      EQU     $0D
LF      EQU     $0A

SPACE       DC.B    ' ',0
NEWLINE     DC.B    '',CR,LF,0
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

MMOVEB      DC.B    'MOVE.B',0
MMOVEW      DC.B    'MOVE.W',0
MMOVEL      DC.B    'MOVE.L',0
MMOVEAW     DC.B    'MOVEA.W',0
MMOVEAL     DC.B    'MOVEA.L',0
MDATA       DC.B    'DATA',0
MSUB        DC.B    'SUB.',0
MSUBA       DC.B    'SUBA.',0
MAND        DC.B    'AND.',0
MADD        DC.B    'ADD.',0
MSUBI       DC.B    'SUBI.',0
MORI        DC.B    'ORI.',0
MNOT        DC.B    'NOT.',0

MERROR      DC.B    'ERROR: Something broke',0
MDONE       DC.B    'COMPLETE: IT DID NOT CRASH',0


********************************** MEMORY STORAGE **********************************************
* Stores memory locations at the end of the program
* How DS works: Give it a variable name.
*   DS means Define Storage. Give it a size of how big you want the storage to be (Byte, Word, Longword)
*   Last is the number of storage you want. 
*   Example: DS.W   1   This creates a 1 longword location to be used. Memory would look like: FF FF
*            DS.B   3   This creates three byte-sized locations to be used. Memory would look like: FF FF FF
*            

bit0        DS.B    1           SEE NOTE UP TOP
bit1        DS.B    1           SEE NOTE UP TOP
bit2        DS.B    1           SEE NOTE UP TOP
bit3        DS.B    1           SEE NOTE UP TOP
bit4        DS.B    1           SEE NOTE UP TOP


    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
