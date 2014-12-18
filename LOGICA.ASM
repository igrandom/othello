.MODEL small	                                   ; multiple data segments and multiple code segments
.STACK 2048  	                                   ; stack
SCREENW		equ 320
SCREENH		equ 200
.DATA
.CODE

calcvak PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
    mov ax, ROW
    sub ax, 20
    mov dx, 0
    mov bx, 22
    div bx
    mov bx, 8
    mul bx
    mov ROW, ax
    mov ax, COL
    sub ax, 20
    mov dx, 0
    mov bx, 22
    div bx
    mov bx, ROW
    add ax, bx
    mov VAK, ax
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	calcvak ENDP