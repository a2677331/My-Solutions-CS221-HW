comment |
***************************************************************
Programmer:
Date      :  Feb 26th, 2020
Course    :  CS221 - Machine Organization & Assembly Lang. Programming
Project   :  This program uses a recursive procedure to
	     compute the factorial of N.
Assembler :  Borland TASM 3.0
File Name :  recfac.asm

PROGRAM IDENTIFICATION SECTION:

  Input  :  The value of N.
  Output :  The factorial of N.
  Input Files : None
  Output Files: None
  Purpose:  Computes the kfactorial of N, after N is input by the user.

PROCEDURES CALLED:
                
    External procedures called:
	FROM iofar.lib: PutStr, PitCrLf, GetDec, PutDec
    Internal procedures called:
	Greet, RecFact
|
;****** BEGIN MAIN PROGRAM ************************************
        DOSSEG
	.186
	.model large
	.stack 200h

;****** MAIN PROGRAM DATA SEGMENT *****************************
	 .data
A1 Db 'ABC'
A2 db 'XYZ'

;****** MAIN PROGRAM CODE SEGMENT *****************************
	.code
	extrn	PutCrLf: PROC
	extrn	GetDec: PROC, PutDec: PROC

ProgramStart   PROC  NEAR
; Initialize ds register to hold data segment address
	mov	ax,@data
	mov	DS,ax
	mov bx,DS
	mov es,BX

	XOR SI,si
	XOR DI,DI
	
	LEA SI,A1
	LEA DI,A2
	CLD
	MOVSB

end	ProgramStart


