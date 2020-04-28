 name insertionsort
        page 60,80
title ascending order using insertion sort algorithm
        .model small
        .stack 64
        .data
a dw 78h,34h,12h,56h
si_ze dw ($-a)/2        ;si_ze=4(no of elements)
        .code
insort:
        mov ax,@data
        mov ds,ax
        mov cx,2        ;cx=2,insert the second element in the proper position
outlup:
        mov dx,cx
        dec dx       ;dx=cx-1,max no of comparisions needed to insert element
        mov si,dx
        add si,si
        mov ax,a[si]
inlup:
        cmp a[si-2],ax
        jbe inlupexit
        mov di,a[si-2]
        mov a[si],di
        dec si
        dec si
        dec dx
        jnz inlup
inlupexit:
        mov a[si],ax
        inc cx       ;inc cx to insert the next element in proper position
        cmp cx,si_ze
        jbe outlup
exit:
        int 3        ;breakpoint interrupt
        align 16
end insort