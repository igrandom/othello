; ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------
;

; NO EXTERNALS INCLUDES NEEDED!

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

; --- SCREEN BUFFER ------------------------------------------------------------
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing

screenBuffer	db 64000 dup(?)	; the 64000 bytes for the screen


; ----------------------------- CODE STARTS HERE -------------------------------
.CODE        ; code segment

;PROCEDURES

printLine PROC NEAR
	push bp
	mov bp, sp
	push dx
	push es
	push cx
	push ax

	
	mov cx, 0 ; zet counter op nul
	mov ah, [thisDrawing + 4] ; haal lengte uit array
	mov al, [thisDrawing + 5]
	add cx, ax ;voeg lengte toe aan counter
	push ax
    ;dec cx
	mov bx, [bp+4][0]

    mov al, [thisDrawing + 6] ;haal de kleur uit de array
	loopje:
	mov dx, 0a000h
    mov es, dx
    mov dx, 0
	mov es:[bx], al
	inc bx
	dec cx ; decrement CX by 1
    cmp cx, 0
	jnz loopje ; jump to loopje if dec cx did not result in 0
	
	pop ax
	sub bx, ax
	
	

pop ax
pop cx
pop es
pop dx
pop bp

ret 0

printLine ENDP

printRectangle PROC FAR
	
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
	
    mov bx, 0
	
	
	mov ah, [thisDrawing + 0] ; haal pixel locatie uit array
	mov al, [thisDrawing + 1] 
	mov bx, ax
	
	
	mov cx, 0 ; zet counter op nul
	mov al, [thisDrawing + 3]
	mov ah, [thisDrawing + 2] ; haal lengte uit array
	mov cx, ax ;voeg lengte toe aan counter
	
	
loopje:
	push cx
	
	push bx
	
  	call printLine ;teken lijn
	add bx, SCREENW
	
    pop cx
    pop cx ; restore CX from the stack
    dec cx ; decrement CX by 1
    cmp cx, 0 
    jnz loopje ; jump to loopje if dec cx did not result in 0
	

mov [thisDrawing + 0], bh
mov [thisDrawing + 1], bl		

pop ax
pop cx
pop es
pop dx
pop bx
pop bp
ret 0
printRectangle ENDP

END
