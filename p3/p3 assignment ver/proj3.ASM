comment |
***************************************************************
Programmer:  Jian Zhong
Date      :  Apr 30th, 2020
Course    :  CS221 - Machine Organization & Assembly Lang. Programming
Project   :  This program uses a recursive procedure to
                  compute the nth value of the Fibonacci series

Assembler :  Borland TASM 3.0
File Name :  proj3.asm

Input  :  An positive integer.
Output :  Value of the Fibonacci series by input number.

PROCEDURES CALLED:
    External procedures called:
        FROM iofar.lib: PutStr, PutCrLf, GetDec, PutDec
    Internal procedures called:
        Greet, Find_Fib
|

;****** BEGIN MAIN PROGRAM ************************************
    DOSSEG
    .186
    .model large
    .stack 200h

;****** MAIN PROGRAM DATA SEGMENT *****************************
     .data
PromptFibNum    db  'Please enter an integer for nth value of Fibonacci series: $'
PromptTryAgain  db  '*** Input should be integer >= 0 ***, please try again: $'
NumEcho         db  'The integer you entered was:$'
FibEcho         db  'The Fibonacci series is shown as below:$'
Num             dw  ? ; Number entered by user for computing Fib sequence
i               dw  0 ; index of Fibonacci series


;****** MAIN PROGRAM CODE SEGMENT *****************************
    .code
    extrn    PutCrLf: PROC
    extrn    GetDec: PROC, PutDec: PROC

ProgramStart   PROC  NEAR

; Initializing ds register to hold data segment address
    mov ax,@data
    mov ds,ax

; Call procedure Greet to print introductory messages to the user
    call    Greet                 ; void Greet()

; cout << "Please enter a Number for computing Fib sequence: ";
WHILE_01:
    mov dx,OFFSET PromptFibNum    ; point to the PromptFibNum
    mov ah,9                      ; DOS print string function #
    int 21h                       ; print string

; Fetch input integer from user and store into "Num" para
    call    far ptr GetDec        ; get integer from keyboard, return in ax
    call    far ptr PutCrLf       ; /n
    mov Num,ax                    ; load user input in Num
    
; Print to verify the number was correctly input:
    ; cout << ''The number you entered was: '';
    mov	dx,OFFSET NumEcho         ; point to the NumEcho mesg
    mov	ah,9	                  ; DOS print string function #
    int	21h	                      ; print string
    ; cout << Num;
    mov	ax,Num                    ; put parameter for subroutine PutDec in ax
    call	PutDec                ; print the decimal integer in ax
    call    PutCrLf
    call    PutCrLf

; Verify if the input is negative:
    cmp Num, 0                    ; while (Num < 0)
    jl      TryAgain_01           ; if Num < 0, prompt user to try again
    jmp     ENDWHILE_01           ; valid input, end while loop

; Num < 0:
TryAgain_01:
    mov dx,OFFSET PromptTryAgain  ; set pointer to PromptTryAgain mesg
    mov ah,9                      ; DOS print string function #
    int 21h                       ; print string
    call    PutCrLf
    call    PutCrLf
    jmp     WHILE_01              ; jump back to try again
    
ENDWHILE_01:                      ; End of WHILE_01 LOOP

; cout << "The Fibonacci Series is ";
    mov	dx,OFFSET FibEcho         ; point to the FibEcho mesg
    mov	ah,9	                  ; DOS print string function #
    int	21h	                      ; print string 
    call    far ptr PutCrLf       ; /n

; Print the entire Fibonacci Series:
; ****************************************
; Note: if the input is 7, 
; the series will display from f(0) to f(7), 
; total is 8 numbers in the Fib series.
; ****************************************
; for (int i = 0; i <= Num; i++);
mov dx,Num                        ; load Num into dx
FOR01:
    cmp i,dx                      ; i <= Num ?
    jg END_FOR01                  ; i > Num, end the loop
    ; cout << find_Fib(i) << " ";
    push i                        ; pass Num parameter for Find_Fib PROC
    call    Find_Fib              ; call Find_Fib PROC to compute Fib Series
    mov ax,cx                     ; store cx(result) into ax
    call	 PutDec               ; print the result in ax
    inc i                         ; i++
    jmp FOR01
END_FOR01:
    call    far ptr PutCrLf       ; /n

    mov    ah,4ch    ; DOS terminate program fn #
    int    21h
ProgramStart    ENDP ; end of main program


;------------------------------------------------------
; Procddure Name: Find_Fib
;
; Purpose : Compute the value of the Fibonacci series of Num;
;           This procudure uses a recursive algorithm;
;           Return 1 if N <= 1;
; Input:
;           N -  Pass by value parameter
;
; Output:
;           cx - Value of the Fibonacci series of N
;
; Registers:
;           cx
;
; Procedures Called : Main Program and Find_Fib
;
;--------------------------------------------------------
;****** SUBROUTINE DATA SEGMENT ********************************
    .data
    N     EQU   WORD PTR [bp+10] ; set N as an alias for [bp+10]

;****** SUBROUTINE CODE SEGMENT ********************************
    .code
Find_Fib PROC    NEAR
; Save modified registers and initialize base pointer
    push ax
    push bx
    push dx
    push bp
    mov bp,sp

; if (N <= 1)
    cmp N,1           ; compare N and 1
    jle IF_01         ; Base Case: Find_Fib(0) = 1 and Find_Fib(1) = 1.

; Recursive Case: (N > 2):
;   return (Find_Fib(n - 1) + Find_Fib(n - 2));
    mov ax,N          ; load N into ax
    mov bx,ax         ; load N into bx
    dec ax            ; now ax is n - 1
    sub bx,2          ; now bx is n - 2

    push ax           ; passing n - 1 para
    call    Find_Fib  ; Find_Fib(n-1), value returns to cx
    mov dx,cx         ; store the return value into dx

    push bx           ; passing n - 2 para
    call    Find_Fib  ; Find_Fib(n-2), value returns to cx
    add cx,dx         ; store Find_Fib(n-2) + Find_Fib(n-1) into cx

    jmp ENDIF_01      ; Recursive Case ends

IF_01:
    mov cx,1          ; return 1 in cx, Base Case ends

ENDIF_01:             ; end of IF_01 statement

;Restore modified registers
    pop bp
    pop dx
    pop bx
    pop ax

; Return to caller module and clean the N parameter
    ret    2        
Find_Fib ENDP         ; End of Find_Fib procedure


comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : Greet
  PURPOSE :  To print an initial greeting to the user
  PROCEDURES CALLED :
    FROM iofar.lib: PutStr, PutCrLf
  CALLED FROM : main program
|
;****** SUBROUTINE DATA SEGMENT ********************************
     .data
Msgg1     db  '    Welcome to Fibonacci Series Finding Program!$'
Msgg2     db  '    Programmer: Jian Zhong $'
Msgg3     db  '    Date:  30th Apr, 2020 $'

;****** SUBROUTINE CODE SEGMENT ********************************
    .code
Greet    PROC    near ;
; Save registers on the stack
    pusha
    pushf
; Print name of program
    call    PutCrLf
    mov dx,OFFSET Msgg1 ; set pointer to 1st greeting message
    mov ah,9            ; DOS print string function #
    int 21h             ; print string
    call    PutCrLf
; Print name of programmer
    mov dx,OFFSET Msgg2 ; set pointer to 2nd greeting message
    mov ah,9            ; DOS print string function #
    int 21h             ; print string
    call    PutCrLf
; Print date
    mov dx,OFFSET Msgg3 ; set pointer to 3rd greeting message
    mov ah,9            ; DOS print string function #
    int 21h             ; print string
    call    PutCrLf
    call    PutCrLf
; Restore registers from stack
    popf
    popa
; Return to caller module
    ret
Greet    ENDP ; End Greet procedure

end    ProgramStart ; End of Entire Program
