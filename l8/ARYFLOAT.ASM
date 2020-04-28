comment |
***************************************************************
Programmer: 
Date      :  April 6th, 2020
Course    :  CS221 Machine Organization & Assembly Language Programming
Project   :


Assembler :  Borland TASM 3.0
File Name :  ARYFLT.ASM

Input  :
Output :
Input Files : None
Output Files: None

PROCEDURES CALLED:
    External procedures called: None
    Internal procedures called: Findsum, Findmax
|
;****** BEGIN MAIN PROGRAM ************************************
	DOSSEG
	.186
	.8087
	.model large
	.stack 200h

;****** MAIN PROGRAM DATA SEGMENT *****************************
	.data
Sum	 dd  ?
Max	 dd  ?
Ary	 dd  2.0,1.5,16.625,10.5,0.0,5.5,8.25,32.125,-8.5,-48.5  ; ⚠️ array定义是没有冒号的。
Sum2	 dd  ?
ASize	 dw  10
SumMsg   db  'The array sum is: $'
MaxMsg	 db  'The maximum element is: $'

;****** MAIN PROGRAM CODE SEGMENT *****************************
	.code
ProgramStart   PROC  NEAR

; Initialize ds register to hold data segment address
	mov	ax,@data
	mov	ds, ax

; Initialize numerical coprocessor
	finit ; ⚠️ 用有小数点的数必须用。
; Initialize top floating point stack register to zero
	fldz   ; ⚠️ 相当于load 0 到ST（0），ST（0）也可以写作ST, 目的为了后面"fadd Ary[si]"用。

; Initialize registers for the loop to sum the array elements
	mov	cx, 0         ; initialize cx to serve as element counter
	mov	bx, OFFSET Ary ; set pointer to the start of array Ary ⚠️ 用array的地址干嘛？？？？？？？？？？？？？？？？？？？？？？
	mov	si, 0	     ; initialize index register to zero

; Index thru the array, adding the value of each element to the
; top floating point stack register

WHILE01:   ; counter cx < size of array
	cmp	cx,ASize
	jge	ENDWHL01

DO01:   ; Add each array element to the top floating point register
	fadd	Ary[si]   ; add array element to top flt.pt. register， ⚠️ 提取ary内容用arr[si].
	add	si, 4         ; increment index for next array element ⚠️ 这一步非常重要，index加1，数据宽度加4。
	inc	cx            ; increment counter
	jmp	WHILE01       ; jump to beginning of While loop

ENDWHL01:
; Pop and store floating point sum of array elements into variable Sum
	fstp	Sum          ; store and pop flt.pt.stack top register

; Push parameters on stack, call Findsum, pop parameters from stack
	push	OFFSET Ary   ; push onto stack as reference parameter
	push	ASize        ; push onto stack as value parameter, initial value：10
	push	OFFSET Sum2  ; push onto stack as reference parameter
	call	Findsum	     ; Findsum(Ary,ASize,Sum2)

; Exit to operating system
	mov	ah, 4ch	     ; DOS terminate program fn #
	int	21h
ProgramStart	ENDP

comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : Findsum
  PURPOSE :
  INPUT PARAMETERS :
  OUTPUT PARAMETERS or RETURN VALUE:
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED : None
  PROCEDURES CALLED : None
  CALLED FROM : Main program
|
;****** SUBROUTINE CODE SEGMENT ********************************
	.code
Findsum PROC	NEAR
; Save registers and flags on the stack
	pusha
	pushf
	mov	bp,sp

; Copy the parameter, which points to first array element, to bx
	mov	bx, [bp + 24]   ; copy address of array to bx, ⚠️ 对应下面的 "fadd dword ptr [bx][si]".

; Initialize the top floating point stack register to 0
	fldz
; Initialize the index register to zero
	mov	si, 0
; Initialize the counter register to zero
	mov	cx, 0

; Index thru the array, adding the value of each element to the top floating point stack register
WHILE02:   ; counter cx < size of array
	cmp	cx, [bp + 22]
	jge	ENDWHL02

DO02:   ; Add each array element to the top floating point register
	fadd	dword ptr [bx][si]  ; add array element to top flt.pt. reg
	; ⚠️ [bx]是[address of array], 而si为0，然后以4位宽度前进。
	; ⚠️ first time in loop：0 + arr[0]
	; ⚠️ second time in loop：0 + arr[4]

	add	si, 4         ; increment index for next array element
	inc	cx           ; increment counter
	jmp	WHILE02      ; jump to beginning of While loop

ENDWHL02:
; Store sum in actual parameter of calling module
	mov 	bx,[bp + 20]
	fstp	dword ptr [bx]

; Restore the registers and return to calling module
	popf
	popa
	ret     6
Findsum ENDP
	end	ProgramStart
