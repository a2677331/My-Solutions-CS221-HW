comment |
***************************************************************
Programmer:
Date      :  Mar 20th, 2020
Course    :  CS221 - Machine Organization & Assembly Lang. Programming
Project   :  Lab on Hybrid Programs
Assembler :  Borland TASM 3.0
File Name :  HYBCGCD.ASM
Purpose   :  Provide assembly language subroutines:
	     Greet - Prints a greeting to the user screen.
	     GCD - Uses the Euclidean Algorithm to compute the
	     greatest common divisor for two integers (parameters),
	     and returns the gcd via an output parameter.
	     The GCD procedure calls C++ function PrnIPar to
	     print each of the values of its two parameters.

PROCEDURES CALLED:
    External C++ procedure called:
	FROM ??.CPP:  _Order

***************************************************************
|
	.186
	.model  small

	extrn	_PrnIPar: PROC  ; C++ function in file HYBCFTN.CPP
				; called by the GCD procedure
comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : Greet
  PURPOSE :  To print initial greeting messages to the user
  INPUT PARAMETERS : None
  OUTPUT PARAMETERS or RETURN VALUE:  None
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :None
  PROCEDURES CALLED :  None
  CALLED FROM : main program
|
;****** SUBROUTINE DATA SEGMENT ********************************
	 .data
Msgg1	 db  'Welcome to the greatest common divisor program',13,10,'$'
Msgg2	 db  'This program is a hybrid of C++ and Assembly Language',13,10,'$'
Msgg3	 db  'Date:   Mar 20th,',13,10,'$'

;****** SUBROUTINE CODE SEGMENT ********************************
	.code
	public  _Greet
_Greet	PROC
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

; Print name of programmer
	mov	dx,OFFSET Msgg2 ; set pointer to 2nd greeting message
	mov	ah,9	        ; DOS print string function #
	int	21h	        ; print string

; Print date
	mov	dx,OFFSET Msgg3 ; set pointer to 3rd greeting message
	mov	ah,9	        ; DOS print string function #
	int	21h	        ; print string

; Restore registers from stack
	popf
	popa

; Return to caller module
	ret
_Greet	ENDP

comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : GCD
  PURPOSE :  To find the GCD for two integers
  INPUT PARAMETERS : Value parameter - positive integer number
		     Value parameter - positive integer number
  OUTPUT PARAMETERS:
	Reference parameter - integer GCD for the two numbers
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED : None
  PROCEDURES CALLED :  None
  CALLED FROM : main program
|
;****** SUBROUTINE DATA SEGMENT ********************************
	 .data
MsgPar	 db  'Calling C++ print function from assembly language',13,10,'$'
MsgFirst db  'First parameter: $'
MsgSec   db  'Second parameter: $'

;****** SUBROUTINE CODE SEGMENT ********************************
	.code
	public _GCD
_GCD	PROC
; Save registers and flags on the stack
	pusha
	pushf
	mov	bp,sp

; Print parameter values
	mov	dx,OFFSET MsgPar ; set pointer to 2nd greeting message
	mov	ah,9	        ; DOS print string function #
	int	21h	        ; print string
; Print message announcing first parameter value
	mov	dx,OFFSET MsgFirst ; set pointer to message
	mov	ah,9	        ; DOS print string function #
	int	21h	        ; print string
; Get the first parameter
	mov	ax,[bp+20]   ; copy value of first parameter to ax
; Print first parameter value
	push	ax
	call	_PrnIPar     ; Call C++ function to print 1st integer
	pop	dx
; Print message announcing second parameter value
	mov	dx,OFFSET MsgSec ; set pointer to message
	mov	ah,9	        ; DOS print string function #
	int	21h	        ; print string
; Get the second parameter
	mov	cx,[bp+22]   ; copy value of second parameter to cx
; Print second parameter value
	push	cx
	call	_PrnIPar     ; Call C++ function to print 2nd integer
	pop	dx

; Get the first parameter
	mov	ax,[bp+20]   ; copy value of first parameter to ax
; Get the second parameter
	mov	cx,[bp+22]   ; copy value of second parameter to cx

; Test whether ax holds the larger parameter and, if not,
; interchange the values of the two paramters in the ax and cx registers
; so that ax holds the larger and cx holds the smaller

IF01:   ; first parameter < second parameter
	cmp	ax,cx	     ; compare first param to second param
	jnl	ENDIF01
THEN01: ; interchange the values of the parameters
	xchg	ax,cx        ; ax now holds the larger of the parameters
ENDIF01:  nop

; The following loop implements the Euclidean Algorithm for the GCD
WHILE01: ; Smaller <> 0
	cmp	cx,0
	je	ENDWH01
DO01:
	cwd	           ; Divide Larger by Smaller, and
	idiv	cx         ; leave the Remainder in dx
	mov	ax,cx      ; Larger (ax) <- Smaller (cx)
	mov	cx,dx 	   ; Smaller (cx) <- Remainder (dx)
	jmp	WHILE01    ; Repeat loop
ENDWH01:  nop

; Pass the computed GCD value back to the calling module
	mov	bx,[bp+24]   ; copy address of gcd parameter to bx
	mov	[bx],ax      ; copy the computed gcd to actual parameter
			     ; in calling module

; restore the registers and return to calling module
      	popf
	popa
	ret
_GCD	ENDP
	end	_Greet
