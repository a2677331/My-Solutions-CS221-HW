comment |
***************************************************************
Programmer:  Jian Zhong
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
PromptStartP   db  'The Starting Pole #(1-3): $'
PromptEndP     db  'The Ending Pole #(1-3): $'
PromptEcho1    db  '*** Input should be FROM 3 TO 7 ***, please try again: $'
PromptEcho2    db  '*** Input should be FROM 1 TO 3 ***, please try again: $'
PromptEcho3    db  '*** The Two Pole # must NOT be the same ***, please try again: $'
counter    dw  0 ; The counter of step
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
WHILE01:
    mov dx,OFFSET PromptDisk    ; point to the PromptDisk mesg
    mov ah,9                    ; DOS print string function #
    int 21h                     ; print string
    ; get input integer from user for "num" parameter
    call    far ptr GetDec      ; get integer from keyboard, return in ax
    call    far ptr PutCrLf     ; /n
    mov num,ax                  ; store user input in num

; while (num < 3 || num > 7)
    cmp num, 3
    jl      Try_Again01 ; if num < 3
    cmp num, 7
    jg      Try_Again01 ; if num > 7
    jmp     ENDWHILE01; valid input, jump out

    ; if invalid input: prompt the user
Try_Again01:
    mov dx,OFFSET PromptEcho1    ; set pointer to PromptEcho1 mesg
    mov ah,9                     ; DOS print string function #
    int 21h                      ; print string
    call    PutCrLf
    jmp     WHILE01
ENDWHILE01: nop     ; End of WHILE01 LOOP

; cout << "The Starting pole #(1-3): ";
WHILE02:
    mov dx,OFFSET PromptStartP  ; point to the PromptStartP mesg
    mov ah,9                    ; DOS print string function #
    int 21h                     ; print string
    ; get input integer from user for "pStart" parameter
    call    far ptr GetDec      ; get integer from keyboard, return in ax
    call    far ptr PutCrLf     ; /n
    mov pStart,ax               ; store user input in pStart

; while (pStart < 1 || pStart > 3)
    cmp pStart, 1
    jl      Try_Again02 ; if pStart < 1
    cmp pStart, 3
    jg      Try_Again02 ; if pStart > 3
    jmp     ENDWHILE02  ; valid input, jump out

    ; if invalid input: prompt the user
Try_Again02:
    mov dx,OFFSET PromptEcho2    ; set pointer to PromptEcho2 mesg
    mov ah,9                     ; DOS print string function #
    int 21h                      ; print string
    call    PutCrLf
    jmp     WHILE02
ENDWHILE02: nop ; end of WHILE02 LOOP

; cout << "The Ending Pole #(1-3): ";
WHILE03:
    mov dx,OFFSET PromptEndP  ; point to the PromptStartP mesg
    mov ah,9                    ; DOS print string function #
    int 21h                     ; print string
    ; get input integer from user for "pFinal" parameter
    call    far ptr GetDec      ; get integer from keyboard, return in ax
    call    far ptr PutCrLf     ; /n
    mov pFinal,ax               ; store user input in pFinal

; while (pFinal < 1 || pFinal > 3)
    cmp pFinal, 1
    jl      Try_Again03 ; if pFinal < 1
    cmp pFinal, 3
    jg      Try_Again03 ; if pFinal > 3
    mov ax,pStart
    cmp pFinal, ax
    je      Try_Again03 ; if pFinal == pStart

    jmp     ENDWHILE03  ; valid input, jump out

    ; if invalid input: prompt the user
Try_Again03:
    je      IF03 ; if (pFinal < 1 || pFinal > 3), prompt PromptEcho2 mesg
    mov dx,OFFSET PromptEcho2    ; set pointer to PromptEcho2 mesg
    mov ah,9                     ; DOS print string function #
    int 21h                      ; print string
    call    PutCrLf
    jmp     WHILE03

IF03:            ; if (pFinal == pStart), prompt PromptEcho3 mesg
    mov dx,OFFSET PromptEcho3    ; set pointer to PromptEcho3 mesg
    mov ah,9                     ; DOS print string function #
    int 21h                      ; print string
    call    PutCrLf
    jmp     WHILE03
ENDWHILE03: nop ; end of WHILE03 LOOP

; H(counter, num, pStart, pFinal);
    push    OFFSET counter      ; push Counter by Reference
    push    num                 ; push num by Value
    push    pStart              ; push pStart by Value
    push    pFinal              ; push pFinal by Value
    call    H                   ; Function call

    mov    ah,4ch    ; DOS terminate program fn #
    int    21h
ProgramStart    ENDP ; end of main program

comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : H
  PURPOSE :  Compute and specify the steps required to move the disks, after n is input by the user.
         Print movments message and counter++ if n == 1
         This procedure uses a recursive algorithm.
  INPUT PARAMETERS :
         Pass by reference parameter - counter ; counter of steps
         Pass by value parameter     - n       ; The number of disks
         Pass by value parameter     - s       ; The starting pole #
         Pass by value parameter     - f       ; The ending pole #
  OUTPUT PARAMETERS: None
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :  None
  PROCEDURES CALLED :
    FROM iofar.lib: PutCrLf, GetDec
  CALLED FROM : Main Program and H Procedure
|
;****** SUBROUTINE DATA SEGMENT ********************************
    .data
Annouce1     db  ': Move disk$'
Annouce2     db  '     from pole #$'
Annouce3     db  '     to pole #$'

;****** SUBROUTINE CODE SEGMENT ********************************
    .code
H PROC    NEAR
    pusha
    pushf
    mov     bp, sp

; IF01 n == 1
    mov cx,[bp+24] ; store n in cx
    cmp     cx,1
    jne     ELSE01 ; Recursive Case(jump if n != 1)

; n == 1, then Counter++;
    mov bx,[bp+26] ; bx is the offset of counter
    mov ax,[bx]    ; ax is the content of counter
    inc ax         ; increase ax by 1
    mov [bx],ax    ; copy ax to counter

; Print (Counter, “. Move disk “, n, “ from pole “, s, “ to pole “, f)
; Print Counter parameter
    mov bx,[bp+26]  ; Counter's address is in [bp+26]
    mov ax,[bx]     ; copy counter into ax
    call    PutDec  ; print integer in ax
; Pinrt “: Move disk “
    mov dx,OFFSET Annouce1 ; set pointer to Annouce1 message
    mov ah,9               ; DOS print string function #
    int 21h                ; print string
; Print n parameter
    mov ax, [bp+24] ; n is in [bp+24]
    call    PutDec  ; print integer in ax
; Print “ from pole “
    mov dx,OFFSET Annouce2 ; set pointer to Annouce2 message
    mov ah,9               ; DOS print string function #
    int 21h                ; print string
; Print s parameter
    mov ax, [bp+22] ; s is in [bp+22]
    call    PutDec  ; print integer in ax
; Print “ to pole "
    mov dx,OFFSET Annouce3 ; set pointer to Annouce3 message
    mov ah,9               ; DOS print string function #
    int 21h                ; print string
; Print f parameter
    mov ax, [bp+20] ; f is in [bp+20]
    call    PutDec  ; print integer in ax
    call    PutCrLf ; /n

; End of IF01
    jmp     ENDIF01 ; Base case (num == 1):

ELSE01:
; Find 6 - s - f:
    mov ax,[bp+22]
    neg ax        ; ax is -s
    mov dx,[bp+20]
    neg dx        ; dx is -f
    add ax,6
    add ax,dx     ; AX is 6 - s - f now

; Find n - 1:
    mov dx,[bp+24]
    dec dx        ; DX is n-1 now

; H(counter, n - 1, s, 6 - s - f);
    push    [bp+26]     ; pass counter by reference
    push    dx          ; pass n - 1
    push    [bp+22]     ; pass s
    push    ax          ; pass 6 - s - f
    call    H           ; call H procedure

    ; Store 6 - s - f and n - 1 for later Caller
    push ax ; store 6 - s - f in ax
    push dx ; store n - 1 in dx

; n == 1, then Counter++;
    mov bx,[bp+26] ; bx is the offset of counter
    mov ax,[bx]    ; ax is the content of counter
    inc ax         ; increase ax by 1
    mov [bx],ax    ; copy ax to counter

; Print (Counter, “. Move disk “, n, “ from pole “, s, “ to pole “, f)
    ; Print Counter parameter
    mov bx,[bp+26]          ; Counter's address is in [bp+26]
    mov ax,[bx]             ; copy counter into ax
    call    PutDec          ; print integer in ax
    ; Pinrt “: Move disk “
    mov dx,OFFSET Annouce1  ; set pointer to Annouce1 message
    mov ah,9                ; DOS print string function #
    int 21h                 ; print string
    ; Print n parameter
    mov ax, [bp+24] ; n is in [bp+24]
    call    PutDec  ; print integer in ax
    ; Print “ from pole “
    mov dx,OFFSET Annouce2 ; set pointer to Annouce2 message
    mov ah,9               ; DOS print string function #
    int 21h                ; print string
    ; Print s parameter
    mov ax, [bp+22] ; s is in [bp+22]
    call    PutDec  ; print integer in ax
    ; Print “ to pole "
    mov dx,OFFSET Annouce3 ; set pointer to Annouce3 message
    mov ah,9               ; DOS print string function #
    int 21h                ; print string
    ; Print f parameter
    mov ax, [bp+20]        ; f is in [bp+20]
    call    PutDec         ; print integer in ax
    call    PutCrLf        ; /n

    ; Restore 6 - s - f and n - 1 for H(counter, n - 1, 6 - s - f, f)
    pop dx  ; restore n - 1 in dx
    pop ax  ; restore 6 - s - f in ax
; H(counter, n - 1, 6 - s - f, f);
    push    [bp+26]     ; pass counter by reference
    push    dx          ; pass n - 1
    push    ax          ; pass 6 - s - f
    push    [bp+20]     ; pass f
    call    H           ; call H procedure

ENDIF01: nop  ; End IF01

;Restore registers and return having passed the result back
    popf
    popa
; Return to caller module
    ret    8 ; clean 8 words(4 vars were pushed before Caller)
H ENDP       ; End of H procedure

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
Msgg1     db  '    Welcome to the Tower of Hanoi Puzzle Solving Program!$'
Msgg2     db  '    Programmer: Jian Zhong $'
Msgg3     db  '    Date:  7th Apr, 2020 $'

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
