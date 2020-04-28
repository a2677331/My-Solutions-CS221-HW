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
	     注意: 会被cpp call, 而不是call cpp, 所以不需要Main Program和Main Program Data Segement
PROCEDURES CALLED:
    External C++ procedure called:  ; 用cpp需要的说明
	FROM ??.CPP:  _Order
***************************************************************
|

	.186
	.model  small
	extrn	_PrnIPar: PROC  ; ⚠️ C++ function in file HYBCFTN.CPP called by the GCD procedure
	; ⚠️ 因为要用到HYBCFTN.CPP里的"_PrnIPar" function，所以要列出来。
	; ⚠️ tell asembler that _PrnIPar is delcared in other source file，
	; 	leaving holes in .obj file，and linker will fill in later on。
	; Syntax: EXTRN  label:type

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

	public  _Greet     ; ⚠️ 为什么cpp里call的是Greet()，不是_Greet()??????
	; ⚠️ make label PUBLIC 之后，这个label可以用于其他modules of the program。
	// ⚠️ 上面这行：因为main.cpp会用到Greet，所以要他吗？
	
_Greet	PROC  ; ------------ ⚠️ "Greet" Function 开始，与一般的有些区别：没有near。
; ⚠️ 在mian里是“Greet()”，而是这里是“_Greet”?????????????????
; ⚠️ 为什么不是Greet，而是_Greet?????????????????

; Initialize ds register to hold data segment address，
	mov	ax,@data
	mov	ds,ax
	// ⚠️ 比不是hybird的多了上面两行，因为这次一开始就是Greet，所以加在Greet里。

; Save registers on the stack
	pusha
	pushf

; Print name of program
	mov	dx,OFFSET Msgg1 ; set pointer to 1st greeting message
	mov	ah,9	        ; DOS print string function #
	int	21h	            ; print string

; Print name of programmer
	mov	dx,OFFSET Msgg2 ; set pointer to 2nd greeting message
	mov	ah,9	        ; DOS print string function #
	int	21h	            ; print string

; Print date
	mov	dx,OFFSET Msgg3 ; set pointer to 3rd greeting message
	mov	ah,9	        ; DOS print string function #
	int	21h	            ; print string

; Restore registers from stack
	popf
	popa

; Return to caller module
	ret
_Greet	ENDP  ; -------- ⚠️ "Greet" Function 结束！!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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

	public _GCD  ; ⚠️ 上面这行：因为main.cpp会用到Greet，所以要他吗？????????

_GCD	PROC     ; ------------⚠️ "GCD" Function 开始，与一般的有些区别：没有near。 !!!!!!!!!!
; ⚠️ 在mian里是“GCD()”，而是这里是“_GCD”?????????????????

; Save registers and flags on the stack
	pusha
	pushf
	mov	bp,sp

; Print parameter values
	mov	dx,OFFSET MsgPar ; set pointer to 2nd greeting message
	mov	ah,9	         ; DOS print string function #
	int	21h	             ; print string
; Print message announcing first parameter value
	mov	dx,OFFSET MsgFirst  ; set pointer to message
	mov	ah,9	            ; DOS print string function #
	int	21h	                ; print string
; Get the first parameter
	mov	ax,[bp+20]       ; copy value of first parameter to ax
    ; ⚠️️ 注意：上面asm写的20是十进制，但debugger里编译显示的是【bp+14】，其中14显示的是hex。!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; Print first parameter value
	push	ax ; ⚠️ 输入parameter before calling _PrnIPar function
	call	_PrnIPar     ; Call C++ function to print 1st integer, ⚠️ Calling _PrnIPar Function!!! ⚠️ !!!!!!!!!!!!!!!!!!!!!!!!
	pop	dx
; Print message announcing second parameter value
	mov	dx,OFFSET MsgSec ; set pointer to message
	mov	ah,9	         ; DOS print string function #
	int	21h	             ; print string
; Get the second parameter
	mov	cx,[bp+22]       ; copy value of second parameter to cx
; Print second parameter value
	push	cx  ; ⚠️ 输入parameter before calling _PrnIPar function
	call	_PrnIPar     ; Call C++ function to print 2nd integer，⚠️ Calling _PrnIPar Function!!! ⚠️ !!!!!!!!!!!!!!!!!!!!!!!!
	pop	dx

; Get the first parameter
	mov	ax,[bp+20]   ; copy value of first parameter to ax
; Get the second parameter
	mov	cx,[bp+22]   ; copy value of second parameter to cx

; Test whether ax holds the larger parameter and, if not,
; interchange the values of the two paramters in the ax and cx registers
; so that ax holds the larger and cx holds the smaller

IF01:   ; first parameter < second parameter
	cmp	ax,cx	         ; compare first param to second param
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
	idiv	cx     ; leave the Remainder in dx
	mov	ax,cx      ; Larger (ax) <- Smaller (cx)
	mov	cx,dx 	   ; Smaller (cx) <- Remainder (dx)
	jmp	WHILE01    ; Repeat loop
ENDWH01:  nop

; Pass the computed GCD value back to the calling module
	mov	bx,[bp+24]   ; copy address of gcd parameter to bx
	mov	[bx],ax      ; copy the computed gcd to actual parameter in calling module

; restore the registers and return to calling module
    popf
	popa
	ret
_GCD	ENDP   ; ------------⚠️ "GCD" Function 结束！!!!!!!!!!!!!!!!!!!!!!!!!

end	_Greet     ; ------------⚠️  本ASM全部结束！！只是因为本ASM以_Greet为第一个function开始，所以以这个_Greet来结束全部ASM.!!!!!!!!!!!!!!!!!!!!!!!!
;  Note that the END statement (last statement) of this module does not have a label, as this is not the procedure that begins the program execution.
