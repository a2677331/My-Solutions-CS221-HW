comment |/Users/zhongjian/tasm/tasm/CS221/l2/PRNBIN.ASM
***************************************************************
Programmer: 
Date      :  January 22, 2020
Course    :  CS221 Machine Organization & Assembly Language Programming
Project   :  ?? - Input ten integers from the user, echo print each,
		  and print out the maximum value.
Assembler :  Borland TASM 3.0
File Name :  MaxInput.asm

Input   :  Ten integers.
Output  :  Echo of the input numbers and the maximum input number.
Input Files : None
Output Files: None


PROCEDURES CALLED:
    External procedures called:
	FROM iofar.lib: PutCrLf, GetDec, PutDec
    Internal procedures called:
	Greet

|
INCLUDELIB iofar

;****** BEGIN MAIN PROGRAM ************************************
	DOSSEG
	.186
	.model large
	.stack 200h

;****** MAIN PROGRAM DATA SEGMENT *****************************
	.data
Prompt1	 db  'Enter integer #$'
Prompt2  db  ': $'
N	 dw  ?
Max	 dw  ?
Count	 dw  1
Limit	 dw  10
MsgEcho  db  'The input was:$'
MsgMax	 db  'The maximum input integer was: $'


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
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
   ; Print the Count value as part of prompt
	mov	ax,Count     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
   ; Finish the prompt string
	mov	dx,OFFSET Prompt2  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string

; Input an integer from the user keyboard and assign it to N
	call	GetDec       ; integer from keyboard returned in ax
	mov	N,ax         ; store input value in memory location

; Initialize Max with the first input number
	mov	Max,ax
; Increment counter
	inc	Count

; Print to verify the number was correctly input
  ; Print message
	mov	dx,OFFSET MsgEcho  ; point to the output mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
  ; Print the input integer
	mov	ax,N         ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	call    PutCrLf
	call    PutCrLf

; Repeatedly prompt the user and input the an integer and print the
; integer, while the number of input integers is less than the limit.
; Also, find the maximum input number as they are input.

WHILE01:	;  Count < Limit
	mov	ax, Count       ; assign Count to ax
	cmp	ax, Limit
	jnle	ENDWHL01
DO01:           ; Input integer, print it, compare to Max and update
		; Max if a greater number has been encountered
   ; Print prompt message to the user
	mov	dx,OFFSET Prompt1  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
   ; Print the Count value as part of prompt
	mov	ax,Count     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
   ; Finish the prompt string
	mov	dx,OFFSET Prompt2  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string

  ; Input an integer from the user keyboard and assign it to N
	call	GetDec       ; integer from keyboard returned in ax
	mov	N,ax         ; store input value in memory location

  ; Test whether the input number is greater than the current maximum
  ; IF01 N > Max
	cmp	ax, Max
	jle 	ENDIF01
  ; THEN assign N to Max
	mov	Max, ax
  ENDIF01:
  ; Print to verify that the number was input correctly from
  ; keyboard and assigned to N correctly
	mov	dx,OFFSET MsgEcho  ; point to the output mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string

  ; Print the input integer
	mov	ax,N         ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	call    PutCrLf
	call    PutCrLf

  ; Increment Count and repeat the loop
	inc	Count
	jmp	WHILE01
; End of while loop
ENDWHL01:

; Print the maximum integer
  ; Print explanatory message first
	mov	dx,OFFSET MsgMax  ; point to the output mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
  ; Print the maximum integer
	mov	ax,Max         ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
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
Msgg1	 db  'Program:    Find maximum number in the input list $'
Msgg2	 db  'Programmer: XXXXXXXXXXXX $'
Msgg3	 db  'Date:       January 22, 2020 $'


;****** SUBROUTINE CODE SEGMENT ********************************
	.code
Greet	PROC    near

; Initialize ds register to hold data segment address
	mov	ax,@data
	mov	ds,ax

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

; Restore registers from stack
	popf
	popa

; Return to caller module
	ret
Greet	ENDP
	end	ProgramStart
