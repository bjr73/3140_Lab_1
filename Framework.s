		AREA Myprog, CODE, READONLY
		ENTRY
		EXPORT __main
			
;don't change these addresses!
PCR22 	  EQU 0x4004A058 ;PORTB_PCR22  address
SCGC5 	  EQU 0x40048038 ;SIM_SCGC5    address
PDDR 	  EQU 0x400FF054 ;GPIOB_PDDR   address
PCOR 	  EQU 0x400FF048 ;GPIOB_PCOR   address
PSOR      EQU 0x400FF044 ;GPIOB_PSOR   address

ten		  EQU 0x00000400 ; 1 << 10
eight     EQU 0x00000100 ; 1 << 8
twentytwo EQU 0x00400000 ; 1 << 22

__main
	; Your code goes here!
		MOV   R0, #7
		MOV   R3, #7
		MOV   R7, #19
		MOV   R1, #0xbeef
		BL    LEDSETUP
		BL    MorseDigit
		B     forever

fib		
	; Your code goes here!

; Call this function first to set up the LED
LEDSETUP
				PUSH  {R4, R5} ; To preserve R4 and R5
				LDR   R4, =ten ; Load the value 1 << 10
				LDR		R5, =SCGC5
				STR		R4, [R5]
				
				LDR   R4, =eight
				LDR   R5, =PCR22
				STR   R4, [R5]
				
				LDR   R4, =twentytwo
				LDR   R5, =PDDR
				STR   R4, [R5]
				POP   {R4, R5}
				BX    LR

dotdelay
				MOV R2, #twentytwo
				PUSH {LR}
				BL loop
				POP {LR}
				BX LR
				
dashdelay
				PUSH {LR}
				BL dotdelay
				BL dotdelay
				BL dotdelay
				POP {LR}
				BX LR


				
loop
				SUBS R2, #1
				BNE loop
				BX LR

dot
				PUSH {LR}
				BL LEDON
				BL dotdelay
				BL LEDOFF
				BL dotdelay
				POP {LR}
				BX LR

dash
				PUSH {LR}
				BL LEDON
				BL dashdelay
				BL LEDOFF
				BL dotdelay
				POP {LR}
				BX LR
				
one_morse 
				;dot dash dash dash dash
				PUSH{LR}
				BL dot
				BL dash
				BL dash
				BL dash
				BL dash
				POP {LR}
				BX LR 
					
three_morse
				; dot dot dot dash dash
				PUSH {LR}
				BL dot
				BL dot
				BL dot
				BL dash
				BL dash
				POP {LR}
				BX LR

five_morse 
				;dot dot dot dot dot
				PUSH {LR}
				BL dot
				BL dot
				BL dot 
				BL dot
				BL dot
				POP {LR}
				BX LR 

seven_morse
				;dash dash dot dot dot
				PUSH {LR} 
				BL dash
				BL dash
				BL dot
				BL dot
				BL dot
				POP {LR}
				BX LR 
				
nine_morse
				;dash dash dash dash dot
				PUSH {LR}
				BL dash
				BL dash
				BL dash
				BL dash
				BL dot
				POP {LR}
				BX LR 

zero_morse
				PUSH {LR}
				BL dash
				BL dash
				BL dash
				BL dash
				BL dash
				POP {LR}
				BX LR
				
two_morse
				PUSH {LR}
				BL dot
				BL dot
				BL dash
				BL dash
				BL dash
				POP {LR}
				BX LR
				
four_morse
				PUSH {LR}
				BL dot
				BL dot
				BL dot
				BL dot
				BL dash
				POP {LR}
				BX LR
six_morse
				PUSH {LR}
				BL dash
				BL dot
				BL dot
				BL dot
				BL dot
				POP {LR}
				BX LR
				
eight_morse
				PUSH {LR}
				BL dash
				BL dash
				BL dash
				BL dot
				BL dot
				POP {LR}
				BX LR

MorseDigit
				PUSH {LR}
				CMP R0, #0
				BEQ zero_morse
				CMP R0, #1
				BEQ one_morse
				CMP R0, #2
				BEQ two_morse
				CMP R0, #3
				BEQ three_morse
				CMP R0, #4
				BEQ four_morse
				CMP R0, #5
				BEQ five_morse
				CMP R0, #6
				BEQ six_morse
				CMP R0, #7
				BEQ seven_morse
				CMP R0, #8
				BEQ eight_morse
				CMP R0, #9
				BEQ nine_morse
				POP {LR}
				BX LR

; The functions below are for you to use freely      
LEDON				
				PUSH  {R4, R5}
				LDR   R4, =twentytwo
				LDR   R5, =PCOR
				STR   R4, [R5]
				POP   {R4, R5}
				BX    LR
LEDOFF				
				PUSH  {R4, R5}
				LDR   R4, =twentytwo
				LDR   R5, =PSOR
				STR   R4, [R5]
				POP   {R4, R5}
				BX    LR
				
forever
			B		forever						; wait here forever	
			END
