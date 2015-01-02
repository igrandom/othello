;-----------------------------------------------------------------------------------;
;																					;
;																					;
;								----LOGICA FILE----									;
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
.MODEL small	                                   ; multiple data segments and multiple code segments
.STACK 2048  	                                   ; stack
SCREENW		equ 320
SCREENH		equ 200
include MAIN.INC
include LOGICA.INC
include TEKEN.INC
locatiemunt equ 640
; --- DATA SEGMENT -------------------------------------------------------------
.DATA
PUBLIC beurt
savesi 			dw 0								; savesi is om si in op te slaan							
richting		db 0								; richting is om bij te houden welke richting je uit aan het swappen bent
beurt			dw 0								; beurt is om bij te houden wie er aan de beurt is
countpos		dw 0
; ----------------------------- CODE STARTS HERE -------------------------------
.CODE
;---------------------CALCVAK-------------------;
; Uitleg: bereken van col en row van een vak    ;
;		van uit pixel locatie (COL en ROW)		;
; Parameters doorgegeven met push:              ;
;                                               ;
;-----------------------------------------------;
calcvak PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
    
    mov ax, ROW
    sub ax, 20
    mov dx, 0
    mov bx, 22
    div bx
    mov bx, 8
    mul bx
    mov ROW, ax
    mov ax, COL
    sub ax, 40
    mov dx, 0
    mov bx, 44
    div bx
    mov bx, ROW
    add ax, bx
    mov VAK, ax
    
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
calcvak ENDP
;-----------------------------------------------;

;--------------------SWITCHBEURT----------------;
; Uitleg: beurt omzetten                        ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;-----------------------------------------------;
switchbeurt PROC NEAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 


    mov ax, beurt							;zet je beurt in ax
    mov ah, 0
	cmp ax, 1
										;vergelijk beurt met 1
		je naarblack						;true: naar black
		jmp naarwhite						;false: naar white
	
	;----naar black----
	naarblack:
		mov ax, 2
		mov beurt, ax
		jmp done
	;----end naar black----

	;----naar white----
	naarwhite:
		mov ax, 1
		mov beurt, ax
		jmp done
	;-----end naar white----
	
	;----done----
	done:


	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
switchbeurt ENDP
;-----------------------------------------------;

;-----------verplaats juiste richting-----------;
; Uitleg: berekening van mogelijke zetten       ;
; Parameters doorgegeven met push:              ;
;             - richting 	[2]                 ;
;             - vak 		[0]                 ;
;-----------------------------------------------;
juisterichting PROC FAR
	push bp
	mov bp, sp
	push dx
	push es
	push ax 

		mov cx, [bp+6][2]
		mov dx, [bp+6][0]	
    	verplaatsjuisterichting:
		cmp cx, 1
			je verplaatsrechtsboven
		cmp cx, 2
			je verplaatsmiddenboven
		cmp cx, 3 
			je verplaatslinksboven
		cmp cx, 4
			jne @F
			jmp verplaatslinksmidden
		@@:
		cmp cx, 5
			jne @F
			jmp verplaatsrechtsmidden
		@@:
		cmp cx, 6
			jne @F
			jmp verplaatslinksonder
		@@:
		cmp cx, 7
			jne @F
			jmp verplaatsmiddenonder
		@@:
		cmp cx, 8
			jne @F
			jmp verplaatsrechtsonder
		@@:
			jmp donejr
	
	
	verplaatsrechtsboven:
		push dx
		mov ax, dx
		mov dx, 0
		mov bx, 8
		div bx
		cmp ax, 0
				jne @F
				pop dx
				jmp	donejr
		@@:
			cmp dx, 7
				jne @F
				pop dx
				jmp donejr
		@@:		
		pop dx
		sub dx, 7
		mov bx, dx
		jmp vergelijkvak
	
	verplaatsmiddenboven:
		push dx
		mov ax, dx
		mov dx, 0
		mov bx, 8
		div bx
		cmp ax, 0
				jne @F
				pop dx
				jmp	donejr
		@@:
		pop dx
		sub dx, 8
		mov bx, dx
		jmp vergelijkvak
	
	verplaatslinksboven:
		push dx
		mov ax, dx
		mov dx, 0
		mov bx, 8
		div bx
		cmp ax, 0
				jne @F
				pop dx
				jmp	donejr
		@@:
		cmp dx, 0
				jne @F
				pop dx
				jmp	donejr
		@@:
		pop dx
		sub dx, 9
		mov bx, dx
		jmp vergelijkvak
	
	verplaatslinksmidden:
		push dx
		mov ax, dx
		mov dx, 0
		mov bx, 8
		div bx
		cmp dx, 0
				jne @F
				pop dx
				jmp	donejr
		@@:
		pop dx
		sub dx, 1
		mov bx, dx
		jmp vergelijkvak
	
	verplaatsrechtsmidden:
		push dx
		mov ax, dx
		mov dx, 0
		mov bx, 8
		div bx
		cmp ax, 7
				jne @F
				pop dx
				jmp	donejr
		@@:
		pop dx
		add dx, 1
		mov bx, dx
		jmp vergelijkvak
	
	verplaatslinksonder:
		push dx
		mov ax, dx
		mov dx, 0
		mov bx, 8
		div bx
		cmp ax, 7
				jne @F
				pop dx
				jmp	donejr
		@@:
		cmp dx, 0
				jne @F
				pop dx
				jmp	donejr
		@@:
		pop dx
		add dx, 7
		mov bx, dx
		jmp vergelijkvak
	
	verplaatsmiddenonder:
		push dx
		mov ax, dx
		mov dx, 0
		mov bx, 8
		div bx
		cmp ax, 7
				jne @F
				pop dx
				jmp	donejr
		@@:
		pop dx
		add dx, 8
		mov bx, dx
		jmp vergelijkvak
	
	verplaatsrechtsonder:
		push dx
		mov ax, dx
		mov dx, 0
		mov bx, 8
		div bx
		cmp ax, 7
				jne @F
				pop dx
				jmp	donejr
		@@:
		cmp dx, 7
				jne @F
				pop dx
				jmp	donejr
		@@:
		pop dx
		add dx, 9
		mov bx, dx
		jmp vergelijkvak
		
	donejr:
		mov cx, 0
		
	vergelijkvak:
		
	pop ax
	pop es
	pop dx
	pop bp
	ret 4   	
juisterichting ENDP
;-----------------------------------------------;

;--------------BEREKEN POSSIBLE NEW-------------;
; Uitleg: berekening van mogelijke zetten       ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;-----------------------------------------------;
berekenpossible PROC FAR
    push bp
    mov bp, sp
    push dx
    push es
    push cx
    push ax 
    push bx
    push si

   		mov si, 0
   		possibleloop:
   			cmp si, 64
   				jne @F
   				jmp eindeloop
   			@@:
   				cmp speelveld[si], 1
   					je @F
   				cmp speelveld[si], 2
   					je @F
   				jmp richtingloopstart
   			@@:
   				jmp possibleeinde
   				
   			richtingloopstart:
   			mov dx, 0
   			mov speelveld[si], 0
   			richtingloop:
   				inc dx
   				cmp dx, 9
   					jne @F
   					inc si
   					jmp possibleloop
   				@@:
   				push dx
   				push si
   				call juisterichting				;cx: richting, bx: vak
   				cmp cx, 0
   					jne @F
   					jmp richtingloop
   				@@:
   				mov di, bx
   				mov al, 1
   				cmp speelveld[di], al
   					je zwartloop
   				mov al, 2
   				cmp speelveld[di], al
   					je witloop	
   					jmp richtingloop
   					
   				zwartloop:
   					z2:
   					push dx
   					push bx
   					call juisterichting
   					cmp cx, 0
   						je richtingloop
   					mov di, bx
   					cmp speelveld[di], 1
   						je z2
   					cmp speelveld[di], 2
   						je zetpossiblezwart		;zet een mogelijk zwart in het originele vakje
   					jmp richtingloop
   					
   				witloop:
   					w2:
   					push dx
   					push bx
   					call juisterichting
   					cmp cx, 0
   						je richtingloop
   					mov di, bx
   					cmp speelveld[di], 2
   						je w2
   					cmp speelveld[di], 1
   						je zetpossiblewit		;zet een mogelijk wit in het originele vakje
   					jmp richtingloop
   					
   				
   		zetpossiblewit:
   			mov di, si
   			cmp speelveld[di], 4
   				push si
   				call setvakpossibleboth
   				jmp richtingloop
   			cmp speelveld[di], 0
   				push si
   				call setvakpossiblewhite
   				jmp richtingloop
   				
   				
   		zetpossiblezwart:
   			mov di, si
   			cmp speelveld[di], 3
   				push si
   				call setvakpossibleboth
   				jmp richtingloop
   			cmp speelveld[di], 0
   				push si
   				call setvakpossibleblack
   				jmp richtingloop
   					
   		possibleeinde:
   			inc si
   			jmp possibleloop
   				
   		eindeloop:			
   				
                        
    pop si
    pop bx
    pop ax
    pop cx
    pop es
    pop dx
    pop bp
berekenpossible ENDP
;-----------------------------------------------;

;------------------countpossible----------------;
; Uitleg: tellen van mogelijke zetten           ;
;         om te kijken of het spel eindigt      ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;-----------------------------------------------;
countpossible PROC NEAR
    push bp
	mov bp, sp
	push dx
	push es
	push cx
	push ax 
	push bx
	
	mov si, 0               	
	
	looper:						; einde van speelveld?
		cmp si, 64				
			je eindeloop				; ga naar eindeloop
		mov ax, 0
		mov al, [speelveld+si]
		mov bx, beurt
		mov bh, 0
		cmp bx, 1					;beurt is wit
			je witbeurt					; ga naar beurt wit
			jmp zwartbeurt				; anders naar beurt zwart

	witbeurt:					; wit beurt	
		cmp ax, 3					; is er een pw?
			je pluseen
		cmp ax, 5					; of een pa?
			je pluseen
			inc si
			jmp looper					; loopverder

	zwartbeurt:					; zwart beurt
		cmp ax, 4					; is er een pb?		
			je pluseen				
		cmp ax, 5					; of een pa?
			je pluseen
			inc si
			jmp looper

	pluseen:					; tel een op bij countpos
		mov dx, countpos	
		add dx, 1
		mov countpos, dx
		inc si
		jmp looper

	eindeloop:

    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
countpossible ENDP
;-----------------------------------------------;

;--------------------WHO WON--------------------;
; Uitleg: tellen van mogelijke zetten           ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;-----------------------------------------------;
whowon PROC NEAR
    push bp
	mov bp, sp
	push dx
	push es
	push cx
	push ax 
	push bx
	mov dx, 0				;witte coins
	mov cx, 0				;zwarte coins

	mov si, 0
	looper2:
		cmp si, 64
			je eindeloop
		mov ax, 0
		mov al, [speelveld+si]
		cmp ax, 1
			je pluswhite
		cmp ax, 2
			je plusblack
			inc si
			jmp looper2

	pluswhite:
		inc dx
		inc si
		jmp looper2

	plusblack:
		inc cx
		inc si
		jmp looper2
		
	eindeloop:
	
    
    cmp cx, dx
    	ja blackwon
    cmp cx, dx
    	je bothwon
    	jmp whitewon
    
    blackwon:					;zwart heeft gewonnen
    	mov ax, locatiemunt
    	push ax
		mov ax, 0
		push ax
		call printCircle
    	jmp einde
    
    bothwon:					;Beide spelers hebben gewonnen
    	mov ax, locatiemunt	 	;Zwarte Munt
    	sub ax, 25
    	push ax
		mov ax, 0
		push ax
		call printCircle
	
    	mov ax, locatiemunt 	;Witte Munt
    	push ax					
		mov ax, 15
		push ax
		call printCircle							
    	jmp einde
    
    whitewon:					;wit heeft gewonnen
    	mov ax, locatiemunt
    	push ax
		mov ax, 15 ; kleur
		push ax
		call printCircle
	    jmp einde 
    
    einde: 
		mov ax, locatiemunt			;won plaatsen
		add ax, 25					; 25 px from coin
		push ax
		call printWON			; call it
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
whowon ENDP
;-----------------------------------------------;

;-------------------countcoins------------------;
; Uitleg: tellen van stenen                     ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;-----------------------------------------------;
countcoins PROC NEAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	mov dx, 0				;witte coins
	mov cx, 0				;zwarte coins

	mov si, 0
	looper2:
		cmp si, 64
			je eindeloop
		mov ax, 0
		mov al, [speelveld+si]
		cmp ax, 1
			je pluswhite
		cmp ax, 2
			je plusblack
			inc si
			jmp looper2

	pluswhite:
		inc dx
		inc si
		jmp looper2

	plusblack:
		inc cx
		inc si
		jmp looper2

	eindeloop:
	mov bx, 6000 
	push bx
	mov bx, 0
	push bx
	call printCircle
	
	mov bx, 7305
	push bx
	push cx
	mov bx, 0
	push bx
	call printNumber

	mov bx, 12400 
	push bx
	mov bx, 15
	push bx
	call printCircle
	
	mov bx, 13705
	push bx
	push dx
	mov bx, 15
	push bx
	call printNumber
	
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
countcoins ENDP
;-----------------------------------------------;

;--------------------drawcoins------------------;
; Uitleg: tekenen van coins (oproepen)          ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;-----------------------------------------------;
drawcoins PROC FAR
	push bp
	mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push si
    
    mov si, 0
    looper3:
        cmp si, 64
            je eindeloop
        mov ax, 0
        mov al, [speelveld+si]
        cmp ax, 0
            je dleeg
        cmp ax, 1
            je dwhite
        cmp ax, 2
            je dblack
        cmp ax, 3   
            je dposwhite
        cmp ax, 4
            je dposblack
        cmp ax, 5
            je dpos
            inc si
            jmp looper3
            
    dleeg:
        push si
        call DRAWEM
        inc si
        jmp looper3

    dwhite:
        push si
        call DRAWEM
        push si
        call Wcoin
        inc si
        jmp looper3

    dblack:
        push si
        call DRAWEM
        push si
        call Bcoin
        inc si
        jmp looper3

    dposwhite:
    	mov bx, beurt
        cmp bx, 1
            je dpos
            jmp dleeg                   ;!!!!!!!!!!!!!!!!!!!!!

    dposblack:
    	mov bx, beurt
        cmp bx, 2
            je dpos
            jmp dleeg

    dpos:
        push si
        call drawpos
        inc si
        jmp looper3

	eindeloop:
    pop si
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
	ret 0
drawcoins ENDP
;-----------------------------------------------;

;--------------------GAMELOOP-------------------;
; Uitleg: gameloop                              ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;   VAK OMZETTEN !!!                            ;
;-----------------------------------------------;
gameloop PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

	    
    mov ax, 2
    mov beurt, 2
    
	;----start loop----
	startloop:
    	call mousereader

    	mov ax, beurt 					;kijk wie er aan de beurt is 
    	cmp ax, 1
    		je beurtwhite
    		jmp beurtblack
	;----end startloop

	;----beurt wit----
	beurtwhite: 						;kijk of het vakje een pw is, is het possible? 
		mov bx, VAK
		mov al, [speelveld+bx]
		cmp al, 3						
			je vakjepossible			;True: ga naar vakje possible
			jmp bothcmp					;False: kijk of het bothcmp is
	;----end beurt wit-----

	;----beurt zwart----
	beurtblack:
		mov bx, VAK
		mov al, [speelveld+bx]						;kijk of het vakje een pb is, is het possible? 
		cmp al, 4
			je vakjepossible			;True: ga naar vakje possible
			jmp bothcmp					;False: kijk of het bothcmp is
	;----end beurt zwart----
	
	;----both compare----
	bothcmp:
		mov bx, VAK
		mov al, [speelveld+bx]
		jmp vakjepossible
		;cmp al, 5						;kijk of het vakje pa, is het possible?
			;je vakjepossible			;True: ga naar: vakje possible
			;jmp startloop				;False: start opnieuw met gameloop
	;----eind both compare----

	;----vak possible----
	vakjepossible:						; als vakje is possible
		mov ax, beurt
		cmp ax, 1						;kijk wie er aan de beurt is
			je placewhite
			jmp placeblack
	;----end vak possible----

	;----plaats wit----
	placewhite:						;teken white coin
    	mov ax, VAK
    	push ax
   	 	call setvakwhite				; zet dit in de array
   	 	jmp startswap					; start swappen
   	 ;----eind plaats wit----
   	 
    ;----plaats zwart----
    placeblack:						; teken black coin
        mov ax, VAK
        push ax
        call setvakblack				;zet dit in de array
        jmp startswap					;start swappen
	;----end plaats zwart-----
    
    ;----start swap----
    startswap:
    mov cx, 0
    swaploop:
    	inc cx
    	cmp cx, 9
    		je @F
    	push cx
    	mov ax, VAK
    	push ax
    	call swap
    	jmp swaploop
    @@:
    
        ;call berekenpossible			;bereken welke possible zijn
        call countcoins					;tel het aantal muntjes
        
        call switchbeurt				;verander van beurt
        call resetmouse
        call drawcoins					;teken de muntjes op het veld
        mov ax, 0
        mov al, blackcoins
        mov bl, whitecoins
        add al, bl
        cmp ax, 64
        	je endgame
        	
        ;call countpossible				; tel het aantal possible
        ;mov ax, countpos	
        ;cmp ax, 0						; als nul teken spel opnieuw
        ;	je endgame				
        	jmp startloop
        ; cancel
    ;----end start swap----
    
    
    endgame	:
    	call whowon
    	
    cancel:

	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
gameloop ENDP
;-----------------------------------------------;
;--------------------reset mouse----------------;
; Uitleg: zorg er voor dat de muis uit het      ;
;         het te tekenen gebied is	            ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;-----------------------------------------------;
resetmouse PROC NEAR
push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
	mov ax, 04h
	mov cx, 550
	mov dx, 170
	int 33h
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
resetmouse ENDP
;-----------------------------------------------;
;--------------------SWAP-----------------------;
; Uitleg: draai stenen                          ;
; Parameters doorgegeven met push:              ;
;             - richting	[2]                 ;
;   		  - vak 		[0]                 ;
;-----------------------------------------------;
swap PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
	
	mov cx, [bp+6][2]
	mov bx, [bp+6][0]
	start:
	push cx
	push bx
	call juisterichting
	
	
	cmp cx, 0
	 	jne @F
	 	jmp done
	 @@:
	 jmp vergelijkvak
	 		
	vergelijkvak:	
		mov ax, beurt
		mov ah, 0
		cmp ax, 1
			je @F
			jmp vergelijkzwart
	
	@@:
			mov ax, 0
			mov al, [speelveld+bx]
			cmp ax, 1	
				jne @F
				jmp swapstart
			@@:
			cmp ax, 2
				jne @F
				jmp start
			@@:
			jmp done
		
	vergelijkzwart:
			mov ax, 0
			mov al, [speelveld+bx]
			cmp ax, 2
				jne @F
				jmp swapstart
		@@:
			cmp ax, 1
				jne @F
				jmp start
			@@:
				jmp done
				
	swapstart:	
		cmp cx, 1
			je richting1
		cmp cx, 2
			je richting2
		cmp cx, 3
			je richting3
		cmp cx, 4
			je richting4
		cmp cx, 5
			je richting5
		cmp cx, 6
			je richting6
		cmp cx, 7
			je richting7
		cmp cx, 8
			je richting8
	
	richting1:
		mov cx, 6
		jmp @F
	richting2:
		mov cx, 7
		jmp @F
	richting3:
		mov cx, 8
		jmp @F
	richting4:
		mov cx, 5
		jmp @F
	richting5:
		mov cx, 4
		jmp @F
	richting6:
		mov cx, 1
		jmp @F
	richting7:
		mov cx, 2
		jmp @F
	richting8:
		mov cx, 3
		jmp @F
	
	@@:
	
	swapvergelijk:
		push cx
		push bx
		call juisterichting 
		mov ax, beurt
		cmp ax, 1
			je swapwit
			jmp swapzwart
	
	swapwit:
			mov ax, 0
			mov al, [speelveld+bx]
			cmp ax, 1
				jne @F
				jmp done
			@@:
				push bx
				call setvakwhite
				jmp swapvergelijk
	swapzwart:
			mov ax, 0
			mov al, [speelveld+bx]
			cmp ax, 2
				jne @F
				jmp done
			@@:
				push bx
				call setvakblack
				jmp swapvergelijk
	
	
	done:
		
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 4   	
swap ENDP
;-----------------------------------------------;

END



