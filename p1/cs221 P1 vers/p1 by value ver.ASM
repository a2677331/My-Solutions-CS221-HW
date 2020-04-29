INCLUDELIB iofar
;****** BEGIN MAIN PROGRAM ************************************
	DOSSEG
	.186
	.model large
	.stack 200h
⚠️注意：
是我自己的版本
用了先push array在bp前，再sort这些copied版本的array，
没有用by reference。
;的方法。
****** MAIN PROGRAM DATA SEGMENT *****************************
	 .data
Prompt1	 db  'Enter integers #$'
Prompt2  db  ': $'
arr1  dw  10 dup(0)     ; unsorted array, 10 items
arr2  dw  10 dup(0)     ; sorted array, 10 items
iNum dw  10             ; total number of items in the array
i	 dw  1              ; i index for insertion sort
j	 dw  ?              ; j index for insertion sort
key  dw  ?              ; key index for insertion sort
Count	 dw  1          ; input counter
MsgEcho  db  'The input was:$'
MsgUnsorted	 db  'Unsorted List $'
MsgSorted	 db  'Sorted List $'
Space1    db ' $' ;
Space2    db '       $'

;****** MAIN PROGRAM ️CODE SEGMENT *****************************
	.code
	extrn	PutStr: PROC, PutCrLf: PROC
	extrn	GetDec: PROC, PutDec: PROC

ProgramStart   PROC

; Initialize ds register to hold data segment address
	mov	ax,@data
	mov	ds,ax

; Call procedure Greet to print introductory messages to the user
	call	Greet        ; call subroutine to print greeting

; Print prompt message to the user
	mov	dx,OFFSET Prompt1   ; let DS register point to the Prompt1's address
	mov	ah,9	            ; DOS print string function #
	int	21h	                ; print string

; Print the item number value as part of prompt
    mov	ax,Count         ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax, not in new line

; Finish the prompt string
	mov	dx,OFFSET Prompt2  ; point to the Prompt mesg
	mov	ah,9	           ; DOS print string function #
	int	21h	               ; print string

; Input an integer from the user keyboard and assign it to arr[]
	call    GetDec         ; integer from keyboard returned in ax (only integers are accepted)
	sub si,si
	mov [arr1+si],ax           ; store input value in array location

; Print for Verification
  ; Print message
	mov	dx,OFFSET MsgEcho  ; point to the output mesg
	mov	ah,9	           ; DOS print string function #
	int	21h	               ; print string
  ; Print the input integer
	mov	ax,[arr1+si]         ; put parameter for subroutine PutDec in ax
	call	PutDec            ; print the decimal integer in ax
	call    PutCrLf
	call    PutCrLf

; Increment index of the array and counter
	add si,2              ; increase the index of the array
	inc	Count

WHILE01:	;  Count < total item number of the array
	mov	ax, Count       ; assign Count to ax
	cmp	ax, iNum
	jnle	ENDWHL01    ; if >
DO01:       ; Input integer, print it
   ; Print prompt message to the user
	mov	dx,OFFSET Prompt1  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
   ; Print the Count value as part of prompt
	mov	ax,Count     ; put parameter for subroutine PutDec in ax
	call	PutDec       ; print the decimal integer in ax
   ; Finish the prompt string
	mov	dx,OFFSET Prompt2  ; point to the Prompt mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string

  ; Input an integer from the user keyboard and assign it to N
	call	GetDec          ; integer from keyboard returned in ax
	mov [arr1+si],ax          ; store input value in array location

; Print for Verification
	mov	dx,OFFSET MsgEcho   ; point to the output mesg
	mov	ah,9	            ; DOS print string function #
	int	21h	                ; print string

  ; Print the input integer
	mov	ax,[arr1+si]             ; put parameter for subroutine PutDec in ax
	call	PutDec          ; print the decimal integer in ax
	call    PutCrLf
	call    PutCrLf

  ; Increment Count and repeat the loop
	inc	Count
	add si,2              ; increase the index of the array
	jmp	WHILE01
; End of while loop
ENDWHL01:
    nop

; copy arr1 into arr2 for printing unsorted version later:
    sub si,si    ; initialize array index
    mov cx,iNum  ; loop for 10 times
S0:
    push [arr1+si]
    pop  [arr2+si]
    add si,2    ;
    loop S0

; push number of items in the array onto stack
; and push array address onto stack
    push iNum           ; push number of items in arr1
    mov cx,10
    sub si,si
V:

    push [arr1+si]
    add si,2
    loop V
    call    InsertSort  ; sort arr1   ⚠️注意⚠️

; Print label at the top of each column
	mov	dx,OFFSET MsgUnsorted ; set pointer to MsgUnsorted message
	mov	ah,9	              ; DOS print string function #
	int	21h	                  ; print string

	mov	dx,OFFSET MsgSorted ; set pointer to MsgSorted message
	mov	ah,9	            ; DOS print string function #
	int	21h	                ; print string
	call    PutCrLf

; Print arr1 and arr2
    sub si,si    ; initialize si
    sub di,di    ; initialize di
    mov cx,iNum ; loop time for printing items in array
S1:
    ; Print whitespace(adjust format)
	mov	dx,OFFSET Space1
	mov	ah,9
	int	21h
    ; pinrt arr2(unsorted version)
    mov	ax,[arr2+si]               ; put arr2 item for subroutine PutDec in ax
    call	PutDec                 ; print the decimal integer in ax
    ; Print whitespace(adjust format)
	mov	dx,OFFSET Space2
	mov	ah,9
	int	21h
    ; print arr1(sorted version)
    mov	ax,[arr1+si]               ; put arr1 item for subroutine PutDec in ax
    call	PutDec                 ; print the decimal integer in ax
    call    PutCrLf
    add si,2
    add di,2
    loop S1

; Exit to the operating system
	mov	ah,4ch	     ; DOS terminate program fn #
	int	21h
ProgramStart	ENDP

comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : InsertSort
  PURPOSE :  To sort 10 integers using Insertion Sort in Ascending Order
	        Returns: None
  INPUT PARAMETERS
            pass by value, number of items in an array
            pass by reference, address of an array
  OUTPUT PARAMETERS: None
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :None
  PROCEDURES CALLED :
  CALLED FROM : Main Program
|
;****** SUBROUTINE CODE SEGMENT ********************************
	.code
InsertSort PROC    near
; Save registers on the stack and set up bp register
    push bp
	mov  bp,sp
	push bx
	push si
	push di
    ; bp + 24: the number of items in the array
    ; bp + 22 ~ bp + 4: array

    mov cx,[bp+24] ; length
    mov ax,1 ; i
    mov di,-2 ; i index
    ; ⚠️ 用了很久时间弄懂，如果用[bp+22+di]，index之间是相加的，那就di初始值为-2，因为第一位为【24-2】=【22】
    mov si,0 ; j index

; Outter loop begins here:
 OUTLOOP:     ; i < len
    cmp ax,cx
    jge ENDOUTLOOP ; if i >= len, end outter loop

    mov dx,[bp+22+di] ; dx is the key (key = arr[i])

    mov bx,ax  ; bx is j = i - 1
    dec bx

    push di    ; j index + 2
    pop si
    add si,2    ; first time, si = 0

; Inner loop begins here:
INLOOP:	    ; (j >= 0 && arr[j] > key)
    cmp bx,0 ;  if j < 0, exit INLOOP
    jnge ENDINLOOP

    cmp [bp+22+si],dx ; if arr[j] <= key, exit INLOOP
    jle ENDINLOOP

    push [bp+22+si] ; arr[j + 1] = arr [j]
    pop [bp+20+si]  ; ⚠️

    dec bx   ; j--
    add si,2

    jmp INLOOP ; loop back to INLOOP

ENDINLOOP:
    mov [bp+20+si],dx ; array[j+1] = key ⚠️, first time finally si becomes 2, should point to [22]

    inc ax    ; i++
    sub di,2 ; i index

    jmp OUTLOOP ; back to Outter Loop

ENDOUTLOOP:
    nop
; restore registers
    pop di
    pop si
    pop bx
    pop bp
	ret
InsertSort ENDP

comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : Greet
  PURPOSE :  To print initial greeting messages to the user
  INPUT PARAMETERS : None
  OUTPUT PARAMETERS or RETURN VALUE:  None
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :None
  PROCEDURES CALLED :           ;
	FROM iofar.lib: PutCrLf     ;
  CALLED FROM : main program    ;
|
;****** SUBROUTINE DATA SEGMENT ********************************
	.data
Msgg1	 db  'Program:    Insortion Sort for Ten Integers in Ascending Order $'
Msgg2	 db  'Programmer: Jian Zhong $'
Msgg3	 db  'Date:       March 25, 2020 $'

;****** SUBROUTINE CODE SEGMENT ********************************
	.code
Greet	PROC    near

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

; Restore registers from stack
	popf
	popa

; Return to caller module
	ret
Greet	ENDP
	end	ProgramStart

