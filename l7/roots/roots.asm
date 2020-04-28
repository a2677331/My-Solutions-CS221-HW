comment |
***************************************************************
Instructor:  T.Dutta
Date      :  April 1st, 2020
Course    :  CS221 Machine Organization & Assembly Language Programming
Project   :  FPU manipulation
Assembler :  Borland TASM 
File Name :  Roots.asm

Input   :  none; use predefined numbers
Output  :  none; use memory dumps to verify program operation
Input Files : None
Output Files: None


PROCEDURES CALLED:
    Internal procedures called:
        roots

|
;****** TASM Directives ************************************
        .MODEL  LARGE
        DOSSEG
        .186
        .8087
	.stack 200h

;****** MAIN PROGRAM DATA SEGMENT ****************************
	.data
                      ; set up the floating point constants
                      ; for the quadratic root formula
                      ; x=(-b +/- (b^2 - 4ac)^0.5)/2a
Two      dd  2.0      ; the constant 2
Four     dd  4.0      ; the constant 4
                      ; use the FPU to determine the roots of the
                      ; binomial x^2 - 16x + 39
A        dd  1.0      ; coefficient of x^2
B        dd  -16.0    ; coefficient of x
C        dd  39.0     ; coefficient of x^0
R1       dd  ?        ; first real root
R2       dd  ?        ; 2nd real root
num1     dd  13       ; ???
num2     dd  5        ; ???
temp     dw  ?        ; ???

        .code
;****** MAIN PROGRAM CODE SEGMENT *****************************

ProgramStart   PROC     

; Initialize ds register to hold data segment address
        mov     ax,@data
        mov     ds,ax

        call    far ptr roots    ; ??? why far

        mov     ah,4ch
        int     21h
ProgramStart    ENDP

comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : roots
  PURPOSE :  To determine the roots of a quadratic formula
  INPUT PARAMETERS : None
  OUTPUT PARAMETERS or RETURN VALUE:  None
  NON-LOCAL VARIABLES REFERENCED: Two, Four, A, B, C
  NON-LOCAL VARIABLES MODIFIED : R1, R2
  PROCEDURES CALLED : none
  CALLED FROM : main program
|

roots           PROC    far

                finit         ; initialize the FPU unit
                fstcw   temp  ; ???
                or      temp,0c00h
                fldcw   temp

                fild    num1
                fidiv   num2
                frndint

                fld     Two   ; start to determine 2a
                fmul    A     ;

                fld     Four  ; start to determine 4ac
                fmul    A
                fmul    C

                fld     B     ; start to determine b^2
                fmul    B

                fsubr         ; calculate b^2-4ac

                fsqrt         ; calculate (b^2-4ac)^0.5

                fld     B     ; start to determine the first root
                fchs          ; change the sign of B
                fsub    ST,ST(1)
                fdiv    ST,ST(2)
                fstp    R1    ; save the first root and pop the FPU stack

                fld     B     ; start to determine the second root
                fchs          ; change the sign of B
                fadd
                fdivr
                fstp    R2    ; save the 2nd root and pop the FPU stack

                fwait
                ret
roots           endp



	end	ProgramStart
