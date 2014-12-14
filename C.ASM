	;==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------

include R.INC
include C.INC

; --- MACROS AND CONSTANTS -----------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200

; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables
oldVideoMode	db ?
palette     db 0, 0, 0, 13, 53, 56    ; defines black and white

; --- SCREEN BUFFER ------------------------------------------------------------
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing

screenBuffer	db 64000 dup(?)	; the 64000 bytes for the screen


; ----------------------------- CODE STARTS HERE -------------------------------
.CODE  
    
    printCircle PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
	;zet locatie in ax
	;zet kleur in kleur klaar
	
	
							;zet begin locatie in thisDrawing
							
 	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1] ;lees locatie uit
 	;start tekenen
 	
 								;locatie lijn
 	
 	add ax, 6
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 1
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 6 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
	
	call printRectangle
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1]
 	
 	;--							
 	
 	sub ax, 6
 	;add ax, SCREENW
 	add ax, 4
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 1
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 10 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
    	call printRectangle
    	
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1]
	
	;--
	sub ax, 4
 	;add ax, SCREENW
 	add ax, 3
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 1
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    mov ax, 2
    
    						;zet lengte in thisDrawing
	mov ax, 12 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
    	call printRectangle
    	
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1]
	
	;--
	
	sub ax, 3
 	;add ax, SCREENW
 	add ax, 2
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 1
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 14 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
    	call printRectangle
    	
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1]
    	
    ;--
	
	sub ax, 2
 	;add ax, SCREENW
 	add ax, 1
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 2
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 16 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
    	call printRectangle
    	
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1]
    	
	;--
	
	sub ax, 1
 	;add ax, SCREENW
 	;add ax, SCREENW
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 5
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 18 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
    call printRectangle
    
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1]
	
	;--
	
 	add ax, 1
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 2
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 16 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
    call printRectangle
    
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1]
	;--
	
	sub ax, 1
 	;add ax, SCREENW
 	;add ax, SCREENW
 	add ax, 2
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 1
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 14 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
    call printRectangle
    
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1]
    ;--
	
	
	
 
	;--
	sub ax, 2
 	;add ax, SCREENW
 	add ax, 3
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 1
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    mov ax, 2
    
    						;zet lengte in thisDrawing
	mov ax, 12 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
    	call printRectangle
    	
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1]
    	;--
	
	sub ax, 3
 	;add ax, SCREENW
 	add ax, 4
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    						;zet hoogte in thisDrawing
    mov ax, 1
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 10 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
    	call printRectangle
    	
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1]
	 ;--
 								;locatie lijn
 	
 	
 	
   
 	;add ax, SCREENW
 	sub ax, 4
 	add ax, 6
 	
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
 	mov ax, 1
 	
   
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 6 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
	
	call printRectangle
	
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1]
	;--							
 	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	printCircle ENDP
    
    END