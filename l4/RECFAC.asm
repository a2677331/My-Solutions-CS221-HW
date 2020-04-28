comment |
***************************************************************
Programmer:
Date      :  Feb 26th, 2020
Course    :  CS221 - Machine Organization & Assembly Lang. Programming
Project   :  This program uses a recursive procedure to
	     compute the factorial of N.
Assembler :  Borland TASM 3.0
File Name :  recfac.asm

PROGRAM IDENTIFICATION SECTION:

  Input  :  The value of N.
  Output :  The factorial of N.
  Input Files : None
  Output Files: None
  Purpose:  Computes the factorial of N, after N is input by the user.

PROCEDURES CALLED:

    External procedures called:
	FROM iofar.lib: PutStr, PutCrLf, GetDec, PutDec
    Internal procedures called:
	Greet, RecFact
|
;****** BEGIN MAIN PROGRAM ************************************
        DOSSEG
	.186
	.model large
	.stack 200h

;****** MAIN PROGRAM DATA SEGMENT *****************************
	 .data
Promptb	 db  'Enter an integer: $'
Announce db  'The factorial of the number is: $'
M	 dw  ? ;   ⚠️
Result	 dw  ?

;****** MAIN PROGRAM CODE SEGMENT *****************************
	.code
	extrn	PutCrLf: PROC
	extrn	GetDec: PROC, PutDec: PROC

ProgramStart   PROC  NEAR
; Initialize ds register to hold data segment address
	mov	ax,@data
	mov	ds,ax

; call subroutine to print a greeting to the user
	call	Greet       ; void Greet()；        ⚠️⚠️ call ⚠️⚠️️!!!!!!!!!!

; prompt user for an integer and input the integer from keyboard
	mov	dx,OFFSET Promptb  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
; get input integer from user for which factorial will be computed
	call	far ptr GetDec  ; get integer from keyboard, return in ax
	call	far ptr PutCrLf

; store input integer in variable M
	mov	M,ax         ; Store in location for variable M

; push parameters on stack, call RecFact, pop parameters from stack
	push	M	     ; push onto stack as Value parameter
	push    OFFSET Result ; push address of parameter onto stack
	call	RecFact    ; void RecFact(M,Result) ⚠️⚠️ call ⚠️⚠️️!!!!!!!!!!

; print message announcing factorial result
	mov	dx,OFFSET Announce  ; point to the result message
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string

; print the result of computing the factorial
	mov	ax,Result    ; prepare parameter for PutDec in ax
	call	far ptr PutDec  ; Print the decimal integer in ax
	call	far ptr PutCrLf

	mov	ah,4ch	     ; DOS terminate program fn #
	int	21h
ProgramStart	ENDP

comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : RecFact
  PURPOSE :  Computes the Factorial of N, for positive N;
	     Returns 0 if N < 0;  returns 1 if N = 0.
	     This procedure uses a recursive algorithm.
  INPUT PARAMETERS :
	     Pass by value parameter - N
  OUTPUT PARAMETERS:
	     Pass by reference parameter - Fact, the factorial of N
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :None
  PROCEDURES CALLED :
	FROM iofar.lib: PutCrLf, GetDec
  CALLED FROM : Main Program and RecFact
|
;****** SUBROUTINE CODE SEGMENT ********************************                                 ; RecFact call!!⚠️
	.code
RecFact PROC    NEAR
	pusha
	pushf
	mov     bp, sp

; IF01 N < 0
	mov     cx,[bp+22]
	cmp     cx, 0
	jge     ELSE01  ; ⚠️ if N >= 0,      ;to line 113
; THEN01   return 0  since N < 0
	mov     ax, 0
	jmp     ENDIF01                     ;to line 137: Base Case1

ELSE01:
;   IF02 N = 0 or N = 1
	cmp     cx, 1
	jg      ELSE02   ; ⚠️ if N > 1          ;to line 121
;   THEN02  return 1,  since N = 0 or N = 1
    mov     ax, 1
	jmp	    ENDIF02                     ;to line 134: Base Case2

ELSE02:     ; (since N > 1)
    ;   recursively call RecFact(N-1,Fact)
	dec     cx	; cx holds N-1 now
	push    cx	; push value parameter N, less 1, onto stack
	push	[bp+20]	; push the reference parameter onto stack
	call    RecFact                     ; recursive call ⚠️⚠️⚠️

    ;  return N * Fact, where Fact is the factorial of N-1;
    ;  in other words, return N * factorial(N-1)
	mov	    bx,[bp+20] ; copy reference parameter (address) to bx, ⚠️ CAN I USE MOV AX, [BP + 20]? no, it just moves data of position of BP+20 into ax,
	mov	    ax,[bx]    ; copy value of the parameter to ax, ⚠️ what we want is the data of address of BP+20's DATA.
	imul    word ptr[bp+22] ; ⚠️ ax([bx]) * [bp+22], and store in AX

ENDIF02: ; ⚠️label ENDIF02
	nop

ENDIF01:
; pass output parameter back to calling module, namely the factorial of N
	mov	    bx,[bp+20] ; copy reference parameter to bx，⚠️ finding the result address
	mov	    [bx],ax	   ; assign factorial ⚠️result to that memory location aobve
			           ; of the ⚠️ reference parameter in the data segment

; restore registers and return having passed the result back
	popf
	popa
	ret    4
RecFact ENDP                                                                                 ; RecFact call ends!!⚠️

comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : Greet
  PURPOSE :  To print an initial greeting to the user
  INPUT PARAMETERS : None
  OUTPUT PARAMETERS or RETURN VALUE:  None
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :None
  PROCEDURES CALLED :
	FROM iofar.lib: PutStr, PutCrLf
  CALLED FROM : main program
|
;****** SUBROUTINE DATA SEGMENT ********************************
	 .data
Msgg1	 db  '     Welcome to the recursive factorial program  $'
Msgg2	 db  '     Programmer: XXXXXXXXXXXX $'
Msgg3	 db  '     Date:  26th Feb, 2020 $'

;****** SUBROUTINE CODE SEGMENT ********************************
	.code
    Greet	PROC    near ; ⚠️ default is near。

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


end	ProgramStart


