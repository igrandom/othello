; ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------

;include VIDEO.INC
;include RAND.INC
;include KEYB.INC
include H.INC

; --- MACROS AND CONSTANTS -----------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200

; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables
oldVideoMode	db ?
thisDrawing 	db 0, 0, 0, 0, 0, 0 , 0
palette     db 0, 0, 0, 63, 63, 63    ; defines black and white
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

printRectangle PROC NEAR
	
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
	mov ah, [thisDrawing + 2] ; haal hoogte uit array
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

;;;;LETTERS;;;;

printN PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 1
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 7
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 5
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 7
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 4
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    printN ENDP
    
    
    ;;W PRINT
    printW PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 1
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 6
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 5
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 6
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 3
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 4
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    printW ENDP
    
    
    ;;0/O PRINT
    print0 PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 2
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 5
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 5
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    print0 ENDP
    
    
    ;;1 PRINT
    print1 PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 1
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 2
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 3
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 6
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 5
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    print1 ENDP
    
    
    ;;2 PRINT
    print2 PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 2
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 4
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 5
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    
    

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    print2 ENDP
    
    
    ;;3 PRINT
    print3 PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 2
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 2
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    
    

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    print3 ENDP
    
    
    ;;4 PRINT
    print4 PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 4
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 7
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 5
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
   

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    print4 ENDP
    
    
    
    
    
    ;;5 PRINT
    print5 PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 1
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 5
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 4
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 3
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
   

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    print5 ENDP
    




    ;;6 PRINT
    print6 PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 2
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 5
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 4
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
   

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    print6 ENDP
    
    



    ;;7 PRINT
    print7 PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 1
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 5
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 4
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 3
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    
    
   

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    print7 ENDP
    
    
    ;;8 PRINT
    print8 PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 2
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
        mov ax, bx
    add ax, 5
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
        mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    
    
   

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    print8 ENDP
    
    
    
    
    
    
    
    
    
    
    
    
        ;;9 PRINT
    print9 PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 2
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    

    
    
        mov ax, bx
    add ax, 5
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 1
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
        mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 3
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    
    
   

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    print9 ENDP
    
    
    
    
    
    
    
    
    
    
    
    
    ;;PRINT ARROW
    printarrow PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov bl, [thisdrawing + 1]
    mov bh, [thisdrawing + 0]
    ;Letter
    mov ax, bx
    add ax, 21
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 2
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 21
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 5
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    mov ax, bx
    add ax, 21
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 8
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    mov ax, bx
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 2
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 30
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    

    
    
        mov ax, bx
    add ax, 21
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 8
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
        mov ax, bx
    add ax, 21
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 5
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    mov ax, bx
    add ax, 21
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    
    mov ax, 1
    mov [thisdrawing + 3], al
    mov [thisdrawing + 2], ah
    mov ax, 2
    mov [thisdrawing + 5], al
    mov [thisdrawing + 4], ah
    call printRectangle
    
    
    
    
   

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    printArrow ENDP
    
    
    
    
    
    

    
    printWON PROC FAR
        push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
    
    
    
    
    
    mov al, [thisdrawing + 1]
    mov ah, [thisdrawing + 0]
    call printW
    add ax, 6
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call print0
    add ax, 6
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call printN

        pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    printWON ENDP
    
    
    printNumber PROC NEAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
    
    
    mov ax, [bp+4][0] ;number
    mov bx, [bp+4][2] ;location
    
    mov [thisdrawing + 1], bl
    mov [thisdrawing + 0], bh
    mov dx, 0
    push bx
    mov bx, 10
    div bx
    pop bx
    mov cx, 0
    jmp printsequence
    sseqp:
    mov cx, 1
    sseq:
    mov ax, dx
    add bx, 6
    mov [thisdrawing + 1], bl
    mov [thisdrawing + 0], bh
    
    printsequence:
    cmp ax, 0
    je s0
    cmp ax, 1
    je s1
    cmp ax, 2
    je s2
    cmp ax, 3
    je s3
    cmp ax, 4
    je s4
    cmp ax, 5
    je s5
    cmp ax, 6
    je s6
    cmp ax, 7
    je s7
    cmp ax, 8
    je s8
    cmp ax, 9
    je s9
    
    donef:
    jmp done
    
    s0:
    cmp cx, 1
    jne sseqp
    call print0
    jmp done
    s1:
    call print1
    cmp cx, 1
    je done
    jmp sseqp
    s2:
    call print2
    cmp cx, 1
    je done
    jmp sseqp
    s3:
    call print3
    cmp cx, 1
    je done
    jmp sseqp
    s4:
    call print4
    cmp cx, 1
    je done
    jmp sseqp
    s5:
    call print5
    cmp cx, 1
    je done
    jmp sseqp
    s6:
    call print6
    cmp cx, 1
    je done
    jmp sseqp
    s7:
    call print7
    cmp cx, 1
    je done
    jmp sseqp
    s8:
    call print2
    cmp cx, 1
    je done
    jmp sseqp
    s9:
    call print9
    cmp cx, 1
    je done
    jmp sseqp
    
    
    
    done:
    
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 0
    printNumber ENDP
    
    
    

	
main:
	mov	ax, @DATA
	mov	ds, ax
	mov es, ax
	
					; call Video BIOS
	mov  ah, 0 				; function 0 (set video mode)
	mov  al, 13h 			; argument 13h (mode 13h to be set)
	int  10h 

	mov  dx, offset palette ; set the palette (DAC) (offset relative to es)
    xor  bx, bx             ; set bx to zero (start at color index 0)
    mov  cx, 2             ; set color 0 and 1 (2 indexes in total)

	
mov  ax, 1012h          ; function 1012h of int 10h (set DAC palette)
    int  10h                ; call Video BIOS

    
    push cx
    push ax
    
    mov al, 10
    mov [thisdrawing + 6], al
    
    mov ax, 320
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call printW
    
    mov ax, 326
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call print0
    
    mov ax, 332
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call printN
    
    
    mov ax, 344
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call print1
    
    mov ax, 350
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call print2
    
    mov ax, 356
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call print3
    
    mov ax, 362
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call print4
    
    mov ax, 368
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call print5
    
    mov ax, 374
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call print6
    
    mov ax, 380
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call print7
    
    
    mov ax, 386
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call print8
    
    mov ax, 392
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call print9
    
    mov ax, 5000
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call printArrow
    
    mov ax, 10000
    mov [thisdrawing + 1], al
    mov [thisdrawing + 0], ah
    call printWON
    
    mov ax, 20000
    push ax
    mov ax, 5
    push ax
    call printNumber
    
    
    
    
    
    
    

	pop cx
	pop ax
	


; Exit to DOS
	mov	ax, 4c00h
	int	21h

; --- END

; _------------------------------- END OF CODE ---------------------------------
END main
