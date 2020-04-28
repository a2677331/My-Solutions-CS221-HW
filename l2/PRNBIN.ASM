comment |
***************************************************************
Programmer: 
Date      :  February 5, 2020
Course    :  CS221 Machine Organization & Assembly Language Programming
Project   :  ?? - Input an integer from the user, echo print the   
		  integer and print out the binary representation.

Assembler :  Borland TASM 3.0
File Name :  PrnBin.asm

Input   :  An integer.
Output  :  The binary number system version of the input number.

Input Files : None
Output Files: None


PROCEDURES CALLED:
    External procedures called:
	FROM iofar.lib: PutCrLf, GetDec, PutDec
    Internal procedures called:
	Greet, PrnBit

|
;****** BEGIN MAIN PROGRAM ************************************
	DOSSEG
	.186
	.model large
	.stack 200h

;****** MAIN PROGRAM DATA SEGMENT *****************************
	 .data
Prompt1	 db  'Enter an integer: $'
N	     dw  ?
Count	 dw  0
Limit	 dw  16
Mask1	 dw  1
MsgEcho  db  'The input number is: $'
MsgOut   db  'The binary version of the input number is: $'
MsgEnd   db  'Exiting program $'


;****** MAIN PROGRAM CODE SEGMENT *****************************
	.code
	extrn	PutStr: PROC, PutCrLf: PROC
	extrn	GetDec: PROC, PutDec: PROC

ProgramStart   PROC
; Initialize ds register to hold data segment address
	mov	ax,@data
	mov	ds,ax

; Call procedure Greet to print introductory messages to the user
	call	Greet        ; call subroutine to print greeting

; Print prompt message to the user
	mov	dx,OFFSET Prompt1  ; point to the Prompt mesg
	mov	ah,9	           ; DOS print string function #
	int	21h	               ; print string

; Input an integer from the user keyboard and assign it to N
	call	GetDec       ; integer from keyboard returned in ax
	mov	N,ax             ; store input value in memory location


; Print to verify the number was correctly input
  ; Print message
	mov	dx,OFFSET MsgEcho  ; point to the output mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	         ; print string

  ; Print the input integer
	mov	ax,N             ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	call    PutCrLf
	call    PutCrLf

; Print result message
	mov	dx,OFFSET MsgOut  ; point to the output message
	mov	ah,9	          ; DOS print string function #
	int	21h	              ; print string
	call	PutCrLf

; While the Count is less than the number of bits in the number,
; repeatedly get the number from location N, rotate left one bit 
; extract the rightmost bit,print the one bit,& increment Count

WHILE01:	      ;  Count < Limit
	mov  ax, Count
	cmp  ax, Limit
	jnl  ENDWHL01
DO01:
  ; Copy N into the ax register, rotate left to get the next bit
  ; positioned at right end of word, and save
	mov	ax,N         ; fetch N
	rol     ax,1         ; rotate left
	mov     N,ax         ; save in location N

   ; Extract one bit into ax
	and     ax,Mask1

   ; Call procedure PrintBit to print one bit of the integer,
   ; passing the parameter in the ax register
	call	PrnBit         ; print the one bit

   ; Increment Count and repeat the loop
	inc	Count
	jmp	WHILE01
; End of while loop
ENDWHL01:

; Print ending message
	call    PutCrLf
	call    PutCrLf
	mov	dx,OFFSET MsgEnd  ; point to the output mesg
	mov	ah,9	          ; DOS print string function #
	int	21h	              ; print string
	call    PutCrLf
	call    PutCrLf

; Exit to the operating system
	mov	ah,4ch	          ; DOS terminate program fn #
	int	21h
ProgramStart	ENDP


comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : Greet
  PURPOSE :  To print initial greeting messages to the user
  INPUT PARAMETERS : None
  OUTPUT PARAMETERS or RETURN VALUE:  None
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :None
  PROCEDURES CALLED :
	FROM iofar.lib: PutCrLf
  CALLED FROM : main program
|
;****** SUBROUTINE DATA SEGMENT ********************************
	.data
Msgg1	 db  'Program:  Binary number version display $'
Msgg2	 db  'Programmer: XXXXXXXXXXXX $'
Msgg3	 db  'Date: February 5, 2020 $'


;****** SUBROUTINE CODE SEGMENT ********************************
	.code
Greet	PROC    near

; Save registers on the stack
	pusha
	pushf

; Print name of program
	mov	dx,OFFSET Msgg1 ; set pointer to 1st greeting message
	mov	ah,9	          ; DOS print string function #
	int	21h	          ; print string
	call	PutCrLf

; Print name of programmer
	mov	dx,OFFSET Msgg2    ; set pointer to 2nd greeting message
	mov	ah,9	           ; DOS print string function #
	int	21h	               ; print string
	call	PutCrLf

; Print date
	mov	dx,OFFSET Msgg3    ; set pointer to 3rd greeting message
	mov	ah,9	           ; DOS print string function #
	int	21h	               ; print string
	call	PutCrLf
	call	PutCrLf

; Restore registers from stack
	popf
	popa

; Return to caller module
	ret
Greet	ENDP


comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : PrnBit
  PURPOSE :  To print one bit to the user screen
  INPUT PARAMETERS : A bit in the ax register
  OUTPUT PARAMETERS or RETURN VALUE:  None
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :None
  PROCEDURES CALLED :
	FROM iofar.lib: PutCrLf
  CALLED FROM : main program
|
;****** SUBROUTINE DATA SEGMENT ********************************
	 .data
Msg0	 db  '0$'
Msg1	 db  '1$'

;****** SUBROUTINE CODE SEGMENT ********************************
	.code
PrnBit  PROC   near

; Save registers on the stack
	pusha
	pushf

; IF01 eax = 0
	cmp	ax,0
	jne	ELSE01
; THEN01  Print a zero
	mov	dx,OFFSET Msg0  ; set pointer to output string
	mov	ah,9	        ; DOS print string function #
	int	21h	            ; print string
	jmp	ENDIF01
ELSE01: ; Print a one
	mov	dx,OFFSET Msg1  ; set pointer to output string
	mov	ah,9	        ; DOS print string function #
	int	21h	            ; print string
ENDIF01:
; Restore registers from stack
	popf
	popa

; Return to caller module
	ret
PrnBit  ENDP
	end	ProgramStart
