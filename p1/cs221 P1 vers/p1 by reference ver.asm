INCLUDELIB iofar
;****** BEGIN MAIN PROGRAM ************************************
	DOSSEG
	.186
	.model large
	.stack 200h

;****** MAIN PROGRAM DATA SEGMENT *****************************
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
Space1    db ' $' ; ⚠️ 注意加$号！
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
    add si,2    ; ⚠️ 容易忽略！
    loop S0

; push number of items in the array onto stack
; and push array address onto stack
    push iNum           ; push number of items in arr1
    push OFFSET arr1    ; push arr1 address
    call    InsertSort  ; sort arr1

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
  PURPOSE :  To sort 10 integers using insertion sort
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
    ; bp + 6: the number of items in the array
    ; bp + 4: array

    ; setting CX as the actual size of the array ⚠️ 容易忽略
    mov ax,[bp+6] ; setting ax = 10
    mov cx,2       ; 2 byte per word
    mul cx
    mov cx,ax

    ; 'i' and 'j' increase by 2 due to word size. ⚠️ 容易忽略
    mov si,2       ; SI is i and i = 2
    sub di,di      ; DI is j, setting it to 0
    mov bx,[bp+4]  ; copy address of arr1 into BX, BX is the array now.

; Outter loop begins here:
 OUTLOOP:     ; i < len
    cmp si,cx
    jge ENDOUTLOOP ; if i >= len, end outter loop

    mov dx,[bx+si] ; dx is the key (key = arr[i])

    mov di,si
    sub di,2    ; bx is j = i - 1
    add si,2    ; i++

    push ax     ; need to use ax in inner loop, store first
; Inner loop begins here:
INLOOP:	    ; (j >= 0 && arr[j] > key)
    cmp di,0 ;  if j < 0, exit INLOOP
    jnge ENDINLOOP

    cmp [bx+di],dx ; if arr[j] <= key, exit INLOOP
    jle ENDINLOOP

    mov ax,[bx+di] ; arr[j + 1] = arr [j]
    mov [bx+di+2],ax

    sub di,2   ; j--

    jmp INLOOP ; loop back to INLOOP

ENDINLOOP:
    mov [bx+di+2],dx ; array[j+1] = key
    pop ax  ; restore ax before outter loop begins
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
Msgg1	 db  'Program:    Insortion Sort for Ten Integers $'
Msgg2	 db  'Programmer: Jian Zhong $'
Msgg3	 db  'Date:       March 24, 2020 $'

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

