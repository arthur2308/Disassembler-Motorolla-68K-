*-----------------------------------------------------------
* Title      :Lab 2
* Written by :Phat Tran
* Date       :10/21/15
* Description:CSS422 lab work
*-----------------------------------------------------------

addr1   EQU     $1000               starting address
addr2   EQU     $1140               ending address

    ORG    $1000
START:                              ; first instruction of program

*   Code for output
        LEA     MESSAGE,A1          Loads welcome message into register
        MOVE.B  #14,D0              Prepares to display message
        TRAP    #15                 Displays message
        
*   Code for setting addresses
        * starting address = A4
        * ending address   = A5
        * current address  = A6
        
        MOVEA.L #addr1,A4           Moves starting address to A4
        MOVEA.L #addr2,A5           Moves ending address to A5

        MOVEA.L A4,A6               Moves starting address to A6
        
*   Code for retrieving data and displaying it
LOOP    CMPA.L  A6,A5               Compares current addr to ending addr
        BEQ     DONE                Branches to done if they are equal

    
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
        LEA     TENS,A3             Place address of TENS into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9

        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15
        
TENS    MOVE.B  D2,D1               Displays digit in 1's place second

        *   converts digits 10+ into letters
        LEA     NEXT,A3             Places address of NEXT into A3 to continue from there after conversion
        CMP.B   #9,D1               Compares digit to 9
        BGT     CONV                Print out letter representation if greater than 9
        
        MOVE.B  #3,D0               Displays digit if it is less than A
        TRAP    #15
        
NEXT    LEA     SPACE,A1            Loads single space ' ' into register
        MOVE.B  #14,D0              Prepares to display message
        TRAP    #15                 Displays message
        
* Display counter -- creates new line every 8 bytes
        * D7 is used as counter
        
        ADDQ.B  #1,D7               Adds 1 to D7
        CMP.B   #16,D7              Compares 16 to D7
        BEQ     RESET
        
        BRA     LOOP                Loops back to display next address



RESET   MOVEQ   #0,D7               Sets counter back to zero
        LEA     LINE,A1             Creates a new line
        MOVE.B  #14,D0
        TRAP    #15
        BRA     LOOP                Goes back into loop

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

DONE    LEA     LINE,A1             Creates a new line
        MOVE.B  #14,D0
        TRAP    #15
        LEA     CLOSE,A1            Displays closing message
        MOVE.B  #14,D0
        TRAP    #15
        MOVE.B  #9,D0               Halts simulator
        TRAP    #15
    
CR      EQU     $0D                 ASCII code for carriage return
LF      EQU     $0A                 ASCII code for line feed


MESSAGE     DC.B    'Welcome',CR,LF,0                input message
SPACE       DC.B    ' ',0
LINE        DC.B    '',CR,LF,0
CLOSE       DC.B    'Goodbye!',CR,LF,0
DISPA       DC.B    'A',0
DISPB       DC.B    'B',0
DISPC       DC.B    'C',0
DISPD       DC.B    'D',0
DISPE       DC.B    'E',0
DISPF       DC.B    'F',0


        END    START        ; last line of source











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
