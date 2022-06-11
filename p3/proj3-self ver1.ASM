comment |
***************************************************************
Programmer:  Jian Zhong
Date      :  Apr 27th, 2020
Course    :  CS221 - Machine Organization & Assembly Lang. Programming
Project   :  This program uses a recursive procedure to
         solve The towers of Hanoi puzle.
Assembler :  Borland TASM 3.0
File Name :  proj3.asm

PROGRAM IDENTIFICATION SECTION:
  Input  :  The number of disks
            The number of starting pole
            The number of final pole
  Output :  None
  Input  :  None
  Output :  None
  Purpose:  To specify the steps required to move the disks, after num is input by the user.

PROCEDURES CALLED:
    External procedures called:
    FROM iofar.lib: PutStr, PutCrLf, GetDec, PutDec
    Internal procedures called:
    Greet, H
|

;****** BEGIN MAIN PROGRAM ************************************
    DOSSEG
    .186
    .model large
    .stack 200h

;****** MAIN PROGRAM DATA SEGMENT *****************************
     .data
PromptFidNum    db  'Please enter a Number for computing Fibonacci series: $'
PromptTryAgain  db  '*** Input should be greater than 0 ***, please try again: $'
MsgEcho         db  'The input you entered was:$'
MsgFid1         db  'The Fibonacci series of $'
MsgFid2         db  'th value was: $'
num   dw  ? ; Number entered by user for computing Fib sequence


;****** MAIN PROGRAM CODE SEGMENT *****************************
    .code
    extrn    PutCrLf: PROC
    extrn    GetDec: PROC, PutDec: PROC

ProgramStart   PROC  NEAR
; Initializing ds register
    mov ax,@data
    mov ds,ax

; Call Greet procedure to print greeting mesgs to user
    call    Greet  ; void Greet();

; cout << "Please enter a Number for computing Fib sequence: ";
WHILE_01:
    mov dx,OFFSET PromptFidNum  ; point to the PromptFidNum
    mov ah,9                    ; DOS print string function #
    int 21h                     ; print string

; get input integer from user into "num" parameter
    call    far ptr GetDec      ; get integer from keyboard, return in ax
    call    far ptr PutCrLf     ; /n
    mov num,ax                  ; store user input in num
    
; Print to verify the number was correctly input
    ; Print message
    mov	dx,OFFSET MsgEcho  ; point to the output mesg
    mov	ah,9	           ; DOS print string function #
    int	21h	               ; print string
    ; Print the input integer
    mov	ax,num             ; put parameter for subroutine PutDec in ax
    call	PutDec         ; print the decimal integer in ax
    call    PutCrLf
    call    PutCrLf

; while (num <= 0)
    cmp num, 0
    jle      TryAgain_01 ; if num <= 0
    jmp     ENDWHILE_01  ; valid input, jump out

; if input <= 0: prompt the user to try again
TryAgain_01:
    mov dx,OFFSET PromptTryAgain    ; set pointer to PromptTryAgain mesg
    mov ah,9                        ; DOS print string function #
    int 21h                         ; print string
    call    PutCrLf
    call    PutCrLf
    jmp     WHILE_01

ENDWHILE_01:     ; End of WHILE_01 LOOP

; Print the nth value of the Fibonacci series using recursion 
   mov	dx,OFFSET MsgFid1   ; point to the Prompt mesg
   mov	ah,9	            ; DOS print string function #
   int	21h	                ; print string

; Print the num value as part of prompt
   mov ax,num               ; put parameter for subroutine PutDec in ax
   call	   PutDec           ; print the decimal integer in ax

; Finish the prompt string
   mov	dx,OFFSET MsgFid2  ; point to the Prompt mesg
   mov	ah,9	            ; DOS print string function #
   int	21h	                ; print string

   push num                 ; push num by Value
   call    find_Fib         ; cout << find_Fib(n);
   mov ax,cx                ; store cx(result) into ax
   call	   PutDec           ; print the decimal integer in ax
   call    PutCrLf          ; /n


    mov    ah,4ch    ; DOS terminate program fn #
    int    21h
ProgramStart    ENDP ; end of main program


comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : find_Fib
  PURPOSE :  Compute and specify the steps required to move the disks, after n is input by the user.
         Print movments message and counter++ if n == 1
         This procedure uses a recursive algorithm.
  INPUT PARAMETERS :
         Pass by value parameter     - n       ; The number of disks

  OUTPUT PARAMETERS: None
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :  None
  PROCEDURES CALLED :
    FROM iofar.lib: PutCrLf, GetDec
  CALLED FROM : Main Program and H Procedure
|
;****** SUBROUTINE DATA SEGMENT ********************************
    .data
    N       EQU     WORD PTR [bp+10]

;****** SUBROUTINE CODE SEGMENT ********************************
    .code
find_Fib PROC    NEAR

; save the registers
    push ax
    push bx
    push dx ; 为什么不能去掉dx？？？？？？
    push bp
    
; set base pointer to bp
    mov bp,sp

; if (N <= 2)
    cmp N,2
    jle IF_01 ; Base case: return 1, by setting cx to 1.

; if N > 2, return (find_Fib(n - 1) + find_Fib(n - 2))
    mov ax,N
    mov bx,ax
    dec ax    ; now ax is n - 1
    sub bx,2  ; now bx is n - 2

    push ax           ; passing n-1
    call    find_Fib  ; find_Fib(n-1), value returns to cx
    mov dx,cx         ; store return value(cx) into dx

    push bx           ; passing n-2
    call    find_Fib  ; find_Fib(n-2), value returns to cx

    add cx,dx         ; store find_Fib(n-2) + find_Fib(n-1) into cx

    jmp ENDIF_01

IF_01:
    mov cx,1

ENDIF_01:

;Restore registers and return having passed the result back
    pop bp
    pop dx
    pop bx
    pop ax

; Return to caller module and clean num parameter
    ret    2        

find_Fib ENDP       ; End of find_Fib procedure


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
