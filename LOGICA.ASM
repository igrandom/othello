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
locatiemunt equ 6000
; --- DATA SEGMENT -------------------------------------------------------------
.DATA
PUBLIC beurt
savesi 			dw 0								; savesi is om si in op te slaan							
richting		db 0								; richting is om bij te houden welke richting je uit aan het swappen bent
beurt			db 0								; beurt is om bij te houden wie er aan de beurt is
blackcoins		dw 0	
whitecoins		dw 0
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


    mov al, beurt							;zet je beurt in ax
	cmp al, 1								;vergelijk beurt met 1
		je naarblack						;true: naar black
		jmp naarwhite						;false: naar white
	
	;----naar black----
	naarblack:
		mov beurt, 2
		jmp done
	;----end naar black----

	;----naar white----
	naarwhite:
		mov beurt, 1
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
;             geen                              ;
;-----------------------------------------------;
juisterichting PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

		mov ax, 0
		mov al, richting	
    	verplaatsjuisterichting:
		cmp ax, 1
			je verplaatsrechtsboven
		cmp ax, 2
			je verplaatsmiddenboven
		cmp ax, 3 
			je verplaatslinksboven
		cmp ax, 4
			jne @F
			jmp verplaatslinksmidden
		@@:
		cmp ax, 5
			jne @F
			jmp verplaatsrechtsmidden
		@@:
		cmp ax, 6
			jne @F
			jmp verplaatslinksonder
		@@:
		cmp ax, 7
			jne @F
			jmp verplaatsmiddenonder
		@@:
		cmp ax, 8
			jne @F
			jmp verplaatsrechtsonder
		@@:
			jmp donejr
	
	
	verplaatsrechtsboven:
		mov dx, 0
		mov ax, 0
		mov bx, 8
		mov ax, VAK
		div bx
		cmp ax, 0
				jne @F
				jmp	donejr
		@@:
			cmp dx, 7
				jne @F
				jmp donejr
		@@:		
		mov bx, VAK
		sub bx, 7
		mov vak, bx
		jmp vergelijkvak
	
	verplaatsmiddenboven:
		mov dx, 0
		mov ax, 0
		mov bx, 8
		mov ax, vak
		div bx
		cmp ax, 0
				jne @F
				jmp	donejr
		@@:
		
		mov ax, VAK
		sub ax, 8
		mov vak, ax
		jmp vergelijkvak
	
	verplaatslinksboven:
		mov dx, 0
		mov ax, 0
		mov bx, 8
		mov ax, vak
		div bx
		cmp ax, 0
				jne @F
				jmp	donejr
		@@:
		cmp dx, 0
				jne @F
				jmp	donejr
		@@:
		
		mov ax, VAK
		sub ax, 9
		mov vak, ax
		jmp vergelijkvak
	
	verplaatslinksmidden:
		mov dx, 0
		mov ax, 0
		mov bx, 8
		mov ax, vak
		div bx
		cmp dx, 0
				jne @F
				jmp	donejr
		@@:
		mov ax, VAK
		sub ax, 1
		mov vak, ax
		jmp vergelijkvak
	
	verplaatsrechtsmidden:
		mov dx, 0
		mov ax, 0
		mov bx, 8
		mov ax, vak
		div bx
		cmp ax, 7
				jne @F
				jmp	donejr
		@@:
		mov ax, VAK
		add ax, 1
		mov vak, ax
		jmp vergelijkvak
	
	verplaatslinksonder:
		mov dx, 0
		mov ax, 0
		mov bx, 8
		mov ax, vak
		div bx
		cmp ax, 7
				jne @F
				jmp	donejr
		@@:
		cmp dx, 0
				jne @F
				jmp	donejr
		@@:
		mov ax, VAK
		add ax, 7
		mov vak, ax
		jmp vergelijkvak
	
	verplaatsmiddenonder:
		mov dx, 0
		mov ax, 0
		mov bx, 8
		mov ax, vak
		div bx
		cmp ax, 7
				jne @F
				jmp	donejr
		@@:
		mov ax, VAK
		add ax, 8
		mov vak, ax
		jmp vergelijkvak
	
	verplaatsrechtsonder:
		mov dx, 0
		mov ax, 0
		mov bx, 8
		mov ax, vak
		div bx
		cmp ax, 7
				jne @F
				jmp	donejr
		@@:
		cmp dx, 7
				jne @F
				jmp	donejr
		@@:
		mov ax, VAK
		add ax, 9
		mov vak, ax
		jmp vergelijkvak
		
	donejr:
		mov richting, 0
		
	vergelijkvak:
		
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0   	
juisterichting ENDP
;-----------------------------------------------;

;--------------BEREKEN POSSIBLE NEW-------------;
; Uitleg: berekening van mogelijke zetten       ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;-----------------------------------------------;
berekenpossible PROC NEAR
	mov si, 0
	
	possibleloop:
		cmp si, 64
			je einde
		mov ax, [speelveld+si]
		cmp ax, 1								;is er een steentje in een vakje?
			je bpeinde							;ga naar einde
		cmp ax, 2
			je bpeinde
		
		mov [speelveld+si], 0					;reset mogelijk andere possibles
		
		caseloop:
			mov richting, 1
			


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
	
	mov si, 0               	 ;your index
	mov al, bl              	 ;bl = byte value from your question
	mov bx, offset speelveld
	
	looper:						; einde van speelveld?
		cmp si, 64				
			je eindeloop				; ga naar eindeloop
		mov al, speelveld[bx+si]
		mov bx, 0
		mov bl, [beurt]
		cmp bx, 1					;beurt is wit
			je witbeurt					; ga naar beurt wit
			jmp zwartbeurt				; anders naar beurt zwart

	witbeurt:					; wit beurt	
		cmp al, 3					; is er een pw?
			je pluseen
		cmp al, 5					; of een pa?
			je pluseen
			jmp looper					; loopverder

	zwartbeurt:					; zwart beurt
		cmp al, 4					; is er een pb?		
			je pluseen				
		cmp al, 5					; of een pa?
			je pluseen
			jmp looper

	pluseen:					; tel een op bij countpos
		mov dx, countpos	
		add dx, 1
		mov countpos, dx
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
	
    mov ax, blackcoins
    mov bx, whitecoins
    cmp ax, bx
    	ja blackwon
    cmp ax, bx
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
			jmp looper2

	pluswhite:
		call addwhite
		jmp looper2

	plusblack:
		call addblack
		jmp looper2

	eindeloop:

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
    	mov bx, 0
        mov bl, beurt
        cmp bx, 1
            je dpos
            jmp dleeg                   ;!!!!!!!!!!!!!!!!!!!!!

    dposblack:
    	mov bx, 0
        mov bl, beurt
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

	;----start loop----
	startloop:
    	call mousereader

    	mov al, beurt 					;kijk wie er aan de beurt is 
    	cmp al, 1
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
		cmp al, 5						;kijk of het vakje pa, is het possible?
			je vakjepossible			;True: ga naar: vakje possible
			jmp startloop				;False: start opnieuw met gameloop
	;----eind both compare----

	;----vak possible----
	vakjepossible:						; als vakje is possible
		mov al, beurt
		cmp al, 1						;kijk wie er aan de beurt is
			je placewhite
			jmp placeblack
	;----end vak possible----

	;----plaats wit----
	placewhite:							;plaats wit
		mov ax, VAK			
    	push ax
    	call Wcoin						;teken white coin
    	mov ax, VAK
    	push ax
   	 	call setvakwhite				; zet dit in de array
   	 	jmp startswap					; start swappen
   	 ;----eind plaats wit----
   	 
    ;----plaats zwart----
    placeblack:							;plaats zwart
        mov ax, VAK
        push ax
        call Bcoin						; teken black coin
        mov ax, VAK
        push ax
        call setvakblack				;zet dit in de array
        jmp startswap					;start swappen
	;----end plaats zwart-----
    
    ;----start swap----
    startswap:							;start swappen
        mov richting, 1
        call swap
        mov richting, 2
        call swap
        mov richting, 3
        call swap
        mov richting, 4
        call swap
        mov richting, 5
        call swap
        mov richting, 6
        call swap
        mov richting, 7
        call swap
        mov richting, 8
        call swap

        call berekenpossible			;bereken welke possible zijn
        ;call countcoins					;tel het aantal muntjes
        ;call printNumber
        ;call switchbeurt				;verander van beurt
        ;call drawcoins					;teken de muntjes op het veld
        ;call countpossible				; tel het aantal possible
        ;mov ax, countpossible	
        ;cmp ax, 0						; als nul teken spel opnieuw
        ;	je endgame				
        	;jmp startloop
        jmp cancel
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


;--------------------SWAP-----------------------;
; Uitleg: draai stenen                          ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;   VAK OMZETTEN !!!                            ;
;-----------------------------------------------;
swap PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	start:		
	 call juisterichting
	 mov ax, 0
	 mov al, richting
	 cmp ax, 0
	 	jne @F
	 	jmp done
	 @@:
	 jmp vergelijkvak
	 		
	vergelijkvak:	
		mov bx, 0 
		mov bl, [beurt]
		cmp bx, 1
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
			cmp al, 2
				jne @F
				jmp swapstart
		@@:
			cmp ax, 3
				jne @F
				jmp start
			@@:
				jmp done
				
	swapstart:	
		mov bx, VAK
		mov ax, 0
		mov al, richting
		cmp ax, 1
			je richting1
		cmp ax, 2
			je richting3
		cmp ax, 3
			je richting3
		cmp ax, 4
			je richting4
		cmp ax, 5
			je richting5
		cmp ax, 6
			je richting6
		cmp ax, 7
			je richting7
		cmp ax, 8
			je richting8
	
	richting1:
		mov vak, 6
	richting2:
		mov vak, 7
	richting3:
		mov vak, 8
	richting4:
		mov vak, 5
	richting5:
		mov vak, 4
	richting6:
		mov vak, 1
	richting7:
		mov vak, 2
	richting8:
		mov vak, 3
	
	swapvergelijk:
		call juisterichting 
		mov bl, beurt
		cmp bl, 1
			je swapwit
			jmp swapzwart
	
	swapwit:
		mov bx, VAK
			mov al, [speelveld+bx]
			cmp al, 1
				jne @F
				jmp done
			@@:
				mov [speelveld+bx], 2
				jmp swapvergelijk
	swapzwart:
		mov bx, VAK
			mov al, [speelveld+bx]
			cmp al, 2
				jne @F
				jmp done
			@@:
				mov [speelveld+bx], 1
				jmp swapvergelijk
	
	
	done:
		
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0   	
swap ENDP
;-----------------------------------------------;

END



