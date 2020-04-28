comment |
***************************************************************
Programmer:  Jian Zhong
Date      :  Apr 27th, 2020
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
        Greet, Find_Fid
|

;****** BEGIN MAIN PROGRAM ************************************
    DOSSEG
    .186
    .model large
    .stack 200h

;****** MAIN PROGRAM DATA SEGMENT *****************************
     .data
PromptFidNum    db  'Please enter a Number: $'
PromptTryAgain  db  '*** Input should be integer greater than 0 ***, please try again: $'
NumEcho         db  'The number you entered was:$'
FidEcho         db  'The value of Fibonacci series is $'
Num             dw  ? ; Number entered by user for computing Fib sequence


;****** MAIN PROGRAM CODE SEGMENT *****************************
    .code
    extrn    PutCrLf: PROC
    extrn    GetDec: PROC, PutDec: PROC

ProgramStart   PROC  NEAR

; Initializing ds register to hold data segment address
    mov ax,@data
    mov ds,ax

; Call procedure Greet to print introductory messages to the user
    call    Greet               ; void Greet()

; cout << "Please enter a Number for computing Fib sequence: ";
WHILE_01:
    mov dx,OFFSET PromptFidNum  ; point to the PromptFidNum
    mov ah,9                    ; DOS print string function #
    int 21h                     ; print string

; Fetch input integer from user and store into "Num" para
    call    far ptr GetDec      ; get integer from keyboard, return in ax
    call    far ptr PutCrLf     ; /n
    mov Num,ax                  ; load user input in Num
    
; Print to verify the number was correctly input:
    ; cout << ''The number you entered was: '';
    mov	dx,OFFSET NumEcho  ; point to the NumEcho mesg
    mov	ah,9	           ; DOS print string function #
    int	21h	               ; print string
    ; cout << Num;
    mov	ax,Num             ; put parameter for subroutine PutDec in ax
    call	PutDec         ; print the decimal integer in ax
    call    PutCrLf
    call    PutCrLf

; Verify if the input is negative:
    cmp Num, 0           ; while (Num < 0)
    jl      TryAgain_01  ; if Num < 0, prompt user to try again
    jmp     ENDWHILE_01  ; valid input, end while loop

; Num < 0:
TryAgain_01:
    mov dx,OFFSET PromptTryAgain   ; set pointer to PromptTryAgain mesg
    mov ah,9                       ; DOS print string function #
    int 21h                        ; print string
    call    PutCrLf
    call    PutCrLf
    jmp     WHILE_01        ; jump back to try again
    
ENDWHILE_01:                ; End of WHILE_01 LOOP

   ; cout << "The value of Fibonacci series is ";
   mov	dx,OFFSET FidEcho   ; point to the FidEcho mesg
   mov	ah,9	            ; DOS print string function #
   int	21h	                ; print string

   ; cout << Find_Fid(Num) << endl;
   push Num                 ; pass Num parameter for Find_Fid PROC
   call    Find_Fid         ; call Find_Fid PROC to compute Fibonacci Series
   mov ax,cx                ; store cx(result) into ax
   call	   PutDec           ; print the decimal integer in ax
   call    PutCrLf          ; /n

    mov    ah,4ch    ; DOS terminate program fn #
    int    21h
ProgramStart    ENDP ; end of main program


;------------------------------------------------------
; Procddure Name: Find_Fid
;
; Purpose : Compute the value of the Fibonacci series of Num;
;           This procudure uses a recursive algorithm;
;           Return 1 if N <= 1;
; Input:
;           N - Pass by value parameter
;
; Output:
;           cx - Value of the Fibonacci series of N
;
; Registers:
;           cx
;
; Procedures Called : Main Program and Find_Fid
;
;--------------------------------------------------------
;****** SUBROUTINE DATA SEGMENT ********************************
    .data
    N     EQU   WORD PTR [bp+10] ; set N as an alias for [bp+10]

;****** SUBROUTINE CODE SEGMENT ********************************
    .code
Find_Fid PROC    NEAR
; Save modified registers and initialize base pointer
    push ax
    push bx
    push dx ; 为什么不能去掉dx？？？？？？ 因为ds没有要传到外面去，而cx要传到外面去，所以cx不要保存，而dx，ax，bx都要保存！！！
    push bp
    mov bp,sp

; if (N <= 1)
    cmp N,1           ; compare N and 1
    jle IF_01         ; Base Case: Find_Fid(0) = 1 and Find_Fid(1) = 1.

; Recursive Case: (N > 2):
;   return (Find_Fid(n - 1) + Find_Fid(n - 2));
    mov ax,N          ; load N into ax
    mov bx,ax         ; load N into bx
    dec ax            ; now ax is n - 1
    sub bx,2          ; now bx is n - 2

    push ax           ; passing n - 1 para
    call    Find_Fid  ; Find_Fid(n-1), value returns to cx
    mov dx,cx         ; store the return value into dx

    push bx           ; passing n - 2 para
    call    Find_Fid  ; Find_Fid(n-2), value returns to cx
    add cx,dx         ; store Find_Fid(n-2) + Find_Fid(n-1) into cx

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
Find_Fid ENDP       ; End of Find_Fid procedure


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
Msgg1     db  '    Welcome to Fibonacci Number Finding Program!$'
Msgg2     db  '    Programmer: Jian Zhong $'
Msgg3     db  '    Date:  27th Apr, 2020 $'

;****** SUBROUTINE CODE SEGMENT ********************************
    .code
Greet    PROC    near ;
; Save registers on the stack
    pusha
    pushf
; Print name of program
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
