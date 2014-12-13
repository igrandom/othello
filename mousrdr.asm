
include DRAWR.INC

; --- MACROS AND CONSTANTS -----------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200
COL 		equ 0 ; in de inc zetten!
ROW			equ 0 ; in de inc zetten!
VAK 		equ 0 ; in de inc zetten!

; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables

oldVideoMode	db ?
palette     db 0, 0, 0, 13, 53, 56    ; defines black and white
hardOffset	dw 0 ; test variable
PLAYFIELD dw 6420

; --- SCREEN BUFFER ------------------------------------------------------------
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing

screenBuffer	db 64000 dup(?)	; the 64000 bytes for the screen


; ----------------------------- CODE STARTS HERE -------------------------------
.CODE

calcvak PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

mov ax, ROW
sub ax, 20
mov dx, 0
div ax, 22
mul 8
mov ROW, ax

mov ax COL
sub ax, 20
mov dx, 0
div ax, 22
mov bx, ROW
add ax, bx
mov VAK, ax

;-------------------------------


	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	calcvak ENDP
	
	
	;--------------------MOUSEREADRER----------------------
mousereader PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------


;loop: muisloop, zolang niet geklikt

mov ax, 03h
;if bx = 1 ; if left button is down (1 = left down
; right click



int 33h
mov botton, bx

mov row, dx ; row position
mov col, cx ; column position

;if row between 20 en 196
;if col between 20 en 196
;-->then in field
;---->calcVak


;-------------------------------


	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	mousereader ENDP
    
    END