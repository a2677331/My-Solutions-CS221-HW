comment |
***************************************************************
Instructor:  T.Dutta
Date      :  April 1st, 2020
Course    :  CS221 Machine Organization & Assembly Language Programming
Project   :  FPU manipulation
Assembler :  Borland TASM 
File Name :  Roots1.asm

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
                      ; x=(-b+/-(b^2-4ac)^0.5)/2a
Two      dd  2.0      ; the constant 2
Four     dd  4.0      ; the constant 4
                      ; use the FPU to determine the roots of the
                      ; binomial 3.0005x^2 + 2.317x - 9
A        dd  3.0005   ; coefficient of x^2
B        dd  2.317    ; coefficient of x
C        dd  -9.0       ; coefficient of x^0 ⚠️ 已改
R1       dd  ?        ; first real root
R2       dd  ?        ; 2nd real root
num_NAN  dd ?;;;;;;;;;;;;;;;;;;;;

        .code
;****** MAIN PROGRAM CODE SEGMENT *****************************

ProgramStart   PROC     

; Initialize ds register to hold data segment address
        mov     ax,@data
        mov     ds,ax

        call    far ptr roots ; call the far procedure to use the FPU
                              ; to determine the roots of the quadratic
                              ; equation

        mov     ah,4ch        ; return home to DOS
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

                finit       ; initialize the FPU unit

                fld     Two  ; start to determine 2a
                fld     A
                fmulp       

                fld     Four  ; start to determine 4ac
                fld     A
                fmulp
                fld     C
                fmulp   

                fld     B     ; start to determine b^2
                fld     B
                fmulp
                fsubr         ; calculate b^2-4ac

                fsqrt         ; calculate (b^2-4ac)^0.5
                
                fstp    num_NAN
                
                
                fld     B        ; start to determine the first root
                fchs             ; -B
                fsub    num_NAN  ; -B-(b^2-4ac)^0.5
                fdiv    ST,ST(1)    ; divide 2a
                fstp    R1       ; save the first root and pop the FPU stack

                fld     B        ; start to determine the second root
                fchs             ; -B
                fadd    num_NAN  ; -B+(b^2-4ac)^0.5
                fdivr            ; /2a
                fstp    R2       ; save the 2nd root and pop the FPU stack

                fwait
                ret
roots           endp



	end	ProgramStart
