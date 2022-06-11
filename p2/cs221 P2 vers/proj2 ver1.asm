comment |
***************************************************************
PROJ2 ver1
Programmer:
Date      :  Apr 7th, 2020
Course    :  CS221 - Machine Organization & Assembly Lang. Programming
Project   :  This program uses a recursive procedure to
         solve The towers of Hanoi puzle.
Assembler :  Borland TASM 3.0
File Name :  proj2.asm

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
PromptDisk     db  'The disk # for your Tower(3-7): $'
PromptEcho1    db  '*** Input should be FROM 1 TO 3 ***, please try again: $'
PromptStartP   db  'The Starting pole #(1-3): $'
PromptEndP     db  'The Ending   pole #(1-3): $'
PromptEcho2    db  '*** Input should be FROM 1 TO 3, and it MUST BE DIFFERENT from the starting pole #, please try again: *** $'


num        dw  ? ; The number of disks, 3 ≤ num ≤ 7
pStart     dw  ? ; The starting pole #, 1 ≤ pStart ≤ 3
pFinal     dw  ? ; The ending pole #, 1 ≤ pFinal ≤ 3

;****** MAIN PROGRAM CODE SEGMENT *****************************
    .code
    extrn    PutCrLf: PROC
    extrn    GetDec: PROC, PutDec: PROC

ProgramStart   PROC  NEAR
; Initialize ds register to hold data segment address
    mov ax,@data
    mov ds,ax

; call subroutine to print a greeting to the user
    call    Greet  ; void Greet();

; cout << "The disk # for your Tower(3-7): ";
    mov dx,OFFSET PromptDisk    ; point to the PromptDisk mesg
    mov ah,9                    ; DOS print string function #
    int 21h                     ; print string
    ; get input integer from user for "num" parameter
    call    far ptr GetDec      ; get integer from keyboard, return in ax
    call    far ptr PutCrLf     ; /n
    ; store input integer in variable num
    mov num,ax
    
; cout << "The Starting pole #(1-3): ";
    mov dx,OFFSET PromptStartP  ; point to the PromptStartP mesg
    mov ah,9                    ; DOS print string function #
    int 21h                     ; print string
    ; get input integer from user for "pStart" parameter
    call    far ptr GetDec      ; get integer from keyboard, return in ax
    call    far ptr PutCrLf     ; /n
    ; store input integer in variable num
    mov pStart,ax
    
; cout << "The Ending   pole #(1-3): ";
    mov dx,OFFSET PromptEndP    ; point to the PromptEndP mesg
    mov ah,9                    ; DOS print string function #
    int 21h                     ; print string
    ; get input integer from user for "pFinal" parameter
    call    far ptr GetDec      ; get integer from keyboard, return in ax
    call    far ptr PutCrLf     ; /n
    ; store input integer in variable num
    mov pFinal,ax   

; push parameters on stack, call RecFact, pop parameters from stack
    call    far ptr PutCrLf     ; /n

    push    num          ; push num as Value parameter
    push    pStart       ; push pStart as Value parameter
    push    pFinal       ; push pFinal as Value parameter
    call    H            ; void H(num, pStart, pFinal);

    call    far ptr PutCrLf     ; /n

    mov    ah,4ch        ; DOS terminate program fn #
    int    21h
ProgramStart    ENDP

comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : H
  PURPOSE :  Compute and specify the steps required to move the disks, after num is input by the user.
         Display movments message if num == 1  ; output specifyied movements if N = 0.
         This procedure uses a recursive algorithm.
  INPUT PARAMETERS :
         Pass by value parameter - num -> [bp+24]
         Pass by value parameter - pStart -> [bp+22]
         Pass by value parameter - pFinal -> [bp+20]
  OUTPUT PARAMETERS: None
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :  None
  PROCEDURES CALLED :
    FROM iofar.lib: PutCrLf, GetDec
  CALLED FROM : Main() and H().
|
;****** SUBROUTINE DATA SEGMENT ********************************
.data
Annouce1     db  'Move disk$'
Annouce2     db  ' from pole$'
Annouce3     db  ' to pole$'

;****** SUBROUTINE CODE SEGMENT ********************************
    .code
H PROC    NEAR
    pusha
    pushf
    mov     bp, sp

;IF01 num == 1
    mov cx,[bp+24] ; 忘了要用num的位置[bp+24]，而不是num本身!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    cmp     cx,1
    jne     ELSE01 ; Recursive Case(jump if num != 1)

;Print movment message: move num from pStart to pFinal
    ; Pinrt Annouce1
    mov dx,OFFSET Annouce1 ; set pointer to Annouce1 message
    mov ah,9               ; DOS print string function #
    int 21h                ; print string
    ; Print "num"
    mov ax, [bp+24] ; num is in [bp+24]
    call    PutDec  ; print integer in ax
    ; Print Annouce2
    mov dx,OFFSET Annouce2 ; set pointer to Annouce2 message
    mov ah,9               ; DOS print string function #
    int 21h                ; print string
    ; Print "pStart"
    mov ax, [bp+22] ; pStart is in [bp+22]
    call    PutDec  ; print integer in ax
    ; Print Annouce3
    mov dx,OFFSET Annouce3 ; set pointer to Annouce3 message
    mov ah,9               ; DOS print string function #
    int 21h                ; print string
    ; Print "pFinal"
    mov ax, [bp+20] ; pFinal is in [bp+20]
    call    PutDec  ; print integer in ax
    call    PutCrLf ; /n
    
;End of procedure
    jmp     ENDIF01 ; Base case (num==1): 
    
ELSE01:
; Find 6-Pstart-Pfinal:
    mov ax,[bp+22]
    neg ax        ; ax is -pStart now
    mov dx,[bp+20]
    neg dx        ; dx is -pFinal now
    add ax,6
    add ax,dx     ; ax is 6-Pstart-Pfinal now

; Find num-1:
    mov dx,[bp+24]  ; ⚠️ 要把num改为[bp+24]!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    dec dx          ; dx is num-1 now

; Store 6-Pstart-Pfinal and num-1 for later caller
    push ax ; store 6-Pstart-Pfinal in ax
    push dx ; store num-1 in dx

; Pass parameters for caller:
    push    dx       ; push num-1 as Value parameter
    push    [bp+22]   ; push pStart as Value parameter
    push    ax       ; push 6-Pstart-Pfinal as Value parameter
    call    H        ; H(num-1, Pstart, 6-Pstart-Pfinal);

;Print movment message:
;print (“move disk “, num, “ from pole “, Pstart, “ to pole “, Pfinal)
    ; Pinrt Annouce1
    mov dx,OFFSET Annouce1 ; set pointer to Annouce1 message
    mov ah,9               ; DOS print string function #
    int 21h                ; print string
    ; Print num
    mov ax, [bp+24] ; num is in [bp+24]  ⚠️ 注意不能用num，要用【bp+24】!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    call    PutDec  ; print integer in ax
    ; Print Annouce2
    mov dx,OFFSET Annouce2 ; set pointer to Annouce2 message
    mov ah,9               ; DOS print string function #
    int 21h                ; print string
    ; Print pStart
    mov ax, [bp+22] ; pStart is in [bp+22]
    call    PutDec  ; print integer in ax
    ; Print Annouce3
    mov dx,OFFSET Annouce3 ; set pointer to Annouce3 message
    mov ah,9               ; DOS print string function #
    int 21h                ; print string
    ; Print pFinal
    mov ax, [bp+20] ; pFinal is in [bp+20]
    call    PutDec  ; print integer in ax
    call    PutCrLf ; /n
    
; Restore 6-Pstart-Pfinal and num-1 for later caller
    pop dx  ; restore num-1 in dx
    pop ax  ; restore 6-Pstart-Pfinal in ax

; Pass parameters for caller:
    push    dx          ; push num-1 as Value parameter
    push    ax          ; push pStart as Value parameter
    push    [bp+20]     ; push pFinal as Value parameter
    call    H           ; H(num - 1, Pstart, 6 - Pstart - Pfinal);

ENDIF01: nop

;Restore registers and return having passed the result back
    popf
    popa
    ret    6
H ENDP

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
Msgg1     db  '    Welcome to the Towers of Hanoi Puzzle Program $'
Msgg2     db  '    Programmer: Jian Zhong $'
Msgg3     db  '    Date:  7th Apr, 2020 $'

;****** SUBROUTINE CODE SEGMENT ********************************
    .code
    Greet    PROC    near ;

; Save registers on the stack
    pusha
    pushf

; Print name of program
    mov    dx,OFFSET Msgg1 ; set pointer to 1st greeting message
    mov    ah,9            ; DOS print string function #
    int    21h                ; print string
    call    PutCrLf

; Print name of programmer
    mov    dx,OFFSET Msgg2 ; set pointer to 2nd greeting message
    mov    ah,9            ; DOS print string function #
    int    21h                ; print string
    call    PutCrLf

; Print date
    mov    dx,OFFSET Msgg3 ; set pointer to 3rd greeting message
    mov    ah,9            ; DOS print string function #
    int    21h                ; print string
    call    PutCrLf
    call    PutCrLf

; Restore registers from stack
    popf
    popa

; Return to caller module
    ret
    Greet    ENDP

end    ProgramStart

