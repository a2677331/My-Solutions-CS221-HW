comment |
***************************************************************
Programmer:
Date      :  February 12, 2020
Course    :  CS221 Machine Organization & Assembly Language Programming
Project   :  ?? - Input two integers from the user, echo print the integers,
		  call a procedure to swap the values,
		  print out the two integers after swapping their values.
Assembler :  Borland TASM 3.0
File Name :  SwapProc.asm

Input   :  Two integers.
Output  :  The swapped values of the two integers.
Input  Files: None
Output Files: None

PROCEDURES CALLED:
    External procedures called:
	FROM iofar.lib: PutCrLf, GetDec, PutDec
    Internal procedures called:
	Greet, Swap
|

;****** BEGIN MAIN PROGRAM ************************************
	DOSSEG
	.186
	.model large
	.stack 200h

;****** MAIN PROGRAM DATA SEGMENT *****************************
	 .data
Prompt1	 db  'Enter an integer: $'  ; "$" is a string terminator, if without it, string never ends.
Prompt2	 db  'Enter another integer: $'
Numb1	 dw  ?
Numb2	 dw  ?
Result	 dw  ?
MsgEcho	 db  'The two input integers are: $'
MsgOut   db  'The two integers after swapping: $'
MsgEnd	 db  'Exiting program $'


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

; Print input prompt message to the user
	mov	dx,OFFSET Prompt1   ; point to the Prompt mesg (⚠️ the data's address you need to print)
	mov	ah,9	            ; DOS print string function # (⚠️ For Printng String Command)
	int	21h	                ; print string  (⚠️ interrupt the processor, and EXECUTE from mov ah,09 to int 21h)
; Input an integer from the user keyboard and assign it to memory loc.
	call	GetDec       ; integer from keyboard returned in ax
	mov	Numb1,ax     ; store input value in memory location

; Print input prompt message to the user
	mov	dx,OFFSET Prompt2  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
; Input an integer from the user keyboard and assign it to memory loc.
	call	GetDec       ; integer from keyboard returned in ax
	mov	Numb2,ax     ; store input value in memory location

; Print to verify the numbers were correctly read from user & stored
  ; Print message
	mov	dx,OFFSET MsgEcho  ; point to the output mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
  ; Print the value of Numb1
	mov	ax,Numb1     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
  ; Print the value of Numb2
	mov	ax,Numb2     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	call    PutCrLf
	call    PutCrLf

; Push parameters on the system stack and
; call procedure to swap the values of the two integers
	push	OFFSET Numb1  ; pass by reference parameter
	push	OFFSET Numb2  ; pass by reference parameter
	call	Swap          ; call Swap(Numb1, Numb2)  ⚠️ call swap！！！！！

; Print the integers after swapping their values
  ; Print message
	mov	dx,OFFSET MsgOut  ; point to the output message
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
  ; Print the value of Numb1
	mov	ax,Numb1     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
  ; Print the value of Numb2
	mov	ax,Numb2     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	call    PutCrLf

; Print ending message
	call    PutCrLf
	mov	dx,OFFSET MsgEnd  ; point to the output mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
	call    PutCrLf

; Exit to the operating system
	mov	ah,4ch	     ; DOS terminate program fn #
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
Msgg1	 db  'Program:  Demo Swap Procedure Call with Parameters $'
Msgg2	 db  'Programmer: XXXXXXXXXXXX $'
Msgg3	 db  'Date:   February 12, 2020 $'


;****** SUBROUTINE CODE SEGMENT ********************************
	.code
Greet	PROC    near

; Save registers on the stack
	pusha
	pushf

; Print name of program
	mov	dx,OFFSET Msgg1 ; set pointer to 1st greeting message
	mov	ah,9	        ; DOS print string function #
	int	21h	        ; print string
	call	PutCrLf

; Print name of programmer
	mov	dx,OFFSET Msgg2 ; set pointer to 2nd greeting message
	mov	ah,9	        ; DOS print string function #
	int	21h	        ; print string
	call	PutCrLf

; Print date
	mov	dx,OFFSET Msgg3 ; set pointer to 3rd greeting message
	mov	ah,9	        ; DOS print string function #
	int	21h	        ; print string
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
  PROCEDURE NAME : Swap
  PURPOSE :  To swap the values of two parameters passed by reference
  INPUT PARAMETERS : 	Integer N1, pass by reference
			Integer N2, pass by reference
  OUTPUT PARAMETERS or RETURN VALUE:  Integer N1, Integer N2
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :None
  PROCEDURES CALLED : None
  CALLED FROM : main program
|

;****** SUBROUTINE CODE SEGMENT ********************************
	.code
Swap  PROC   near

; Save registers on the stack
	pusha
	pushf
	mov	bp,sp

; Copy the value of second parameter N2 into dx register
	mov	bx,[bp+20]    ; copy address of N2 into bx
	mov	dx,[bx]       ; copy contents of N2 into dx

; Copy the value of first parameter N1 into ax register
	mov	bx,[bp+22]    ; copy address of N1 into bx
	mov	ax,[bx]       ; copy contents of N1 into ax

; Assign the original value of the second parameter into loc N1
	mov	[bx],dx

; Assign the original value of the first parameter into loc N2
	mov	bx,[bp+20]
	mov	[bx],ax

; Restore registers from stack
	popf
	popa

; Return to caller module
	ret	4
Swap	ENDP
	end	ProgramStart
