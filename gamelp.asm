; ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------


include DRAWR.INC
include MOUSRDR.INC
include GAMELP.INC
include DRAWBW.INC

; --- MACROS AND CONSTANTS -----------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200
beurt		equ 2

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

switchbeurt PROC NEAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

mov ax, beurt
cmp beurt 1
je naarblack
jmp naarwhite

:naarblack
mov beurt, 2

:naarwhite
mov beurt, 1

	
;-------------------------------
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	gameloop ENDP
;----------------------------------------------------------------------------------

gameloop PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------
:startloop
call mousrdr
; nu staat vaknummer in VAK

mov ax, beurt 		;kijk wie er aan de beurt is 
cmp ax, 1
je beurtwhite
jmp beurtblack
;-----------------


:beurtwhite 		;als het vakje een pw is is het possible 
mov ax, VAK
cmp ax, 3
je vakjepossible
jmp bothcmp			;kijk of het bothcmp is
;-----------------


:beurtblack
mov ax, VAK			;als het vakje een pb is is het possible 
cmp ax, 4
je vakjepossible
jmp bothcmp			;kijk of het bothcmp is
;-----------------

:bothcmp
mov ax, VAK
cmp ax, 5			;als het vakje een pa is is het possible 
je vakjepossible
jmp startloop		;start opnieuw met gameloop

;-----------------

:vakjepossible		; als vakje is possible
cmp ax 1			;kijk wie er aan de beurt is
je placewhite
jmp placeblack

;-----------------

:placewhite			;plaats wit
mov ax, VAK			
push ax
call Wcoin			;teken white coin
mov ax, VAK
push ax
call setvakwhite	; zet dit in de array
jmp startswap		; start swappen

;-----------------

:placeblack			;plaats zwart
mov ax, VAK
push ax
call Bcoin			; teken black coin
mov ax, VAK
push ax
call setvakblack	;zet dit in de array
jmp startswap		;start swappen

;-----------------

:startswap			;start swappen
	
;-------------------------------
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	gameloop ENDP
    