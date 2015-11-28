
**********************************************************************

*

*  Beginning of EQUates section, just like #define in C

*

**********************************************************************

addr1     EQU     $4000        

addr2     EQU     $4001 

data1	  EQU	  $C0

data2     EQU     $A7FF 

data3     EQU     $5555

data4     EQU     $0000 

data5     EQU     4678 

data6     EQU     %01001111 

data7     EQU     %00010111 




**********************************************************************

*

* Beginning of code segment. This is the actual assembly language instructions.

*

*****************************************************************************************************

 

	ORG	$7000          * This pseudo op code tells the assembler  here                                                                                                                         
START
                                           * the program will run in memory

start	MOVE.W	#data2,D0     * Load D0 

    	MOVE.B	#data6,D1     * Load D1 

    	MOVE.B	#data7,D2     * load D2 

	    MOVE.W	#data3,D3     * load D3 

	    MOVEA.W	#addr1,A0     * load address register 

	    MOVEA.W	#addr1,A1	* not sure what this is



********************************** SUB *********************************
* sub byte



	    SUB.B	#data1,D0	* immediate data to D0 byye

	    SUB.B	D1,(A0)+	* sub post-increment to D1

	    SUB.B	D1,-(A1)	* sub pre-increment to D1

	    SUB.B	D1,$4000	* not sure what this does

	    SUB.B	D1,$40010000	* not sure what this does



	    SUB.B	D1, D0		* sub D1 to D0


	    SUB.B	(A0),D0		* sub D0 to A0 indirect

	    SUB.B	(A0)+,D0	* sub post-increment

	    SUB.B	-(A1),D0	* sub pre-increment


	    SUB.B	data2,D0	* i think this passes? word

	    SUB.B	data3,D0	* longword?

* sub word

	    SUB.W	#data1,D0	* immediate data to D0 byte

	    SUB.W	#$1021,D0	* immediate data to D0 word

	    SUB.W	D1,A0		* sub A0 to D1

	    SUB.W	D1,(A0)+	* sub post-increment to D1

	    SUB.W	D1,-(A1)	* sub pre-increment to D1

	    SUB.W	D1,$4000	* not sure what this does

	    SUB.W	D1,$40010000	* not sure what this does



	    SUB.W	D1, D0		* sub D1 to D0

	    SUB.W	A0,D0		* sub D0 to A0 direct

	    SUB.W	(A0),D0		* sub D0 to A0 indirect

	    SUB.W	(A0)+,D0	* sub post-increment

	    SUB.W	-(A1),D0	* sub pre-increment


	    SUB.W	data2,D0	* i think this passes? word

	    SUB.W	data3,D0	* longword?


* sub longword


	    SUB.L	#data1,D0	* immediate data to D0 byte

	    SUB.L	#$1021,D0	* immediate data to D0 word

	    SUB.L	#$AAAA5555,D0	* immediate data to D0 longword

	    SUB.L	D1,A0		* sub A0 to D1

	    SUB.L	D1,(A0)+	* sub post-increment to D1

	    SUB.L	D1,-(A1)	* sub pre-increment to D1

	    SUB.L	D1,$4000	* not sure what this does

	    SUB.L	D1,$40010000	* not sure what this does



	    SUB.L	D1, D0		* sub D1 to D0

	    SUB.L	A0,D0		* sub D0 to A0 direct

	    SUB.L	(A0),D0		* sub D0 to A0 indirect

	    SUB.L	(A0)+,D0	* sub post-increment

	    SUB.L	-(A1),D0	* sub pre-increment


	    SUB.L	data2,D0	* i think this passes? word

    	SUB.L	data3,D0	* longword?


******************************* SUBA **************************************
* SUBA WORD

	    SUBA.W D1,A0		* Data register to address register

	    SUBA.W A0,A0		* address register to data register direct

	    SUBA.W (A0),A0		* address register to data register indirect

	    SUBA.W (A0)+,A0		* post-increment

	    SUBA.W -(A1),A0		* pre-increment

	    SUBA.W addr1,A0		* word address?

	    SUBA.W #addr1,A0	* immediate address?

	    SUBA.W $4000,A0		* random address

	    SUBA.W data2,A0		* random data word

	    SUBA.W #data2,A0	* immediate data word

	    SUBA.W #$AAAA,A0	* immediate data word



* SUBA LONGWORD

	    SUBA.L D1,A0		* Data register to data register

	    SUBA.L A0,A0		* address register to data register direct

	    SUBA.L (A0),A0		* address register to data register indirect

	    SUBA.L (A0)+,A0		* post-increment

	    SUBA.L -(A1),A0		* pre-increment

	    SUBA.L addr1,A0		* word address?

	    SUBA.L #addr1,A0	* immediate address?

	    SUBA.L $4000,A0		* random address

    	SUBA.L data2,A0		* random data word

    	SUBA.L data3,A0		* random data longword

    	SUBA.L #data2,A0	* immediate data word

	    SUBA.L #data3,A0	* immediate data longword

	    SUBA.L #$AAAA,A0	* immediate data word

	    SUBA.L #$AAAA5555,A0	* immediate data longword


******************************* SUBI **************************************
*SUBI byte

    	SUBI.B #$AA,D0		* immediate data to D0

	    SUBI.B #$AA,(A0)	* address register indirect

	    SUBI.B #$AA,(A0)+	* address register post-increment

	    SUBI.B #$AA,-(A1)	* address register pre-increment

	    SUBI.B #$AA,$4000	* destination word address

	    SUBI.B #$AA,$00004000	* destination longword address


*SUBI word

	    SUBI.W #$AA55,D0	* data register

	    SUBI.W #$AA55,(A0)	* address register indirect

	    SUBI.W #$AA55,(A0)+	* address register post-increment

	    SUBI.W #$AA55,-(A1)	* address register pre-increment

	    SUBI.W #$AA55,$4000	* destination word 

	    SUBI.W #$AA55,$00004000	* destination longword


*SUBI longword

	    SUBI.L #$AA55FF,D0	* data register

	    SUBI.L #$AA55FF,(A0)	* address register indirect

	    SUBI.L #$AA55FF,(A0)+	* address register post-increment

	    SUBI.L #$AA55FF,-(A1)	* address register pre-increment

	    SUBI.L #$AA55FF,$4000	* destination word

	    SUBI.L #$AA55FF,$00004000   * destination longword


******************************* AND **************************************
*AND byte

	    AND.B D1,D0		* data register for source and destination

	    AND.B (A0),D0		* souce address register indirect

	    AND.B (A0)+,D0		* source address register post-increment

	    AND.B -(A1),D0		* source address register pre-decrement

	    AND.B $4000,D0		* source word address

	    AND.B $00004000,D0	* source longword address

	    AND.B #$AE,D0		* immediate data


	    AND.B D1,(A0)		* dest address register indirect

	    AND.B D1,(A0)+		* dest address register post-increment

	    AND.B D1,-(A1)		* dest address register pre-decrement

	    AND.B D1,$4000		* dest word address

	    AND.B D1,$00004000	* dest longword address


*AND word

	    AND.W D1,D0		* data register for source and destination

	    AND.W (A0),D0		* souce address register indirect

	    AND.W (A0)+,D0		* source address register post-increment

	    AND.W -(A1),D0		* source address register pre-decrement

	    AND.W $4000,D0		* source word address

	    AND.W $00004000,D0	* source longword address

	    AND.W #$AE,D0		* immediate data byte

	    AND.W #$AAAA,D0		* immediate data word


	    AND.W D1,(A0)		* dest address register indirect

	    AND.W D1,(A0)+		* dest address register post-increment

	    AND.W D1,-(A1)		* dest address register pre-decrement

	    AND.W D1,$4000		* dest word address

	    AND.W D1,$00004000	* dest longword address


*AND longword

    	AND.L D1,D0		* data register for source and destination

	    AND.L (A0),D0		* souce address register indirect

	    AND.L (A0)+,D0		* source address register post-increment

	    AND.L -(A1),D0		* source address register pre-decrement

	    AND.L $4000,D0		* source word address

	    AND.L $00004000,D0	* source longword address

	    AND.L #$AE,D0		* immediate data byte

	    AND.L #$AAAA,D0		* immediate data word

	    AND.L #$AAAAEEEE,D0	* immediate data longword


	    AND.L D1,(A0)		* dest address register indirect

	    AND.L D1,(A0)+		* dest address register post-increment

	    AND.L D1,-(A1)		* dest address register pre-decrement

	    AND.L D1,$4000		* dest word address

	    AND.L D1,$00004000	* dest longword address


******************************* ORI ***************************************
*ORI byte

	    ORI.B #$EA,D0		* data register

	    ORI.B #$EA,(A1)		* address register indirect

	    ORI.B #$EA,(A0)+	* post-increment

	    ORI.B #$EA,-(A1)	* pre-decrement

	    ORI.B #$EA,$4000	* address word

	    ORI.B #$EA,$00004000	* address longword

*ORI word

	    ORI.W #$EAEA,D0		* data register

	    ORI.W #$EAEA,(A1)	* address register indirect

	    ORI.W #$EAEA,(A0)+	* post-increment

	    ORI.W #$EAEA,-(A1)	* pre-decrement

	    ORI.W #$EAEA,$4000	* address word

	    ORI.W #$EAEA,$00004000	* address longword

*ORI longword

	    ORI.L #$EAEACCCC,D0		* data register

	    ORI.L #$EAEACCCC,(A1)		* address register indirect

	    ORI.L #$EAEACCCC,(A0)+		* post-increment

	    ORI.L #$EAEACCCC,-(A1)		* pre-decrement

	    ORI.L #$EAEACCCC,$4000		* address word

	    ORI.L #$EAEACCCC,$00004000	* address longword


******************************* NOT ***************************************
* NOT byte

	    NOT.B D0	* data register

	    NOT.B (A0)	* address register indirect

	    NOT.B (A0)+	* address register post-increment

	    NOT.B -(A1)	* address register pre-increment

	    NOT.B $4000	* address word

	    NOT.B $00004000	*address longword


* NOT word

	    NOT.W D0	* data register

	    NOT.W (A0)	* address register indirect

	    NOT.W (A0)+	* address register post-increment

	    NOT.W -(A1)	* address register pre-increment

	    NOT.W $4000	* address word

	    NOT.W $00004000	*address longword


* NOT longword

	    NOT.L D0	* data register

	    NOT.L (A0)	* address register indirect

	    NOT.L (A0)+	* address register post-increment

	    NOT.L -(A1)	* address register pre-increment

	    NOT.L $4000	* address word

	    NOT.L $00004000	*address longword

******************************* ROL ***************************************
*ROL byte

    	ROL.B D0,D1
	
	    ROL.B #1,D0
	
*ROL word
        ROL.W D0,D1
    
        ROL.W #1,D0

*ROL longword
        ROL.L D0,D1
    
        ROL.L #1,D0
    

*ROR byte
        ROR.B D0,D1
	
	    ROR.B #1,D0
	
*ROR word
        ROR.W D0,D1
    
        ROR.W #1,D0

*ROR longword
        ROR.L D0,D1
    
        ROR.L #1,D0

 ****************************** Bcc ***************************************
 
LOOP    
        BEQ   LOOP
        BNE   LOOP
        BLT   LOOP
        BHI   LOOP

 ****************************** END ***************************************

*Stop here. The next instruction shows how a label is used


        END   START            * This pseudo op-code tells the assembler 

                                 * where the program source code ends and

                                 * where to load the program in memory. 

* End of the program



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
