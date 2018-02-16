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
		BL    LEDSETUP
		MOV   R0, #6
		BL 	  fib
		BL    MorseDigit
		B     forever

fib		
	; Your code goes here!
				CMP R0, #0			;if input <= 0, return 0
				BMI negative
				BEQ zero
				CMP R0, #1			;if input is 1, return 1
				BEQ one
				PUSH {R4, R5, LR}	;else
				MOV R4, R0			;store value of n
				SUB R0, R0, #1		;compute n-1
				BL fib				;compute fib(n-1)
				MOV R5, R0
				SUB R0, R4, #2		;compute n-2
				BL fib				;compute fib(n-2)
				ADD R0, R0, R5		;fib(n-2) + fib(n-1)
				POP {R4, R5, LR}
				BX LR

zero
				MOV R0, #0			;return 0
				BX LR

one
				MOV R0, #1			;return 1
				BX LR

negative
				MOV R0, #0			;return 0
				BX LR

dotdelay		;defines the duration of time to leave the LED on for a dot
				PUSH {R4, LR}
				MOV R4, #twentytwo
				BL loop
				POP {R4, LR}
				BX LR

loop			;repeatedly decrement counter until it reaches zero to create delay
				SUBS R4, #1
				BNE loop
				BX LR
				
dashdelay		;defines the duration of time to leave the LED on for a dash
				PUSH {LR}
				BL dotdelay		;three times as long as dotdelay
				BL dotdelay
				BL dotdelay
				POP {LR}
				BX LR

dot				;calling this generates a dot on the LED
				PUSH {LR}
				BL LEDON
				BL dotdelay
				BL LEDOFF
				BL dotdelay
				POP {LR}
				BX LR

dash			;calling this generates a dash on the LED
				PUSH {LR}
				BL LEDON
				BL dashdelay
				BL LEDOFF
				BL dotdelay
				POP {LR}
				BX LR

zero_morse		;dash dash dash dash dash
				PUSH {LR}
				BL dash
				BL dash
				BL dash
				BL dash
				BL dash
				POP {LR}
				BX LR

one_morse		;dot dash dash dash dash
				PUSH{LR}
				BL dot
				BL dash
				BL dash
				BL dash
				BL dash
				POP {LR}
				BX LR
				
two_morse		;dot dot dash dash dash
				PUSH {LR}
				BL dot
				BL dot
				BL dash
				BL dash
				BL dash
				POP {LR}
				BX LR

three_morse		;dot dot dot dash dash
				PUSH {LR}
				BL dot
				BL dot
				BL dot
				BL dash
				BL dash
				POP {LR}
				BX LR
				
four_morse		;dot dot dot dot dash
				PUSH {LR}
				BL dot
				BL dot
				BL dot
				BL dot
				BL dash
				POP {LR}
				BX LR

five_morse		;dot dot dot dot dot
				PUSH {LR}
				BL dot
				BL dot
				BL dot 
				BL dot
				BL dot
				POP {LR}
				BX LR

six_morse		;dash dot dot dot dot
				PUSH {LR}
				BL dash
				BL dot
				BL dot
				BL dot
				BL dot
				POP {LR}
				BX LR

seven_morse		;dash dash dot dot dot
				PUSH {LR} 
				BL dash
				BL dash
				BL dot
				BL dot
				BL dot
				POP {LR}
				BX LR
				
eight_morse		;dash dash dash dot dot
				PUSH {LR}
				BL dash
				BL dash
				BL dash
				BL dot
				BL dot
				POP {LR}
				BX LR

nine_morse		;dash dash dash dash dot
				PUSH {LR}
				BL dash
				BL dash
				BL dash
				BL dash
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
