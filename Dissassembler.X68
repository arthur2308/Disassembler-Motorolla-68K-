*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Code for output 
    LEA     GREETING,A1
    MOVE.B  #14,D0
    TRAP    #15
    
* Code for input
    MOVE.B  #4,D0
    TRAP    #15    

    MOVE.B  #9,D0
    TRAP    #15


* Put variables and constants here

CR          EQU     $0D
LF          EQU     $0A
GREETING    DC.B    'Hello and welcome to the dissassembler!',CR,LF
            DC.B    'Please enter an andress:',CR,LF, 0   
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
