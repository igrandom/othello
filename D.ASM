    
    .MODEL large	; multiple data segments and multiple code segments
.STACK 2048

include D.INC
include C.INC
include P.INC


; --- MACROS AND CONSTANTS -----------------------------------------------------
;Other constants	
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
    
    
    BCoin PROC FAR
    push bp
	mov bp, sp
	push dx
	push es
	push cx
	push ax 
	push bx
	;zet waarde op stack
	
		mov ax, [bp+4][0]
		push ax
	call calcposition
	
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
							;zet kleur in thisDrawing
	mov al, 0 ; kleur
	mov [thisDrawing + 6], al
	
	call printCircle
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	BCoin ENDP
	
	;------------------------------------------
    
        WCoin PROC FAR
    push bp
	mov bp, sp
	push dx
	push es
	push cx
	push ax 
	push bx
	;zet waarde op stack
	
		mov ax, [bp+4][0]
		push ax
	call calcposition
	
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
							;zet kleur in thisDrawing
	mov al, 15 ; kleur
	mov [thisDrawing + 6], al
	
	call printCircle
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	WCoin ENDP
    END