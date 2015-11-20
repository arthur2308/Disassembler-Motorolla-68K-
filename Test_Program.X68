*-----------------------------------------------------------
* Title      :Hello World
* Written by :Arthur Bulan
* Date       :10/22/2015
* Description:Tutorial program for lab2
*-----------------------------------------------------------
START    ORG    $3000
             
        MOVE.B  D6, D4
        MOVEA.W  D6, A4
        MOVEM.L a0-a4/a6/d0-d3/d5/d7, -(A3)
        MULS.W  D6, D7
        DIVS.W   D3 ,D2
        NEG.W      D3
        LSL     D3, D2 
        LSR     D3, D2 
        BTST  D3, D2 
        BRA START 
        RTS
         
        
        MOVE.W  A4, D5
        MOVEA.W  A4, A5
       
       
       
        MOVE.B  (A3),   D6
        MOVEA.W  (A3),   A6
        DIVS.W  (A3) , D6   
        NEG.W    (A3)
        LSL     (A3)
        LSR     (A3)
        BTST  D3, (A3)
        JSR     (A3)
 
        MOVE.B  #16, D3  
        MOVEA.W  #16, A3  
        MULS.W  #1245,    D5 
        DIVS.W  #2635, D4 
        
         
        MOVE.B  (A4)+,  D2
        MULS.W  (A4)+, D2
        DIVS.W  (A3)+,  D2 
        NEG.W     (A3)+
        LSL       (A3)+
        LSR       (A3)+
        BTST   D2, (A3)+
        
        MOVE.B  -(A2),  D1
        MULS.W  -(A2),  D1
        DIVS.W   -(A2),  D1
        NEG.W      -(A2)
        LSL       -(A2)
        LSR       -(A2)
        BTST      D1, -(A2)
        
        MOVE.B  $4501.L,    D2
        MULS.W  $1245.L,    D5
        DIVS.W  $1233.L, D5
        NEG.W   $5641.L
        LSL      $5641.L
        LSR      $5641.L
        BTST    D5, $5454.L 
        JSR $5454.L 
        
        MOVE.B  $4501.W,    D2
        MULS.W  $1245.W,    D5
        DIVS.W  $7545.W,   D5
        NEG.W   $5641.W   
        LSL      $5641.W
        LSR      $5641.W
        BTST    D5, $5454.W 
        JSR $5454.W 

        END     $3000      
        
        
        
        
        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
