; ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------


include DRAWR.INC
include mousrdr.inc

; --- MACROS AND CONSTANTS -----------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200

; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables
PUBLIC speelveld
oldVideoMode	db ?
blackcoins 		db 0
whitecoins 		db 0
speelveld	dw 64 dub (0) ;in de inc
palette     db 0, 0, 0, 13, 53, 56    ; defines black and white
hardOffset	dw 0 ; test variable
PLAYFIELD dw 6420

; --- SCREEN BUFFER ------------------------------------------------------------
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing

screenBuffer	db 64000 dup(?)	; the 64000 bytes for the screen


; ----------------------------- CODE STARTS HERE -------------------------------
.CODE

startgame PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

call setupvakjes

;zet aantal black coins op 2
mov ax, 0
mov al, 2
mov blackcoins, al

;zet aantal white coins op 2
mov ax, 0
mov al, 2
mov whitecoins al

call mousereader



	
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	startgame ENDP

setupvakjes PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------
; in de array komt te staan wat het vakje kan zijn:
; een vakje kan leeg zijn = 0
; een vakje kan een wit bolletje hebben = 1
; een vakje kan een zwart bolletje hebben = 2
; een vakje kan een pw: 3 ; possible white
; een vakje kan een pb: 4 ; possible black
; een vakje kan een pa: 5 ; possible both
;------------------------------- 

mov ax, 0

mov al, 4
mov speelveld[20], al

mov al, 3
mov speelveld[21], al

mov al, 4
mov speelveld[27], al

mov al, 1
mov speelveld[28], al

mov al, 2
mov speelveld[29], al

mov al, 3
mov speelveld[30], al


mov al, 3
mov speelveld[35], al

mov al, 2
mov speelveld[36], al

mov al, 1
mov speelveld[37], al

mov al, 4
mov speelveld[38], al

mov al, 3
mov speelveld[44], al

mov al, 4
mov speelveld[45], al


	
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	setupvakjes ENDP
    
    END