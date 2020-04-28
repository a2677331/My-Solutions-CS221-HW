comment |
***************************************************************
Programmer: 
Date      :  April 27, 2020
Course    :  CS221 Machine Organization & Assembly Language Programming
Project   :  Project 2 - Solution for the Tower of Hanoi
Assembler :  Borland TASM 3.0
File Name :  proj2.asm

Input   :  Number of disks, starting pole position and ending pole position.
Output  :  Solution for the Tower of Hanoi.
Input Files : None
Output Files: None


PROCEDURES CALLED:
    External procedures called:
	FROM iofar.lib: PutCrLf, GetDec, PutDec
    Internal procedures called:
	Greet
	Hanoi
|
INCLUDELIB iofar

;****** BEGIN MAIN PROGRAM ************************************
	DOSSEG
	.186
	.model large
	.stack 200h

;****** MAIN PROGRAM DATA SEGMENT *****************************
	.data
Prompt1	 db  'Enter the number of disks (from 3 to 7 only) #$'
Prompt2	 db  'Enter the starting pole position (from 1 to 3 only) #$'
Prompt3	 db  'Enter the ending pole position (from 1 to 3 only) #$'
Prompt4  db  ': $'
Disks	 dw  ?		
S	     dw	 ? 
E		 dw  ?
MsgEcho  db  'The input was:$'
MsgCheck  db  'The input was invalid, please re-enter an integer from 1 to 3: $'
MsgTower db  'Solution for the Tower of Hanoi: $'


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
; Finish the prompt string
	mov	dx,OFFSET Prompt4  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string

; Input an integer from the user keyboard and assign it to N
	call	GetDec       ; integer from keyboard returned in ax
	mov	Disks,ax         ; store input value in memory location


ENDWHILE1:

  ; Print message
	mov	dx,OFFSET MsgEcho  ; point to the output mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
  ; Print the input integer
	mov	ax,Disks        ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	call    PutCrLf		;new line character

	
; Print prompt message to the user
	mov	dx,OFFSET Prompt2  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
; Finish the prompt string
	mov	dx,OFFSET Prompt4  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string

; Input an integer from the user keyboard and assign it to N
	call	GetDec       ; integer from keyboard returned in ax
	mov	S,ax         ; store input value in memory location
; Print to verify the number was correctly input
  ; Print message
	mov	dx,OFFSET MsgEcho  ; point to the output mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
; Print the input integer
	mov	ax,S        ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	call    PutCrLf		;new line character


; Print prompt message to the user
	mov	dx,OFFSET Prompt3  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
; Finish the prompt string
	mov	dx,OFFSET Prompt4  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string

; Input an integer from the user keyboard and assign it to N
	call	GetDec       ; integer from keyboard returned in ax
	mov	E,ax         ; store input value in memory location

  ; Print message
	mov	dx,OFFSET MsgEcho  ; point to the output mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
  ; Print the input integer
	mov	ax,E       ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	call    PutCrLf		;new line character


;	Print message
	mov dx,OFFSET MsgTower  ;	point to the output message
	mov ah,9	;	DOS print string fuction
	int 21h	;	print string
	call PutCrLf 	;	new line character
	
;STARTING THE TOWER
	sub ax,ax
	sub bx,bx
	sub cx,cx
	push Disks
	push S
	push E
	call Hanoi

; Exit to the operating system
	mov	ah,4ch	     ; DOS terminate program fn #
	int	21h
ProgramStart	ENDP
comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : Hanoi
  PURPOSE :  To solve and output the solution for the Tower of Hanoi
  INPUT PARAMETERS : The number of disks, the starting pole position and ending pole position
  OUTPUT PARAMETERS or RETURN VALUE: Solution for The Tower of Hanoi
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :None
  PROCEDURES CALLED :
	FROM iofar.lib: PutCrLf
  CALLED FROM : main program
|
;****** SUBROUTINE DATA SEGMENT ********************************
.data
	string1	 db  '.	Move disk $'
	string2	 db  'from pole $'
	string3	 db  'to pole $'
	count	 dw   0
;****** SUBROUTINE CODE SEGMENT ********************************
.code
Hanoi PROC		near

;	Save registers on the stack
    pusha
	pushf
;	Set up bp register to point to parameters
    mov  bp,sp
	
;	If (Disks == 1)
	mov cx, [bp+24]  ;cx = Disks
	cmp cx,1		;(Disks == 1)
	jne IF01
	
;	PRINTING:#. Move disk Disks from pole S to pole E
	inc count
	mov ax,count
	call PutDec
	
	mov	dx,OFFSET string1 ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
	
	mov	ax,[bp+24]     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	
	mov	dx,OFFSET string2 ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
	
	mov	ax,[bp+22]     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	
	mov	dx,OFFSET string3 ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
	
	mov	ax,[bp+20]     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	call PutCrLf
	jmp ENDIF01

; 6 - s - e, [bp+20] = E, [bp+22] = S,       D,S,E
IF01:
	dec cx		; cx = n - 1

	mov bx,6	; bx = 6
	mov ax,[bp+20]	;ax = E
	sub bx,ax		;bx = 6 - E
	mov ax,[bp+22]	;ax = S
	sub bx,ax		;bx = 6 - E - S
	
; 	FISRT RECURSIVE CALL: Hanoi(Disks - 1, S, 6 - S - E)
	push cx		;push Disks - 1
	push ax     ;push S
	push bx		;push 6 - E - S
	call Hanoi
	
;	PRINTING:#. Move disk Disks from pole S to pole E
	inc count
	mov ax,count
	call PutDec
	
	mov	dx,OFFSET string1 ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
	
	mov	ax,[bp+24]     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	
	mov	dx,OFFSET string2 ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
	
	mov	ax,[bp+22]     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	
	mov	dx,OFFSET string3 ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
	
	mov	ax,[bp+20]     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
	call PutCrLf
	
;	SECOND RECURSIVE CALL: Hanoi(Disks - 1, 6 - S - E, E)
	push cx		;push Disks - 1
	push bx		;push 6 - S - E
	push [bp+20]	;push E
	call Hanoi

ENDIF01:
	
	
; restore registers and return having passed the result back
	popf
	popa
	ret 6

Hanoi  ENDP
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
Msgg1	 db  'Program: The Tower of Hanoi $'
Msgg2	 db  'Programmer: Ngoc Anh Thy Ly $'
Msgg3	 db  'Date:       April 27, 2020 $'


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
end ProgramStart