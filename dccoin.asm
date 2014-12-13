; ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------

include startg.INC
include drawbw.inc
include gamelp.inc
include drawem.inc

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


countcoins PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

mov si, 0                ;your index
mov al, bl               ;bl = byte value from your question
mov bx, offset speelveld
loop:
cmp si, 64
je eindeloop

mov ax, byte ptr [bx+si]

cmp ax, 1
je pluswhite
cmp ax, 2
je plusblack
jmp loop

pluswhite:
call addwhite
jmp loop

plusblack:
call addblack
jmp loop

eindeloop:


;-------------------------------
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	countcoins ENDP
    
;-----------------------------------------------------------------
    
    drawcoins PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

mov si, 0                ;your index
mov al, bl               ;bl = byte value from your question
mov bx, offset speelveld
loop:
cmp si, 64
je eindeloop

mov ax, byte ptr [bx+si]

cmp ax, 1
je dleeg
cmp ax, 1
je dwhite
cmp ax, 2
je dblack
cmp ax, 3
je dposwhite
cmp ax, 4
je dposblack
cmp ax, 5
je dpos
jmp loop

dleeg:
push ax
call  DRAWEM
jmp loop

dwhite:
push ax
call Wcoin
jmp loop

dblack:
push ax
call Bcoin
jmp loop

dposwhite:
mov bx, beurt
cmp bx, 1
je dpos
jmp dleeg

dposblack:
mov bx, beurt
cmp bx, 2
je dpos
jmp dleeg

dpos
push ax
call drawpos
jmp loop


eindeloop:


;-------------------------------
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	drawcoins ENDP
    
    END