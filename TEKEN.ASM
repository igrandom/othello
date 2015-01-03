;-----------------------------------------------------------------------------------;
;																					;
;																					;
;								----TEKEN FILE----									;
;																					;
;																					;
;			this includes:															;
;						- 															;
;						- 															;
;						- 															;
;						- 															;
;						- 															;
;						- 															;
;						- 															;
;						- 															;
;						- 															;
;																					;
;																					;
;-----------------------------------------------------------------------------------;
.MODEL small	; multiple data segments and multiple code segments
.STACK 2048  	; stack	
SCREENW		equ 320 
include TEKEN.INC
; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables
PUBLIC palette
PLAYFIELD       dw 6420
palette			db 768 dup(0)
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
	mov ax, [bp+4][2]					;haal lengte van de stack
	add cx, ax 						;voeg de lengte toe aan de counter
	push ax							
	
	mov bx, [bp+4][4]				;haal de locatie van de stack

    mov ax, [bp+4][0]				;haal de kleur van de stack
    
    ;----loopje----
	loopje:
		mov dx, 0a000h				;roep de juiste functie op om te tekenen			
    	mov es, dx
    	mov dx, 0
		mov es:[bx], al				;zet de juiste kleur er in
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
	ret 6
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
printRectangle PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
    push si
	
	
    mov bx, 0
	mov bx, [bp+6][6]					;haal locatie van de stack
	
	mov cx, 0 							; zet counter op nul
	mov ax, [bp+6][4]					; haal hoogte van de stack
	mov cx, ax 							;voeg lengte toe aan counter
	
	
	;----loopje----
	loopje:
		push bx							;zet locatie op de stack
		mov dx, [bp+6][2]				;haal lengte op de stack
		push dx							;en zet deze er op nieuwe op
		mov dx, [bp+6][0]				;haal kleur van de stack
		push dx							;en zet deze er op nieuw op
		
		
  		call printLine 					;roep teken teken lijn op
		add bx, SCREENW
                                        ;restore CX from the stack
   	 	dec cx 							;decrement CX by 1
    	cmp cx, 0 
    		jne loopje 					;jump to loopje if dec cx did not result in 0
    ;----end loopje----		
	
	pop si
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 8
printRectangle ENDP
;----------------------------------------------;

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
 	push ax							; zet op stack
 	
    mov ax, 200						;hoogte = 200
    push ax							; zet op stack
    
	mov ax, 320 					; lengte = 320
	push ax							; zet op stack
	
	mov ax, 6						; kleur = bruin
	push ax							; zet op stack
	
	call printRectangle				; print het vak
	
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
	
									;lijn van boven
	mov ax, 6098					;startpixel = 6098
	push ax							;push op stack		
    
    mov ax, 2						;hoogte = 2
    push ax							; zet op stack
    
	mov ax, 176 					; lengte = 176
	push ax							; zet op stack
	
	mov ax, 0 						; kleur = zwart
	push ax							; zet op stack
	
	call printRectangle				; teken dit vak
	
									;lijn links:	
 	mov ax, 6098					;startpixel = 6098
 	push ax							; zet op stack
    
    mov ax, 176						;hoogte = 176
   	push ax							; zet op stack
    
	mov ax, 2 						; lengte = 2
	push ax							; zet op stack	
					
	mov ax, 0						;kleur is zwart
	push ax							;zet op stack
									
	call printRectangle				;teken dit vak
	
									;lijn rechts:
	mov ax, 6274					;locatie
    push ax							; zet op stack
    
    mov ax, 176						;hoogte
    push ax							; zet op stack
    
	mov ax, 2 						; lengte
    push ax							; zet op stack
	mov al, 0 						; kleur
	mov ah, 0						
    push ax							; zet op stack
    
	
	call printRectangle
									;lijn onder
	
	mov ax, 61460					; locatie
    push ax							; zet op stack
    
    mov ax, 2						; hoogte
    push ax							; zet op stack
    
	mov ax, 176 					; lengte
    push ax							; zet op stack
	
	mov al, 0 						; kleur
	 mov ah, 0
    push ax							; zet op stack
    
	
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
	
	call printBackground			;print de achtergrond
    mov ax, 300
    push ax
    mov ax, 20
    push ax
    mov ax, 20
    push ax
    mov ax, 12
    push ax
    call printRectangle
	
	;mov ax, 6420					;pixellocatie van speelveld
    ;push ax							; zet op stack
    
    ;call printPlayField				;print het speelveld uit
    
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
printCircle PROC FAR
	push bp
	mov bp, sp
	push ax
    push bx
    push cx
    push dx
    push es
    push si
    
    mov dx, [bp+6][0]                   ;kleur
	mov cx, [bp+6][2]					;lees locatie van stack
    add cx, 1
    add cx, SCREENW
 	
 	add cx, 6							;locatie
    push cx								; zet op stack
    mov ax, 1							;hoogte	
    push ax								; zet op stack
	mov ax, 6 							;lengte
    push ax								; zet op stack
    push dx								;zet kleur op stack
	call printRectangle
    
 	sub cx, 2
 	add cx, SCREENW
    push cx								; zet op stack
    mov ax, 1
    push ax								; zet op stack
	mov ax, 10 							; lengte
    push ax								; zet op stack	
    push dx								;zet op stack
    call printRectangle
    
 	sub cx, 1
	add cx, SCREENW
    push cx								; zet op stack
    mov ax, 1
    push ax	
	mov ax, 12						 	;lengte
    push ax								;zet op stack
    push dx								;zet op stack
    call printRectangle
    
	sub cx, 1					;lees locatie van stack		
	add cx, SCREENW
    push cx								; zet op stack
    mov ax, 1
    push ax								; zet op stack
	mov ax, 14 ; lengte
    push ax								; zet op stack
    push dx								;zet op stack
    call printRectangle
    	
 	sub cx, 1									;start tekenen
 	add cx, SCREENW
    push cx								; zet op stack
    mov ax, 2
    push ax
	mov ax, 16 ; lengte
    push ax								; zet op stack
    push dx 							;zet op stack
    call printRectangle
    	
	sub cx, 1          					;lees locatie van stack
 	add cx, SCREENW
    add cx, SCREENW
    push cx								; zet op stack
    mov ax, 5
    push ax								; zet op stack
	mov ax, 18 ; lengte
    push ax								; zet op stack
    push dx							;zet op stack
    call printRectangle
    
    
    add cx, SCREENW
 	add cx, SCREENW
 	add cx, SCREENW
 	add cx, SCREENW
 	add cx, SCREENW
 	add cx, 1
    push cx								; zet op stack
    mov ax, 2
    push ax								; zet op stack
	mov ax, 16 ; lengte
    push ax								; zet op stack
    push dx     						;zet op stack
    call printRectangle
 	
 	add cx, SCREENW
 	add cx, SCREENW
 	add cx, 1
    push cx								; zet op stack
    mov ax, 1
    push ax								; zet op stack
	mov ax, 14 ; lengte
    push ax								; zet op stack
    push dx							    ;zet op stack
    call printRectangle
    


 	add cx, SCREENW
 	add cx, 1
    push cx
    mov ax, 1
    push ax
	mov ax, 12 ; lengte
    push ax								; zet op stack
    push dx							    ;zet op stack
    call printRectangle
    
    add cx, SCREENW
 	add cx, 1
    push cx
    mov ax, 1
    push ax								; zet op stack
	mov ax, 10                          ; lengte
    push ax								; zet op stack
    push dx 							;zet op stack
    call printRectangle
    
    add cx, SCREENW
 	add cx, 2
    push cx								; zet op stack
 	mov ax, 1
    push ax								; zet op stack		
	mov ax, 6 ; lengte
    push ax								; zet op stack
    push dx 							;zet op stack
	call printRectangle						
 	
    pop si
	pop es
    pop dx
    pop cx
    pop bx
    pop ax
	pop bp
	ret 4
	printCircle ENDP
;-----------------------------------------------;

;---------------CALC POSITION-------------------;
; Uitleg: zet vaknummer om naar pixelpositie    ;
; Parameters doorgegeven met push:              ;
;                   - locatie (vaknummer)   [0] ;
;-----------------------------------------------;
calcposition PROC FAR
    push bp
    mov bp, sp
    push bx
    push cx
    push dx
    push es
    push si
    
    ;mov ax, [bp+6][0]
    ;mov dx, 0
    ;mov bx, 8
    
    mov ax, [bp+6][0]						;haal locatie van de stack
    mov dx, 0								; zet dx op 0
    mov bx, 8								; zet bx naar 8
    div bx									; deel door bx: in DX = rest,  en in AX = quotient		
    mov bx, dx								
    mov dx, 0
    mov cx, 7040							; vermenigvuldig met het aantal pixels voor een rijvakken							
    mul cx									;  mul quotitent with 6400
    mov cx, ax								; zet dit in cx
    
    mov dx, 0
    mov ax, bx								; reken nu uit waar je precies in de rij bent
    mov bx, 22								; vermenigvuldig dit met breedte van een vak+2
    mul bx									
    
    mov dx, ax
    mov ax, cx
    
    add ax, 6420    						; tel start van playfield op bij ax
    add ax, dx								; tel daar de locatie in de lijn bij op
    
    pop si
    pop es
    pop dx
    pop cx
    pop bx
    pop bp
    ret 2
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
	push bx
	push dx
	push es
	push cx
	push ax 
    push si
	
	mov ax, [bp+6][0]						;haal locatie in vaknummers van stack
	push ax									; zet dit op de stack
	call calcposition						; bereken dit in pixels
	
    push ax									; zet op stack
							
	mov ax, 0
    push ax									; zet op stack
    
	
	call printCircle						; print de circel
	
	pop si
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 2
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
    push bx
	push dx
	push es
	push cx
	push ax 
    push si
	
    
    
    
	mov ax, [bp+6][0]						;haal locatie in vaknummers van stack
	push ax									; zet dit op de stack
	call calcposition						; bereken dit in pixels
	
    push ax									; zet op stack
											;zet kleur in thisDrawing
	mov ax, 15 ; kleur
    push ax									; zet op stack
    
    
    
	
	call printCircle
	
	pop si
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 2
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
    push bx
	push dx
	push es
	push cx
	push ax 
    push si
	
	mov ax, [bp+6][0]
    push ax
	call calcposition
	
	push ax
    mov ax, 20
    push ax									; zet op stack
	mov ax, 20 								; lengte
    push ax									; zet op stack
	mov ax, 2
    push ax									; zet op stack
	call printRectangle
	
	pop si
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 2
DRAWEM ENDP
;-----------------------------------------------;

;---------------DRAW POSSIBLE-------------------;
; Uitleg: printen van possible vakje            ;
; Parameters doorgegeven met push:              ;
;                   - locatie (vaknummer)   [0] ;
;-----------------------------------------------;
drawpos PROC FAR
    push bp
	mov bp, sp
    push bx
	push dx
	push es
	push cx
	push ax
    push si
	
	mov ax, [bp+6][0]
	
	push ax
	call calcposition
	
	push ax
 	
    mov ax, 20
    push ax									; zet op stack
    
	mov ax, 20 								; lengte
    push ax									; zet op stack
	
	mov ax, 10
    push ax									; zet op stack
    	
	call printRectangle

	pop si
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 2
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 2
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 5
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 5
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 1
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 2
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 3
    push ax									; zet op stack
    
    mov ax, 6
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 5
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 2
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 4
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 5
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    
    
    

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 2
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 2
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 4
    push ax									; zet op stack
    
    mov ax, 7
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 5
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 1
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 5
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 4
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 3
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 2
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 5
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 4
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 1
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 5
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 4
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle 
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 3
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 2
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 2
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 1
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 3
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 21
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 2
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 21
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 5
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 21
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 8
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    
    mov ax, bx
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 2
    push ax									; zet op stack
    mov ax, 30
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 21
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 8
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 21
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 5
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
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
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 2
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 1
    push ax									; zet op stack
    
    mov ax, 7
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    push ax									; zet op stack
    
    mov ax, 7
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 4
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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

    mov bx, [bp+4][2]
    ;Letter
    mov ax, bx
    add ax, 1
    push ax									; zet op stack
    
    mov ax, 6
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 5
    push ax									; zet op stack
    
    mov ax, 6
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 3
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 3
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 2
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    mov ax, bx
    add ax, 4
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    add ax, SCREENW
    push ax									; zet op stack
    
    mov ax, 1
    push ax									; zet op stack
    mov ax, 1
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printRectangle
    
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
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
    
    mov ax, [bp+4][2]						; haal locatie van de stack
    push ax									; en zet hem er opnieuw op
    mov ax, [bp+4][0]						; haal kleur van de stack
    push ax									; zet hem er opnieuw op
    call printW								; print de letter W
    add ax, 6								; ga 6 pixels verder
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call print0								; print de letter N
    add ax, 6								; ga 6 pixels verder
    push ax									; zet op stack
    mov ax, [bp+4][0]						;haal kleur van stack
    push ax									;zet hem terug op stack
    call printN								; print de letter N

    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 4
printWON ENDP
;-----------------------------------------------;

;-------------------PRINT Number----------------;
; Uitleg: printen van een getal                 ;
; Parameters doorgegeven met push:              ;
;                   - locatie   [4]             ;
;                   - getal     [2]             ;
;					- kleur 	[0]
;-----------------------------------------------;
printNumber PROC FAR
    push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
    push si
    
    mov ax, [bp+6][2] 						;haal number van stack
    mov bx, [bp+6][4] 						;haal location van stack

	push bx
	mov dx, 7
	push dx
	mov dx, 20
	push dx
	mov dx, 6
	push dx
	call printRectangle


    mov dx, 0
    push bx
    mov bx, 10
    div bx
    pop bx
    mov cx, 0
    push dx
    jmp printsequence
    
    ;----second sequence prepare----
    sseqp:
    	mov cx, 1							; zet naar tweede cijfer
    	pop dx								; haal dx terug
   		mov ax, dx							; pak tweede getal
    	add bx, 6							; tel 6 pixels op bij locatie
    	;----print sequence----
    	printsequence:						;hier in wordt gekeken welk cijfer het is
    		cmp ax, 0						; en gesprongen naar dat cijfer
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
    			jne @F
    			jmp s7
    			@@:
    		cmp ax, 8
    			jne @F
    			jmp s8
    			@@:
    		cmp ax, 9
    			jne @F
    			jmp s9
    			@@:
    			jmp done
    	;----end print sequence----
    ;----end second sequence prepare----
    
    
    ;----cijfer 0----
    s0:
    	cmp cx, 1								; kijk of het het tweede getal is
    		jne sseqp							; zo niet spring naar second sequence prepare
    		push bx								; zet locatie op stack 
    		mov dx, [bp+6][0]					; haal kleur van stack
    		push dx								; en zet hem er op
    		call print0							; en print 0
    		jmp done							; spring naar done
    ;----end cijfer 9----
    
    ;----cijfer 1----
    s1:
    	push bx									; zet locatie op stack
    	mov dx, [bp+6][0]						; haal kleur van stack
    	push dx									; en zet hem er op
    	call print1								; print het getal
    	cmp cx, 1								; kijk of het het tweede getal is
    		    jne @F
    			jmp done
    			@@:								; indien true: done
    		jmp sseqp							; indien false: ga naar second sequence prepare
    ;----end cijfer 1----		
    
    ;----cijfer 2----		
    s2:
    	push bx									; zet locatie op stack
    	mov dx, [bp+6][0]						; haal kleur van stack
    	push dx									; en zet hem er op
    	call print2								; print het getal
    	cmp cx, 1								; kijk of het het tweede getal is
    		je done								; indien true: done
    		jmp sseqp							; indien false: ga naar second sequence prepare
    ;----end cijfer 2----
    
    ;----cijfer 3----
    s3:
    	push bx									; zet locatie op stack
    	mov dx, [bp+6][0]						; haal kleur van stack
    	push dx									; en zet hem er op
    	call print3								; print het getal
    	cmp cx, 1								; kijk of het het tweede getal is
    		je done								; indien true: done
    		jmp sseqp							; indien false: ga naar second sequence prepare
    ;----end cijfer 3----
    
    ;----cijfer 4----
    s4:
    	push bx									; zet locatie op stack
    	mov dx, [bp+6][0]						; haal kleur van stack
    	push dx									; en zet hem er op
    	call print4								; print het getal
    	cmp cx, 1								; kijk of het het tweede getal is
    		je done								; indien true: done
    		jmp sseqp							; indien false: ga naar second sequence prepare
   ;----end cijfer 4---- 
    
    ;----cijfer 5----
    s5:
    	push bx									; zet locatie op stack
    	mov dx, [bp+6][0]						; haal kleur van stack
    	push dx									; en zet hem er op
    	call print5								; print het getal
    	cmp cx, 1								; kijk of het het tweede getal is
    		je done								; indien true: done
    		jmp sseqp							; indien false: ga naar second sequence prepare
    ;----end cijfer 5----
    
    ;----cijfer 6----
    s6:
    	push bx									; zet locatie op stack
    	mov dx, [bp+6][0]						; haal kleur van stack
    	push dx									; en zet hem er op
    	call print6								; print het getal
    	cmp cx, 1								; kijk of het het tweede getal is
    		je done								; indien true: done
    		jmp sseqp							; indien false: ga naar second sequence prepare
    ;----end cijfer 6----
    
    ;----cijfer 7----
    s7:
    	push bx									; zet locatie op stack
    	mov dx, [bp+6][0]						; haal kleur van stack
    	push dx									; en zet hem er op
    	call print7								; print het getal
    	cmp cx, 1								; kijk of het het tweede getal is
    		je done								; indien true: done
    		jmp sseqp							; indien false: ga naar second sequence prepare
    ;----end cijfer 7----
    
    ;----cijfer 8----
    s8:
    	push bx									; zet locatie op stack
    	mov dx, [bp+6][0]						; haal kleur van stack
    	push dx									; en zet hem er op
    	call print8								; print het getal
    	cmp cx, 1								; kijk of het het tweede getal is
    		je done								; indien true: done
    		jmp sseqp							; indien false: ga naar second sequence prepare
    ;----end cijfer 8----
    
    ;----cijfer 9----
    s9:
    	push bx									; zet locatie op stack
    	mov dx, [bp+6][0]						; haal kleur van stack
    	push dx									; en zet hem er op
    	call print9    							; print het getal
    	cmp cx, 1								; kijk of het het tweede getal is
    		je done								; indien true: done
    		jmp sseqp							; indien false: ga naar second sequence prepare
    ;----end cijfer 9----
    
    ;----done----
    done:
    pop si
    pop ax
    pop cx
    pop es
    pop dx
    pop bx
    pop bp
    ret 6
printNumber ENDP
;-----------------------------------------------;

END