; ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------

include L.INC
include R.INC

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
	;lijn boven
	
	call printRectangle
	
	 	mov ax, 6098
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 2
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 176 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
	
							;zet kleur in thisDrawing
	mov al, 0 ; kleur
	mov [thisDrawing + 6], al
	
	call printRectangle
	
	;-------------------------------
	;lijn links	
	
 	mov ax, 6098
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 176
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 2 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
	
							;zet kleur in thisDrawing
	mov al, 0 ; kleur
	mov [thisDrawing + 6], al
	
	
	
	;-------------------------------
	;lijn rechts
	
		call printRectangle
	
	 	mov ax, 6274
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 176
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 2 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
	
							;zet kleur in thisDrawing
	mov al, 0 ; kleur
	mov [thisDrawing + 6], al
	
	call printRectangle
	
	;--------------------------------
	;lijn onder
	
		 	mov ax, 61460
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 2
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 176 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
	
							;zet kleur in thisDrawing
	mov al, 0 ; kleur
	mov [thisDrawing + 6], al
	
	call printRectangle
	
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	printlines ENDP
    
    END