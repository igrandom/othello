
include DRAWR.INC

; --- MACROS AND CONSTANTS -----------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200

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


printlines PROC FAR
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

;-------------------------------


	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	printlines ENDP
    
    END