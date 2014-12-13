      
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
	bCoin ENDP
	
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