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
		mov ax, vak
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

;-----------------BEREKEN POSSIBLE--------------;
; Uitleg: berekening van mogelijke zetten       ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;-----------------------------------------------;
berekenpossible PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
	mov si, 0       
	;---- Startloop ----         	
	startloop:
		cmp si, 64
			jne @F
			jmp eindeloop
		@@:
		mov ax, 0
		mov al, [speelveld+si]
		mov savesi, si
		cmp ax, 1					;witte steen?
			jne @F
			jmp restartloop
		@@:
								; jump over
		cmp ax, 2					; zwarte steen
			jne @F
			jmp restartloop
			
				
		@@:	
		mov [speelveld+si], 0		; clear de vorige possibles, zodat hij niet kan gaan verwarren.
	;---- end Startloop ----
	
	possibleup:
			
		mov si, savesi
		mov ax, si					;nu kijken of er ergens een steen omheen staat
		mov bx, 8					; delen om te kijken of vakje aan de rand zit
		div bx						; col: dx row: ax
		cmp ax, 0					; bovenste rij?
			je possibleleft				;ga naar volgende test			
		sub si, 8
		mov dx, 0
		mov dl, [speelveld+si]
		cmp dx, 1
			jne @F
			jmp loopposblackup
		@@:
		cmp dx, 2
			jne @F
			jmp loopposwhiteup
		@@:
			jmp restartloop
	
	bup:


	possibleleft:
		mov si, savesi
		mov ax, si					;nu kijken of er ergens een steen omheen staat
		mov bx, 8					; delen om te kijken of vakje aan de rand zit
		div bx						; col: dx row: ax
		cmp dx, 0					;meest linkse kolom?
			je possibledown				; ga naar volgende test
		sub si, 1
		mov dx, 0
		mov dl, [speelveld+si]
		cmp dx, 1
			jne @F
			jmp loopposblackleft
		@@:
		cmp dx, 2
			jne @F
			jmp loopposwhiteleft
		@@:
			jmp restartloop

	bleft:

	possibledown:
		mov si, savesi
		mov ax, si					;nu kijken of er ergens een steen omheen staat
		mov bx, 8					; delen om te kijken of vakje aan de rand zit
		div bx						; col: dx row: ax
		cmp ax, 7					;meest onderste rij?
			je possibleright			; ga naar volgende test
		add si, 8
		mov dx, 0
		mov dl, [speelveld+si]
		cmp dx, 1
			jne @F
			jmp loopposblackdown
		@@:
		cmp dx, 2
			jne @F
			jmp loopposwhitedown
		@@: 
			jmp restartloop

	bdown:

	possibleright:
		mov si, savesi
		mov ax, si					;nu kijken of er ergens een steen omheen staat
		mov bx, 8					; delen om te kijken of vakje aan de rand zit
		div bx						; col: dx row: ax
		cmp dx, 7					;meest rechtse kolom?
			jne @F
			jmp restartloop
		@@:							; ga naar volgende test
			add si, 1
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 1
				jne @F
				jmp loopposblackright
		@@:
			cmp dx, 2
				jne @F
				jmp loopposwhiteright
		@@:
			jmp restartloop

	loopposblackup:		
		mov ax, si					;test of je boven aan bent	  		
		mov bx, 8
		div bx	
		cmp ax, 0
			jne @F
			jmp bup
		@@:					; zo ja volgende 
			sub si, 8					; een omlaag
			mov dx, 0
			mov dl, [speelveld+si]		;lees en zet in dx
			cmp dx, 2	
				jne @F
				jmp placeposblackup
		@@:				;is het een zwarte?			;plaats pos black
			cmp dx, 1
				jne @F
				jmp loopposblackup
		@@:					;vergelijk dx met 1			;restart loop
			jmp bup
			
	placeposblackup:
		mov si, savesi
		mov dx, 0
		mov dl, [speelveld+si]
		cmp dx, 3					; staat er al een poswit?
			je placebothup
		push si
		call setvakpossibleblack
		jmp bup

	loopposwhiteup:
		mov ax, si					;test of je boven aan bent	
		mov dx, 0  		
		mov bx, 8
		div bx
		cmp ax, 0
			jne @F
			jmp bup
		@@:						; zo ja volgende 
			sub si, 8					; een omlaag
			mov dx, 0
			mov dl, [speelveld+si]		;lees en zet in dx
			cmp dx, 1					;is het een witte?
				je placeposwhiteup			;plaats poswhite
			cmp dx, 2
				je loopposwhiteup			;restart loop
				jmp bup

		placeposwhiteup:
			mov si, savesi
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 4					;staat er al een posblack?
				je placebothup				;set pos both
			push si
			call setvakpossiblewhite
			jmp bup

		placebothup:
			mov si, savesi
			push si
			call setvakpossibleboth
			jmp bup

		loopposblackleft:
			mov ax, si					;test of je boven aan bent
			mov bx, 8
			mov dx, 0
			div bx
			cmp dx, 0
				jne @F
				jmp bleft
			@@:					;zo ja een omlaag
			sub si, 1 					;een naar links
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 2					;is het een zwarte?
				je placeposblackleft		;plaats pos black
			cmp dx, 1
				je loopposblackleft			;startloop opnieuw
				jmp bleft
					
		placeposblackleft:
			mov si, savesi
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 3					;staat er al een pos white?		
				je placebothleft			;set pos both
			push si
			call setvakpossibleblack
			jmp bleft

		loopposwhiteleft:
			mov ax, si					;test of je boven aan bent
			mov dx, 0
			mov bx, 8
			div bx
			cmp dx, 0
				jne @F
				jmp bleft
			@@:					;zo ja ga door
			sub si, 1 					;een naar links
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 1					;is het een witte?
				je placeposwhiteleft		;plaats pos white
			cmp dx, 2
				je loopposwhiteleft			;startloop opnieuw
				jmp bleft

		placeposwhiteleft:
			mov si, savesi
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 4					;staat er al een pos black?		
				je placebothleft			;set pos both
			push si
			call setvakpossiblewhite
			jmp bleft

		placebothleft:
			mov si, savesi
			push si
			call setvakpossibleboth
			jmp bleft

		loopposblackdown:
			mov ax, si					;test of je onder aan bent
			mov bx, 8
			mov dx, 0
			div bx
			cmp ax, 7
				jne @F
				jmp bdown
			@@:					;zo ja ga door
			add si, 8					;een naar beneden
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 2					;is het een zwarte?
				je placeposblackdown		;plaats pos black
			cmp dx, 1
				je loopposblackdown
				jmp bdown

		placeposblackdown:			;plaats possible black	
			mov si, savesi				;lees plaats uit
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 4					; staat er al een pw
				je placeposbothdown			; plaats dan een both
			push si	
			call setvakpossibleblack	; anders een pb
			jmp bdown					; ga verder


		loopposwhitedown:
			mov ax, si					;test of je op de onderste rij bent?
			mov bx, 8
			mov dx, 0
			div bx
			cmp ax, 7
				jne @F
				jmp bdown
			@@:					; zo ja ga naar volgende test
			add si, 8					;zo nee ga naar volgende vak
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 1					; als dit wit is
				je placeposwhitedown		;ga naar schrijf pw
			cmp dx, 2					; als dit zwart is
				je loopposwhitedown			; ga door met pw loop
				jmp bdown					;anders ga naar volgende test
		
		placeposwhitedown:
			mov si, savesi				; lees juiste vak uit
			mov dx, 0
			mov dl, [speelveld+si]		
			cmp dx, 3
				je placeposbothdown			; anders ga naar plaats pa
			push si
			call setvakpossiblewhite	; anders plaats pw
			jmp bdown

		placeposbothdown:			; plaats pa
			mov si, savesi
			push si
			call setvakpossibleboth
			jmp bdown

		loopposblackright:
			mov ax, si
			mov bx, 8
			div bx
			cmp dx, 7
				je restartloop
			add si, 1
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 2
				je placeposblackright
			cmp dx, 1
				je loopposblackright
				jmp restartloop

		placeposblackright:
			mov si, savesi
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 4
				je placeposbothright
			push si
			call setvakpossibleblack
			jmp restartloop

		loopposwhiteright:
			mov ax, si
			mov bx, 8
			mov dx, 0
			div bx
			cmp dx, 7
				je restartloop
			add si, 1
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 1
				je placeposwhiteright
			cmp dx, 2
				je loopposwhiteright
				jmp restartloop
				
		placeposwhiteright:
			mov si, savesi
			mov dx, 0
			mov dl, [speelveld+si]
			cmp dx, 3
				je placeposbothright
				push si
			call setvakpossiblewhite
			jmp restartloop

		placeposbothright:
			mov si, savesi
			push si
			call setvakpossibleboth
			jmp restartloop

		restartloop:					;restartloop
			mov si, savesi					;haal locatie er uit
			inc si							; ga naar volgende vakje
			jmp startloop					; en ga naar de start van de loop

	eindeloop:

	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
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
    	mov al, 1
        mov richting, al
        call swap
        mov al, 2
        mov richting, al
        call swap
        mov al, 3
        mov richting, al
        call swap
        mov al, 4
        mov richting, al
        call swap
        mov al, 5
        mov richting, al
        call swap
        mov al, 6
        mov richting, al
        call swap
        mov al, 7
        mov richting, al
        call swap
        mov al, 8
        mov richting, al
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



