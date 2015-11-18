*-----------------------------------------------------------
* Title      :Lab 2
* Written by :Phat Tran
* Date       :10/21/15
* Description:CSS422 lab work
*-----------------------------------------------------------

addr1   EQU     $1000               starting address
addr2   EQU     $10A0               ending address

    ORG    $1000
START:                              ; first instruction of program

*   Code for output
        LEA     MESSAGE,A1          Loads message into register A1
        MOVE.B  #14,D0              Moves the number 14 into data register D0
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

    
        MOVE.B  (A6)+,D1            Moves data at current address to D1, then increments

    * Reason this is needed is because data at A0 and up are seen as negative since the leading
    *   bit is 1. This code skips those numbers are they are higher than zero and 10. 
        CMP.B   #0,D1               Compares D1 to zero
        BLT     HEX                 Branches to HEX if it is less than zero

        CMP.B   #$10,D1             Compares data to hex 10
        BLT     ZERO                Adds a zero if it is single hex

HEX     MOVE.B  #16,D2              Sets D1 as a HEX number for trap task 15
        MOVE.B  #15,D0              Sets trap task as #15
        TRAP    #15
        
        LEA     SPACE,A1            Loads message into register A1
        MOVE.B  #14,D0              Moves the number 14 into data register D0
        TRAP    #15                 Displays message
        
* Display counter -- creates new line every 8 bytes
        * D7 is used as counter
        
        ADDQ.B  #1,D7               Adds 1 to D7
        CMP.B   #16,D7               Compares 8 to D7
        BEQ     RESET
        
        BRA     LOOP                Loops back to display next address

RESET   MOVEQ   #0,D7               Sets counter back to zero
        LEA     LINE,A1             Creates a new line
        MOVE.B  #14,D0
        TRAP    #15
        BRA     LOOP                Goes back into loop

ZERO    LEA     DISPZERO,A1         Loads zero
        MOVE.B  #14,D0              Sets trap task to #14
        TRAP    #15
        BRA     HEX

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
DISPZERO    DC.B    '0',0             message for #0
SPACE       DC.B    ' ',0
LINE        DC.B    '',CR,LF,0
CLOSE       DC.B    'Goodbye!',CR,LF,0

        END    START        ; last line of source











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
