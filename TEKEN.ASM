
; ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL small	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------


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
.CODE        ; code segment

;---------------PRINT LINE----------------------;
; Uitleg: printen van lijntjes                  ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [4]             ;
;                   - lengte    [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;

printLine PROC NEAR
	push bp
	mov bp, sp
	push dx
	push es
	push cx
	push ax

	mov cx, 0 						; zet counter op nul
	mov ax, [bp+6][2]					;haal lengte van de stack
	add cx, ax 						;voeg de lengte toe aan de counter
	push ax							
	
	mov bx, [bp+6][4]				;haal de locatie van de stack

    mov ax, [bp+6][0]				;haal de kleur van de stack
    
    ;----loopje----
	loopje:
		mov dx, 0a000h				;roep de juiste functie op om te tekenen			
    	mov es, dx
    	mov dx, 0
		mov es:[bx], ax				;zet de juiste kleur er in
		inc bx
		dec cx 						; decrement CX by 1
    	cmp cx, 0
			jnz loopje 					; jump to loopje if dec cx did not result in 0
	;----end loopje----
		
	pop ax
	sub bx, ax
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bp
	ret 0

printLine ENDP


    
;----------------------------------------------;


;---------------PRINT RECTANGLE-----------------;
; Uitleg: printen van rechthoeken               ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [6]             ;
;                   - hoogte    [4]             ;
;                   - lengte    [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;

printRectangle PROC NEAR
	
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
	
    mov bx, 0
	
	mov ax, [bp+6][6]					;haal locatie van de stack
	mov bx, ax
	
	mov cx, 0 							; zet counter op nul
	mov ax, [bp+6][4]					; haal hoogte van de stack
	mov cx, ax 							;voeg lengte toe aan counter
	
	
	;----loopje----
	loopje:
		push cx
	
		push bx							; zet locatie op de stack
		mov dx, [bp+6][2]				;haal lengte op de stack
		push dx							; en zet deze er op nieuwe op
		mov dx, [bp+6][0]				; haal kleur van de stack
		push dx							; en zet deze er op nieuw op
		
		
  		call printLine 					;roep teken teken lijn op
		add bx, SCREENW
	
    	pop cx
    	pop cx 							; restore CX from the stack
   	 	dec cx 							; decrement CX by 1
    	cmp cx, 0 
    		jnz loopje 					; jump to loopje if dec cx did not result in 0
    ;----end loopje----		

	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
printRectangle ENDP
;----------------------------------------------;

;-----------PRINT TILE--------------------------;
; Uitleg: printen van een tile                  ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [0]             ;
;       !! FIX THIS                             ;
;        Locatie moet gefixt worden             ;
;-----------------------------------------------;
printTile PROC NEAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
	
	mov ax, [bp+6][0]					; haal locatie van de stack
	push ax								; zet deze er opnieuw op
	
    mov ax, 20                      	; vakje = 20
    push ax								; zet dit op de stack
    

	mov ax, 20 							; lengte = 20
    push ax								; zet dit op de stack
	
	mov ax, 2 							; kleur = donkergroen 
	push ax								; zet op stack
	
	call printRectangle					; roep print rechthoek op
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
printTile ENDP
    
;-----------------------------------------------;

;-----------PRINT FIELDLINE---------------------;
; Uitleg: printen van een lijn van vakjes       ;
; Parameters doorgegeven met push:              ;
;                   - start van lijn (px) [0]   ;
;-----------------------------------------------;
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
    mov ax, [bp+6][0]					
	
	;----lineloop----
	lineloop:
		push cx
		
		push ax							;zet de startpixel op stack
		call printTile					;print vakje
		add ax, 22						;zet de startpixel een vakje verder
    
  		pop cx 							; restore CX from the stack
  		dec cx 							; decrement CX by 1
		jnz lineloop 					; jump to loopje if dec cx did not result in 0
   	;----end lineloop----
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
printFieldLine ENDP
;-----------------------------------------------;

;-----------PRINT PLAYFIELD---------------------;
; Uitleg: printen van het raster                ;
; Parameters doorgegeven met push:              ;
;                   - positie (px) [0]          ;
;-----------------------------------------------;
printPlayField PROC NEAR	
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
    mov ax, [bp+6][0]					;haal pixel positie van stack
    
	mov cx, 8							; zet counter op 8
	
	;----fieldloop----
	fieldloop:
		push cx
		
		push ax							; zet pixel positie op stack
		call printFieldLine
		add ax, 7040					; zet de pixel waarde een vak verder
	
  		pop cx 							; restore CX from the stack
  		dec cx 							; decrement CX by 1
		jnz fieldloop					; jump to loopje if dec cx did not result in 0
	;----end fieldloop----
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
printPlayField ENDP
;-----------------------------------------------;

;-----------PRINT BACKGROUND--------------------;
; Uitleg: printen van de achtergrond            ;
; Parameters doorgegeven met push:              ;
;                   geen                        ;
;-----------------------------------------------;
printBackground PROC FAR
	
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
	
 	mov ax, 0						;locatie = boven aan
 	push ax
 	
    mov ax, 200						;hoogte = 200
    push ax
    
	mov ax, 320 					; lengte = 320
	push ax
	
	mov ax, 6						; kleur = bruin
	push ax
	
	call printRectangle
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
printBackground ENDP
;-----------------------------------------------;

;---------------PRINT FRAME---------------------;
; Uitleg: printen van het kader om het raster   ;
; Parameters doorgegeven met push:              ;
;                   geen                        ;
;-----------------------------------------------;
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
									;lijn links:	
	
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
									;lijn rechts:
	
	call printRectangle
	
	mov ax, 6274
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    								;zet hoogte in thisDrawing
    mov ax, 176
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    								;zet lengte in thisDrawing
	mov ax, 2 						; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
									;zet kleur in thisDrawing
	mov al, 0 						; kleur
	mov [thisDrawing + 6], al
	
	call printRectangle
									;lijn onder
	
	mov ax, 61460
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
    
    								;zet hoogte in thisDrawing
    mov ax, 2
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    								;zet lengte in thisDrawing
	mov ax, 176 					; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
	
									;zet kleur in thisDrawing
	mov al, 0 						; kleur
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
;-----------------------------------------------;

;---------------PRINT GAME----------------------;
; Uitleg: printen van de game                   ;
; Parameters doorgegeven met push:              ;
;                   geen                        ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;---------------PRINT CIRCLE--------------------;
; Uitleg: printen van cirkeltjes                ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;

    printCircle PROC NEAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
										;zet begin locatie in thisDrawing
							
 	mov ah, [thisDrawing + 0] 			;lees locatie uit
 	mov al, [thisDrawing + 1] 			;lees locatie uit
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
	mov ax, 6 							; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
	
	call printRectangle
	mov ah, [thisDrawing + 0] 			;lees locatie uit
 	mov al, [thisDrawing + 1]
 	
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
	mov ax, 10 							; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
    	call printRectangle
    	
	mov ah, [thisDrawing + 0] 			;lees locatie uit
 	mov al, [thisDrawing + 1]
	
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
	mov ax, 12						 	; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
    	call printRectangle
    	
	mov ah, [thisDrawing + 0] 			;lees locatie uit
 	mov al, [thisDrawing + 1]
	
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
;-----------------------------------------------;


;---------------CALC POSITION-------------------;
; Uitleg: zet vaknummer om naar pixelpositie    ;
; Parameters doorgegeven met push:              ;
;                   - locatie (vaknummer)   [0] ;
;-----------------------------------------------;
calcposition PROC NEAR
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
;-----------------------------------------------;

;---------------PRINT BLACKCOIN-----------------;
; Uitleg: printen van zwarte coins              ;
; Parameters doorgegeven met push:              ;
;                   - locatie (vaknummer)   [0] ;
;-----------------------------------------------;

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
;-----------------------------------------------;

;---------------PRINT WHITECOIN-----------------;
; Uitleg: printen van witte  coins              ;
; Parameters doorgegeven met push:              ;
;                   - locatie (vaknummer)   [0] ;
;-----------------------------------------------;

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

;-----------------------------------------------;

;---------------PRINT EMPTY---------------------;
; Uitleg: printen van leeg vakje                ;
; Parameters doorgegeven met push:              ;
;                   - locatie (vaknummer)   [0] ;
;-----------------------------------------------;
  DRAWEM PROC FAR
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
	
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1] ;lees locatie uit
 	
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
DRAWEM ENDP
;-----------------------------------------------;

;---------------DRAW POSSIBLE-------------------;
; Uitleg: printen van possible vakje            ;
; Parameters doorgegeven met push:              ;
;                   - locatie (vaknummer)   [0] ;
;-----------------------------------------------;
   drawpos PROC  FAR
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
	
	mov ah, [thisDrawing + 0] ;lees locatie uit
 	mov al, [thisDrawing + 1] ;lees locatie uit
 	
    						;zet hoogte in thisDrawing
    mov ax, 20
    mov [thisDrawing + 2], ah
    mov [thisDrawing + 3], al
    
    						;zet lengte in thisDrawing
	mov ax, 20 ; lengte
    mov [thisDrawing + 4], ah
    mov [thisDrawing + 5], al
	
							;zet kleur in thisDrawing
	mov al, 10 ; kleur
	mov [thisDrawing + 6], al
	
	call printRectangle
	
	
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
drawpos ENDP
;-----------------------------------------------;

;---------------PRINT 0-------------------------;
; Uitleg: printen van 0                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;---------------PRINT 1-------------------------;
; Uitleg: printen van 1                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;---------------PRINT 2-------------------------;
; Uitleg: printen van 2                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;---------------PRINT 3-------------------------;
; Uitleg: printen van 3                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;---------------PRINT 4-------------------------;
; Uitleg: printen van 4                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;---------------PRINT 5-------------------------;
; Uitleg: printen van 5                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;---------------PRINT 6-------------------------;
; Uitleg: printen van 6                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;---------------PRINT 7-------------------------;
; Uitleg: printen van 7                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;---------------PRINT 8-------------------------;
; Uitleg: printen van 8                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;---------------PRINT 9-------------------------;
; Uitleg: printen van 9                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;---------------PRINT ARROW---------------------;
; Uitleg: printen van ARROW                     ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;-------------------PRINT N---------------------;
; Uitleg: printen van N                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;-------------------PRINT W---------------------;
; Uitleg: printen van W                         ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;-------------------PRINT WON-------------------;
; Uitleg: printen van WON                       ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - kleur     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;

;-------------------PRINT Number----------------;
; Uitleg: printen van een getal                 ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [2]             ;
;                   - getal     [0]             ;
;-----------------------------------------------;
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
;-----------------------------------------------;










END