; ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------

include B.INC
include R.INC
include P.INC

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


calcposition PROC FAR
    push bp
    mov bp, sp
    push bx
    push cx
    push dx
    push es
    mov ax, [bp+4][0]
    mov dx, 0
    mov bx, 8
    div bx; DX = rest, AX = quotient
    mov bx, dx
    mov dx, 0
    mov cx, 6400
    mul cx;   - mul quotitent with 6400
    mov cx, ax
    
    mov ax, bx
    mov bx, 20
    mul bx
    
    mov dx, ax
    mov ax, cx
    
    add ax, PLAYFIELD
    add ax, dx
    
    pop es
    pop dx
    pop cx
    pop bx
    pop bp
    ret 0
calcposition ENDP


printTile PROC NEAR
	
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
	
	
    						;zet hoogte in thisDrawing
    mov ax, 20
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 20 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
	
							;zet kleur in thisDrawing
	mov al, 2 ; kleur
	mov [thisDrawing + 6], al
	
	
	
	call printRectangle
	
	

pop ax
pop cx
pop es
pop dx
pop bx
pop bp
ret 0
printTile ENDP

printFieldLine PROC NEAR
	
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
	mov cx, 8
	
	; zet in ax start van lijn
    mov ah, [thisDrawing + 0]
    mov al, [thisDrawing + 1]
	
	lineloop:
	push cx
	
	call printTile
	
	add ax, 22
	
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
	
	
  	pop cx ; restore CX from the stack
  	dec cx ; decrement CX by 1
	jnz lineloop ; jump to loopje if dec cx did not result in 0
   
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	printFieldLine ENDP
    
    	printPlayField PROC NEAR
	
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
   
	
    mov ah, [thisDrawing + 0]
    mov al, [thisDrawing + 1]
    
   
    
	mov cx, 8
	
	fieldloop:
	push cx
	
	call printFieldLine
	
	add ax, 7040
	
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
	
	
  	pop cx ; restore CX from the stack
  	dec cx ; decrement CX by 1
	jnz fieldloop; jump to loopje if dec cx did not result in 0
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	printPlayField ENDP
	
    
    printGame PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
	call printBackground
	
	mov ax, 6420
	
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    call printPlayField
    
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	printGame ENDP
    
    END