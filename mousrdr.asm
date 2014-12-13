.MODEL large	; multiple data segments and multiple code segments
.STACK 2048

include DRAWR.INC
include MOUSRDR.INC
;dd

; --- MACROS AND CONSTANTS -----------------------------------------------------
PUBLIC COL, ROW, VAK
Other constants	
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


:looped
mov ax, 03h
int 33h				;lees uit
cmp bx, 1

je clicked			 ;if bx = 1 ; if left button is down (1 = left down
jmp looped




:clicked 				;als er geklikt is
mov row, dx 			; row position
mov col, cx 			; column position

mov ax, ROW				;kijk of row boven 20 ligt
cmp ax, 20
ja comparerowbelow
jmp looped

:comparerowbelow
cmp ax, 196				;kijk of row onder 196 ligt
jb comparecolabove
jmp looped

:comparecolabove
mov ax, COL				;kijk of col boven 20 ligt
cmp ax, 20
ja comparecolbelow
jmp looped

:comparecolbelow
cmp ax, 20				;kijk of col onder 196 ligt
jb calculatevak
jmp looped


:calculatevak
call calcvak			;dan is de pijl in het veld : bereken het vakje

; nu moet er nog gekeken worden of de vakjes clickable zijn
; functie komt ergens anders te staan maar moet hier ingeladen worden: merci :)

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