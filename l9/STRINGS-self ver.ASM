        DOSSEG
        .MODEL  large

        .STACK  200h


        .DATA
ASCNull         EQU     0       ; ASCII null
ASCcr           EQU     13      ; ASCII carriage return
ASClf           EQU     10      ; ASCII line feed
BuffSize        EQU     255     ; Maximum string size
MaxL            EQU     128     ; 128 character string

exCode          db      0
welcome         db      "Welcome to echo-string",ASCcr,ASClf
                db      "Type any string and press Enter",ASCcr,ASClf,ASClf,0
testString      db      MaxL  dup (0),0    ; max length plus null character

v1              db      '12345678901234567890',0  ; 20 byte string
v2              db      40 dup (0)                ; 40 byte string

buff            db      81 dup(0FFh)

str1            db      'Sample user response string',0
str2            db      'String was empty$'

lc              db      'abcdefghijklmnopqrstuvwxz',0

str3            db      'Lions and tigers and bears, oh my!',0

dest            db      'Insert into slot-B               ',0
;
; extra space for dest to expand into
;
                db      40 dup (0)

source          db      'tab-A ',0

source1         db      'the end!',0
dest1           db      'This is ',0
;
; extra space for concatanation
;
                db      15 dup (0)

str4            db      'Original string',0
str5            db      80 dup (?)

ext             db      '.ASM',0
filename        db      'MYTEST.ASM',0
eureka          db      'I found it!!$'  ; ⚠️ dos只认这个终止符号！！！！

phoneNumber     db      '(800)-555-1212',0
areaCode        db      '(800)-',0

;
; define a data strucure
;
StrBuffer struc
        maxLen  db      BuffSize ; max buffer length
        strLen  db      0       ; string length
        chars   db      BuffSize dup(?)  ; buffer for StrRead
StrBuffer ends

buffer  StrBuffer       <>      ; bufffer variable for ReadStr


;------------------------------------------------
; Procedures defined in this file
;
;       MoveLeft        --- memory move with increasing indexes
;       MoveRight       --- memory move with decreasing indexes
;       StrNull         --- erase all chars in string
;       StrLength       --- return number of chars in string
;       StrUpper        --- convert chars in string to uppercase
;       StrCompare      --- alphabetically compare two strings
;       StrDelete       --- delete chars from stirng
;       StrInsert       --- insert chars into strings
;       StrConcat       --- attach one string to another
;       StrPos          --- find position of substring in a string
;       StrRemove       --- remove substring from a string
;       StrRead         --- read string with editing keys
;-------------------------------------------------------------
        .CODE
ProgramStart:
        mov   ax,@data
        mov   ds,ax     ; set up ds and es to point to same segment
        mov   es,ax

        mov   di,offset welcome ; display welcome message
        call  StrWrite          ; ⚠️ write string into device from di

        mov   di,offset testString ; address of testString
        mov   cx,MaxL            ; cx = maximum length
        call  StrRead;          ; read a string from the keyboard, ⚠️ to di eventually.
        call  NewLine;          ; start a new display line(ah, dx is changed.)
        call  StrWrite          ; echo string to display(print di(offset of testString))

        mov     si,offset v1    ; assign source address of v1
        mov     di,offset v2    ; assign source address of v2
        mov     bx,0            ; set source index(v1[0])
        mov     dx,10           ; set destination index (v2[10])
        mov     cx,20           ; specify the number of bytes to move
        call    MoveLeft        ; move bytes from v1[0] to v2[10]

        mov     di,offset buff  ; address of buf storage area
        call    StrNull         ; turn it into a null string

        mov     di,offset str1        ; address of string #1
        call    StrLength       ; set cx to string length
        or      cx,cx           ; is cx = 0?
        jz      lbl1
        jmp     lbl2
lbl1:   mov     ah,9           ; print empty string message
        mov     dx,offset str2
        int     21h
        call    NewLine
lbl2:
        mov     di,offset lc  ; address of string lc
        call    StrUpper      ; convert all chars to upper

        mov     di,offset str3 ; address of lions string
        mov     dx,6           ; index to 'a' in 'and'
        mov     cx,11          ; set up to delete 11 chars
        call    StrDelete

        mov     si,offset source       ; address of source string
        mov     di,offset dest         ; address of destination string
        mov     dx,7               ; dx = index of 'i' of 'into' in dest str
        call    StrInsert          ; insert string

        mov     si,offset source1       ; address of source string
        mov     di,offset dest1         ; address of destination string
        call    StrConcat               ; concatinate

        mov     si,offset str4          ; address of string str4
        mov     di, offset str5         ; address of string str5
        call    StrCopy                 ; copy string

        mov     si,offset ext           ; address of the file extension string
        mov     di,offset filename      ; address of the file name string
        call    StrPos                  ; find the sring position
        jz      fdext                   ; found extension
        jmp     notfdext                ; did not find extension

fdext:  call    NewLine                 ; end the line of display output
        mov     ah,9                    ; print the found it message
        mov     dx, offset eureka
        int     21h
        call    NewLine


notfdext:
        mov     si,offset areaCode    ; address of the area code string
        mov     di,offset phoneNumber ; address of the phone number string
        call    StrRemove             ; remove the substring


        mov   ah,4ch                ;DOS terminate program function
        int   21h

;------------------------------------------------------
; MoveLeft procedure
;
;Input:
;       si = address of source string (s1)
;       di = address of destination string (s2)
;       bx = index s1 (i1)
;       dx = index s2 (i2)
;       cx = number of bytes to move (count)
;
;Output:
;       count bytes from s1(i1) moved to the location starting at s2(i2)
;
;Registers:
;       none
;
;--------------------------------------------------------
MoveLeft        proc            near

                jcxz    @@99    ; exit if count =0

                push    cx      ;save modified registers
                push    si
                push    di

                add     si,bx   ; index into source string
                add     di,dx   ; index into destination string
                cld             ; auto increment on
                rep     movsb   ; move while cx!=0

                pop     di      ;restore registers
                pop     si
                pop     cx
@@99:
                ret     ; return to calling program
MoveLeft        endp

;------------------------------------------------------
; MoveRight procedure
;
;Input:
;       si=address of source string (s1)
;       di=address of destination string (s2)
;       bx= index s1 (i1)
;       dx = index s2 (i2)
;       cx = number of bytes to move (count)
;
;Output:
;       count bytes from s1(i1) moved to the location starting at s2(i2)
;
;Registers:
;       none
;
;--------------------------------------------------------
MoveRight       proc            near

                jcxz    @@98    ; exit if count =0

                push    cx      ;save modified registers
                push    di
                push    si

                add     si,bx   ; index into source string
                add     di,dx   ; index into destination string

                add     si,cx   ; adjust to last source byte??????????????????????
                dec     si

                add     di,cx   ; adjust to last destination byte????????????????
                dec     di

                std             ; auto decrement on
                rep     movsb   ;move while cx!=0

                pop     si      ;restore registers
                pop     di
                pop     cx
@@98:
                ret     ; return to calling program
MoveRight       endp

;------------------------------------------------------
; StrNull procedure
;
;Input:
;       di=address of string (s)
;
;Output:
;       s(0) <- null character (ASCII 0)
;
;Registers:
;       none
;
;--------------------------------------------------------
StrNull        proc            near

               mov      byte ptr[di],ASCNull; insert null at s(0)

               ret     ; return to calling program
StrNull        endp


;------------------------------------------------------
; StrLength procedure
;
;Input:
;       di = address of string (s)
;
;Output:
;       cx = number of non-null characters in s
;
;Registers:
;       cx
;
;--------------------------------------------------------
StrLength        proc            near

                 push   ax      ; save modified registers
                 push   di

                 xor    al,al   ; al <- search character (null)

                 mov    cx,0ffffh       ; max search depth
                 cld                    ; auto increment on
                 repnz  scasb           ; scan for al
                                        ; while [di]!= null & cx != 0
                 not    cx              ; ones complement of cx
                 dec    cx              ; minus 1 equals length of string

                 pop    di      ; restore registers
                 pop    ax

                 ret     ; return to calling program
StrLength        endp

;------------------------------------------------------
; StrUpper procedure
;
;Input:
;       di=address of string (s)
;
;Output:
;       lowercase chars in string converted to uppercase
;
;Registers:
;       none
;
;--------------------------------------------------------
StrUpper        proc            near

                 push   ax      ; save modified registers
                 push   cx
                 push   di
                 push   si

                 call StrLength ; set cx = length of string
                 jcxz   @@97    ; exit if length =0
                 cld            ; auto increment on

                 mov    si,di   ; set si=di

@@10:
                lodsb           ; al <-s[si]; si<-si+1
                cmp     al,'a'  ; is al >= 'a'?
                jb      @@20    ; no, jump to continue scan
                cmp     al,'z'  ; is al <='z'?
                ja      @@20    ; no, jump to continue scan

                sub     al,'a'-'A'      ; convert lowercase to uppercase
@@20:
                stosb           ; s[di]<-al; di<-di+1
                loop    @@10    ;cx<-cx-1; loop if cx>0

@@97:
                pop     si
                pop     di      ; restore registers
                pop     cx
                pop     ax

                ret     ; return to calling program
StrUpper        endp

;------------------------------------------------------
; StrCompare procedure
;
;Input:
;       si=address of string 1 (s1)
;       di=address of string 2 (s2)
;
;Output:
;       flags set for conditional jump using jb, jbe, je, ja, or jae
;
;Registers:
;       none
;
;--------------------------------------------------------
StrCompare        proc            near

                 push   ax      ; save modified registers
                 push   di
                 push   si

                 cld            ; auto increment on

@@11:
                lodsb           ; al <-s[si]; si<-si+1
                scasb           ; compare al and [di]; di<-di+1
                jne     @@21    ; exit if nonequal chars found
                or      al,al   ; is al = 0? i.e. at the end of string 1
                jne     @@11    ; if no jump, else exit

@@21:
                pop     si
                pop     di      ; restore registers
                pop     ax

                ret     ; return to calling program
StrCompare      endp

;------------------------------------------------------
; StrDelete procedure
;
;Input:
;       di=address of string (s)
;       dx=index (i) of first char to delete
;       cx=number of chars to delete (n)
;
;Output:
;       n characters deleted from string at s[i]
;       Note: prevents deleting past end of string
;
;Registers:
;       none
;
;--------------------------------------------------------
StrDelete        proc            near

                 push   bx      ; save modified registers
                 push   cx
                 push   di
                 push   si
;
; bx = SourceIndex
; cx = count / len / chars to move
; dx = Index
                mov     bx,dx   ; assign string index to bx
                add     bx,cx   ; source index <-index+count
                call    StrLength       ; cx <- length(s)
                cmp     cx,bx   ; is length >index
                ja      @@12    ; if yes jump to delete chars
                add     di,dx   ; else calcualte index to string end
                mov     byte ptr[di], ASCNull   ; and inset null
                jmp     @@96    ; jump to exit
@@12:
                mov     si,di   ; make source = destination
                sub     cx,bx   ; Chars to move <- len - source index
                inc     cx      ; plus one for null at end of the string
                call    MoveLeft        ; move chars over deleted portion

@@96:
                pop     si
                pop     di      ; restore registers
                pop     cx
                pop     bx
                ret     ; return to calling program
StrDelete      endp

;------------------------------------------------------
; StrInsert procedure
;
;Input:
;       si=address of source string (s1)
;       di=address of destination string (s2)
;       note: s2 must be large enough to expand by length (s1)!
;
;Output:
;       chars from s1 inserted at s2[i]
;       s1 not changed
;
;Registers:
;       none
;
;--------------------------------------------------------
StrInsert        proc            near

                 push   ax      ; save modified registers
                 push   bx
                 push   cx
;
; ax = LenInsertion
; cx = chars to move
;
                xchg    si,di   ; exchange si and di
                call    StrLength       ; find length of si
                xchg    si,di   ; restore si and di
                mov     ax,cx   ; save length in ax
                call    StrLength       ; find length of s2
                sub     cx,dx   ; cx <- length(s2)-1+i
                inc     cx      ; cx = chars to move
;
; bx = s1 index
;
                push    dx      ; save index (dx) and si
                push    si
                mov     si,di   ; make si and di address s2
                mov     bx,dx   ;set s1 index to dx (i)
                add     dx,ax   ; set s2 index to 1+lenInsertion
                call    MoveRight ; open a hole for the insertion
                pop     si      ; restore index (dx) and si
                pop     dx

                xor     bx,bx   ; set s1 index to 0
                mov     cx,ax   ; set cx to lenInsertion
                call    MoveLeft        ; insert s1 into hole in s2

                pop     cx
                pop     bx      ; restore registers
                pop     ax
                ret     ; return to calling program
StrInsert      endp



;------------------------------------------------------
; StrConcat procedure
;
;Input:
;       si=address of source string (s1)
;       di=address of destination string (s2)
;       note: s2 must be large enough to expand by length (s1)!
;
;Output:
;       chars from s1 added to end of s2
;
;Registers:
;       none
;
;--------------------------------------------------------
StrConcat        proc            near

                 push   bx      ; save modified registers
                 push   cx
                 push   dx
;
; dx = s2 destination
;
                call    StrLength       ; cx <- length(s2)
                mov     dx,cx           ; set dx to index end of string
                xchg    si,di           ; exchange si and di
                call    StrLength       ; find the length of s1
                inc     cx              ; plus 1 includes null terminator
                xchg    si,di           ; restore si and di
                xor     bx,bx           ; source index =0
                call    MoveLeft        ; copy source string to destination

                pop     dx
                pop     cx      ; restore registers
                pop     bx
                ret     ; return to calling program
StrConcat      endp

;------------------------------------------------------
; StrCopy procedure
;
;Input:
;       si=address of source string (s1)
;       di=address of destination string (s2)
;
;Output:
;       chars in s1 copied to s2
;       NOTE: s2 must be at least length(s1) + 1 byte long
;
;Registers:
;       none
;
;--------------------------------------------------------
StrCopy        proc            near

                 push   bx      ; save modified registers
                 push   cx
                 push   dx

                xchg    si,di           ; swap si and di
                call    StrLength       ; cx <- length(s1)
                inc     cx              ; plus 1 includes null terminator
                xchg    si,di           ; restore si and di
                xor     bx,bx           ; source string index =0
                xor     dx,dx           ; destination string index = 0
                call    MoveLeft        ; copy source to destination

                pop     dx
                pop     cx      ; restore registers
                pop     bx
                ret     ; return to calling program
StrCopy      endp

;------------------------------------------------------
; StrPos procedure
;
;Input:
;       si = address of substring to find (s1)
;       di = address of target string to scan (s2)
;
;Output:
;       if zf = 1 the dx = index of substring
;       if zf = 0 then substring was not found
;       NOTE: dx is meaningless if zf = 0
;
;Registers:
;       none
;
;--------------------------------------------------------
StrPos        proc            near

                 push   ax      ; save modified registers
                 push   bx
                 push   cx
                 push   di

                call    StrLength       ; find length of target string
                mov     ax,cx           ; save length (s2) in ax
                xchg    si,di           ; swap si and di
                call    StrLength       ; find length of substring
                mov     bx,cx           ; save length (s1) in bx
                xchg    si,di           ; restore si and di
                sub     ax,bx           ; ax = length s2 - length s1, diff length between s2 and s1
                jb      @@22            ; exit if len target < len substring
                mov     dx,0ffffh       ; initialize dx to -1

@@13:
                ; ⚠️ 匹配算法：思路是把原string切断，在每段后面加null potiner，
                ; 每段长度都是target string长度，然后按target string的长度来对比是否一样。
                ; ⚠️ 边界条件： 原string - target不能小于0; dx原始值为-1，但当dx == di时，就代表全部string pos checked。
                ; ⚠️ 注意每一次对比时，dx都和found index是相等的哦！！

                inc     dx              ; for i=0 to last possible index
                mov     cl, byte ptr[bx+di]     ; save char at s2[bx] in cl
                mov     byte ptr[bx+di],ASCNull ; replace char with null, ⚠️ 为的是把string切断来匹配。
                call    StrCompare      ; compare si to altered di
                mov     byte ptr[bx+di],cl      ; restore replaced char
                je      @@22            ; jump if match found, dx = index, zf =1
                inc     di              ; else advance target string index
                cmp     dx,ax           ; when equal, all positions checked
                jne     @@13            ; continue search unless not found

                xor     cx,cx           ; substring not found reset zf=0
                inc     cx              ; to indicate no match

@@22:
                pop     di
                pop     cx      ; restore registers
                pop     bx
                pop     ax
                ret     ; return to calling program
StrPos      endp

;------------------------------------------------------
; StrRemove procedure
;
;Input:
;       si=address of substring to delete
;       di=address of target string to delete substring from
;
;Output:
;       if zf = 1 then substring removed
;       if zf = 0 then substring was not found
;       NOTE: string at si is not changed
;       NOTE: if zf=0 then string at di is not changed
;
;Registers:
;       none
;
;--------------------------------------------------------
StrRemove        proc            near

                 push   cx      ; save modified registers
                 push   dx

                 call   StrPos  ; find sunstring, setting dx=index
                 jne    @@95    ; exit if substring not found, ⚠️ if found dx is the index
                 pushf          ; save zf flag

                 xchg   si,di   ; swap si and di
                 call   StrLength       ; find length of substring ⚠️ in cx
                 xchg   si,di           ; restore si and di
                 ; ⚠️ index is set to dx, and to delete cx chars
                 call   StrDelete       ; delete cx chars at di[dx]
                 popf                   ; restore zf flag

@@95:
                pop     dx
                pop     cx      ; restore registers
                ret     ; return to calling program
StrRemove      endp

;------------------------------------------------------
; StrRead procedure
;
;Input:
;       di = address of destination string
;       cl = maximum string length EXCLUDING null terminator
;       NOTE: if cl = 0, StrRead does nothing
;       NOTE: actual variable must be cl + 1 btes long
;       NOTE: string length is limited to 255 characters
;
;Output:
;       string copied from standard input into your buffer
;
;Registers:
;       none
;
;--------------------------------------------------------
StrRead        proc            near

               or       cl,cl   ; is cl=0?
               jz       @@80    ; if yes, jump to exit

               push   ax      ; save modified registers
               push   bx
               push   dx
               push   si

               mov    [buffer.maxLen],cl        ; set max len byte
               mov    ah,0ah                    ; DOS buffered input function
               mov    dx, offset buffer.maxLen  ; address struc with ds:dx
               int    21h                       ; call DOS to read string

               xor    bh,bh                     ; clear high byte of bx
               mov    bl,[buffer.strLen]        ; bx = # chars in buffer
               mov    [bx+buffer.chars], ASCNull;⚠️ change return key to null

               mov    si, offset buffer.chars   ; address buffer with si
               call   StrCopy                   ; copy chars to user string

@@80:
                pop     si
                pop     dx      ; restore registers
                pop     bx
                pop     ax

                ret     ; return to calling program
StrRead      endp

;------------------------------------------------------
; StrWrite/Strwrite2 procedure
;
;Input:
;       di = address of  string (s)
;       cx = number of chars to write (StrWrite2 only)
;
;Output:
;       a string copied to standard output
;
;Registers: (cx is changed)
;       cx (StrWrite only)
;
;--------------------------------------------------------
StrWrite       proc            near

               call     StrLength ; set cx = length of string


               push   ax      ; save modified registers
               push   bx
               push   dx

               mov    bx,1      ; standard output handle
               mov    dx,di     ; ds:dx address string
               mov    ah,40h    ; DOS write to file or device ⚠️
               int    21h       ; call DOS on return ax = # char written

               pop     dx      ; restore registers
               pop     bx
               pop     ax

               ret     ; return to calling program
StrWrite        endp


;------------------------------------------------------
; NewLine procedure
;
;Input:
;       none
;
;Output:
;       carriage return, line feed sent to standard output
;
;Registers:(ah dl is changed)
;       ah, dl
;
;--------------------------------------------------------
NewLine       proc            near

              mov   ah,2        ; DOS write char routine
              mov   dl,ASCcr    ; load carriage return into dl
              int   21h         ; write carriage return

              mov   ah,2        ; DOS write char routine
              mov   dl,ASClf    ; load line feed into dl
              int   21h         ; write line feed

              ret     ; return to calling program
NewLine      endp

       END   ProgramStart
