.MODEL small	                                   ; multiple data segments and multiple code segments
.STACK 2048  	                                   ; stack
SCREENW		equ 320
SCREENH		equ 200
.DATA
savesi 			db 0
richting		db 1
beurt			db 2
.CODE
;---------------------CALCVAK-------------------;
; Uitleg: een vakje mogelijk zwart maken        ;
; Parameters doorgegeven met push:              ;
;             - locatie (vaknummer) [0]         ;
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
    sub ax, 20
    mov dx, 0
    mov bx, 22
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

    mov ax, beurt
cmp beurt 1
je naarblack
jmp naarwhite

:naarblack
mov beurt, 2

:naarwhite
mov beurt, 1

	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
switchbeurt ENDP
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

;-------------------------------
startloop:
call mousereader
; nu staat vaknummer in VAK

mov ax, beurt 		;kijk wie er aan de beurt is 
cmp ax, 1
je beurtwhite
jmp beurtblack
;-----------------


beurtwhite: 		;als het vakje een pw is is het possible 
mov ax, VAK
cmp ax, 3
je vakjepossible
jmp bothcmp			;kijk of het bothcmp is
;-----------------


beurtblack:
mov ax, VAK			;als het vakje een pb is is het possible 
cmp ax, 4
je vakjepossible
jmp bothcmp			;kijk of het bothcmp is
;-----------------

bothcmp:
mov ax, VAK
cmp ax, 5			;als het vakje een pa is is het possible 
je vakjepossible
jmp startloop		;start opnieuw met gameloop

;-----------------

vakjepossible:		; als vakje is possible
cmp ax 1			;kijk wie er aan de beurt is
je placewhite
jmp placeblack

;-----------------

placewhite:			;plaats wit
mov ax, VAK			
push ax
call Wcoin			;teken white coin
mov ax, VAK
push ax
call setvakwhite	; zet dit in de array
jmp startswap		; start swappen

;-----------------

placeblack:			;plaats zwart
mov ax, VAK
push ax
call Bcoin			; teken black coin
mov ax, VAK
push ax
call setvakblack	;zet dit in de array
jmp startswap		;start swappen

;-----------------

startswap:			;start swappen
mov richting, 1
call swap
mov richting, 2
call swap
mov richting, 3
call swap
mov richting, 4
call swap

call berekenpossible	;bereken welke possible zijn
call countcoins			;tel het aantal muntjes
call drawscore			;teken de score die daar bij hoort	
call switchbeurt		;verander van beurt
call drawcoins			;teken de muntjes op het veld
call countpossible		; tel het aantal possible
mov ax, countpossible	
cmp ax, 0				; als nul teken spel opnieuw
je endgame				
jmp startloop


endgame	:
call whowon

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
swap PROC NEAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

mov ax, VAK
mov bx, 8
div bx
jmp setbx1
back1:					;dit veranderd
je callup

mov ax, VAK
jmp setbx12
back2:					;dit veranderd

;----------------------
loopleft:
mov bx, ax
mov dx, 0
mov bx, 8						
div bx	
jmp setbx3						
back3:						; voor up en down cmp ax voor left right cmp dx
mov ax, bx
je laststepback
mov bx, speelveld[ax]
cmp bx, 0
je callup
cmp bx, 3
je callup
cmp bx, 4
je callup
cmp bx, 5
je callup

mov bx, speelveld[ax]

cmp bx, beurt
je loopleftback
jmp setbx14
back4:					;dit veranderd per righting
jmp loopleft

;----------------------
laststepback:
mov bx, speelveld[ax]
cmp bx, beurt
jne callup
jmp loopleftback


;----------------------
loopleftback:
jmp setbx15
back5:					;dit veranderd per richting
mov bx, speelveld[ax]
cmp bx, beurt
je callup

mov dx, beurt
cmp dx, 1
je witup
jmp zwartup

;----------------------
witup:
push ax
call setvakwhite
push ax
call Wcoin
jmp callup

;----------------------
zwartup:
push ax
call setvakblack
push ax
call Bcoin
jmp callup



;----------------------
setbx1:						;bij verandering een
mov ax, richting
cmp ax, 1
je left1
cmp ax, 2
je up1
cmp ax, 3
je right1
cmp ax, 4
je down1
cmp ax, 5
je schuinlo1
cmp ax, 6
je shuinld1
cmp ax, 7
je schuinro1
jmp schuinrd1

left1:
cmp dx, 0	
jmp back1

up1:
cmp ax, 0
jmp back1

right1:
cmp dx, 7	
jmp back1

down1:
cmp ax, 7
jmp back1

schuinlo1:
cmp dx, 0
je back1
cmp ax, 0
jmp back1

schuinld1:
cmp dx, 0
je back1
cmp ax, 7
jmp back1

schuinro1:
cmp dx, 7
je back1
cmp ax, 0
jmp back1

schuinrd1:
cmp dx, 7
je back1
cmp ax, 7
jmp back1






;----------------------
setbx12:				;bij verandering twee
mov ax, richting
cmp ax, 1
je left2
cmp ax, 2
je up2
cmp ax, 3
je right2
cmp ax, 4
je down2
cmp ax, 5
je schuinlo2
cmp ax, 6
je shuinld2
cmp ax, 7
je schuinro2
jmp schuinrd2


left2:
sub ax, 1
jmp down2

up2:
sub ax, 8
jmp down2

right2:
add ax, 1
jmp down2

down2:
add ax, 8
jmp down2

schuinlo2:
sub ax, 9
jmp down2

schuinld2:
add ax, 7
jmp down2

schuinro2:
sub ax, 7
jmp down2

schuinrd2:
add ax, 9
jmp down2



;----------------------
setbx3:				;bij verandering drie
mov ax, richting
cmp ax, 1
je left3
cmp ax, 2
je up3
cmp ax, 3
je right3
cmp ax, 4
je down3
cmp ax, 5
je schuinlo3
cmp ax, 6
je shuinlo3
cmp ax, 7
je schuinlo3
jmp schuinlo3

left3:
cmp dx, 0	
jmp back3

up3:
cmp ax, 0
jmp back3

right3:
cmp dx, 0	
jmp back3

down3:
cmp ax, 0
jmp back3

schuinlo3:
cmp dx, 0
je back3
cmp ax, 0
jmp back3

schuinld3:
cmp dx, 0
je back3
cmp ax, 7
jmp back3

schuinro3:
cmp dx, 7
je back3
cmp ax, 3
jmp back3

schuinrd3:
cmp dx, 7
je back3
cmp ax, 7
jmp back3


;----------------------
setbx14:			;bij verandering vier
mov ax, richting
cmp ax, 1
je left4
cmp ax, 2
je up4
cmp ax, 3
je right4
cmp ax, 4
je down4
cmp ax, 5
je schuinlo4
cmp ax, 6
je shuinld4
cmp ax, 7
je schuinro4
jmp schuinrd4


left4:
add ax, 1
jmp down4

up4:
add ax, 8
jmp down4

right4:
sub ax, 1
jmp down4

down4:
sub ax, 8
jmp down4

schuinlo4:
add ax, 9
jmp down2

schuinld2:
sub ax, 7
jmp down2

schuinro2:
add ax, 7
jmp down2

schuinrd2:
sub ax, 9
jmp down2

;----------------------
setbx15:			;bij verandering vijf
mov ax, richting
cmp ax, 1
je left5
cmp ax, 2
je up5
cmp ax, 3
je right5
cmp ax, 4
je down5
cmp ax, 5
je schuinlo5
cmp ax, 6
je shuinld5
cmp ax, 7
je schuinro1
jmp schuinrd5


left5:
sub ax, 1
jmp down5

up5:
sub ax, 8
jmp down5

right5:
add ax, 1
jmp down5

down5:
add ax, 8
jmp down5

schuinlo5:
sub ax, 9
jmp down5

schuinld5:
add ax, 7
jmp down5

schuinro5:
sub ax, 7
jmp down5

schuinrd5:
add ax, 9
jmp down5
;----------------------
callup:

	
;-------------------------------
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
   	
swap ENDP
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

;-------------------------------


mov si, 0                	;your index
mov al, bl               	;bl = byte value from your question
mov bx, offset speelveld

;--------------------------------
startloop:
cmp si, 64
je eindeloop

mov ax, byte ptr [bx+si]
mov savesi, si

cmp ax, 1					;witte steen?
je restartloop				; jump over
cmp ax, 2					; zwarte steen
je restartloop				;jump over

mov byte ptr [bx+si], 0


;---------------
possibleup:
mov si, savesi

mov ax, si					;nu kijken of er ergens een steen omheen staat
mov bx, 8					; delen om te kijken of vakje aan de rand zit
div bx						; col: dx row: ax

cmp ax, 0					; bovenste rij?
je possibleleft				;ga naar volgende test			
sub si, 8
mov dx, byte ptr[bx+si]
cmp dx, 1
je loopposblackup
cmp dx, 2
je loopposwhiteup
jmp restartloop

bup:

;---------------
possibleleft:
mov si, savesi

mov ax, si					;nu kijken of er ergens een steen omheen staat
mov bx, 8					; delen om te kijken of vakje aan de rand zit
div bx						; col: dx row: ax

cmp dx, 0					;meest linkse kolom?
je possibledown				; ga naar volgende test
sub si, 1
mov dx, byte ptr[bx+si]
cmp dx, 1
je loopposblackleft
cmp dx, 2
je loopposwhiteleft
jmp restartloop


bleft:


;---------------
possibledown:
mov si, savesi

mov ax, si					;nu kijken of er ergens een steen omheen staat
mov bx, 8					; delen om te kijken of vakje aan de rand zit
div bx						; col: dx row: ax

cmp ax, 7					;meest onderste rij?
je possibleright			; ga naar volgende test
add si, 8
mov dx, byte ptr[bx+si]
cmp dx, 1
je loopposblackdown
cmp dx, 2
je loopposwhitedown
jmp restartloop

bdown:


;---------------
possibleright:
mov si, savesi

mov ax, si					;nu kijken of er ergens een steen omheen staat
mov bx, 8					; delen om te kijken of vakje aan de rand zit
div bx						; col: dx row: ax
	
cmp dx, 7					;meest rechtse kolom?
je restartloop				; ga naar volgende test
add si, 1
mov dx, byte ptr[bx+si]
cmp dx, 1
je loopposblackright
cmp dx, 2
je loopposwhiteright
jmp restartloop


;---------------
loopposblackup:
			
mov ax, si					;test of je boven aan bent	  		
mov bx, 8
div bx	
cmp ax, 0
je bup						; zo ja volgende 

sub si, 8					; een omlaag

mov dx, byte ptr[bx+si]		;lees en zet in dx
cmp dx, 2					;is het een zwarte?
je placeposblackup			;plaats pos black
cmp dx, 1					;vergelijk dx met 1
je loopposblackup			;restart loop
jmp bup


;-----
placeposblackup:
mov si, savesi

mov dx, byte ptr[bx+si]
cmp dx, 3					; staat er al een poswit?
je placebothup
push si
call setvakpossibleblack
jmp bup




;---------------
loopposwhiteup:
mov ax, si					;test of je boven aan bent	  		
mov bx, 8
div bx
cmp ax, 0
je bup						; zo ja volgende 

sub si, 8					; een omlaag

mov dx, byte ptr[bx+si]		;lees en zet in dx
cmp dx, 1					;is het een witte?
je placeposwhiteup			;plaats poswhite
cmo dx, 2
je loopposwhiteup			;restart loop
jmp bup


;-----
placeposwhiteup:
mov si, savesi

mov dx, byte ptr[bx+si]
cmp dx, 4					;staat er al een posblack?
je placebothup				;set pos both
push si
call setvakpossiblewhite
jmp bup

;---------------
placebothup:
mov si, savesi
push si
call setvakpossibleboth
jmp bup


;---------------
loopposblackleft:
mov ax, si					;test of je boven aan bent
mov bx, 8
div bx
cmp dx, 0
je bleft					;zo ja een omlaag

sub si, 1 					;een naar links

mov dx, bythe ptr[bx+si]
cmp dx, 2					;is het een zwarte?
je placeposblackleft		;plaats pos black
cmo dx, 1
je loopposblackleft			;startloop opnieuw
jmp bleft

;-----
placeposblackleft:
mov si, savesi

mov dx, byte ptr [bx+si]
cmp dx, 3					;staat er al een pos white?		
je placebothleft			;set pos both
push si
call setvakpossibleblack
jmp bleft

;---------------
loopposwhiteleft:
mov ax, si					;test of je boven aan bent
mov bx, 8
div bx
cmp dx, 0
je bleft					;zo ja ga door

sub si, 1 					;een naar links

mov dx, byte ptr[bx+si]
cmp dx, 1					;is het een witte?
je placeposwhiteleft		;plaats pos white
cmp dx, 2
je loopposwhiteleft			;startloop opnieuw
jmp dleft

;-----
placeposwhiteleft:
mov si, savesi

mov dx, byte ptr [bx+si]
cmp dx, 4					;staat er al een pos black?		
je placebothleft			;set pos both
push si
call setvakpossiblewhite
jmp bleft

;---------------
placebothleft:
mov si, savesi
push si
call setvakpossibleboth
jmp bleft

;---------------
loopposblackdown:
mov ax, si					;test of je onder aan bent
mov bx, 8
div bx
cmp ax, 7
je bdown					;zo ja ga door

add si, 8					;een naar beneden

mov dx, byte ptr [bx+si]
cmp dx, 2					;is het een zwarte?
je placeposblackdown		;plaats pos black
cmp dx, 1
je loopposblackdown
jmp bdown

;---------------
placeposblackdown:			;plaats possible black	
mov si, savesi				;lees plaats uit

mov dx, byte ptr [bt+si]
cmp dx, 4					; staat er al een pw
je placeposbothdown			; plaats dan een both
push si	
call setvakpossibleblack	; anders een pb
jmp bdown					; ga verder

;---------------
loopposwhitedown:
mov ax, si					;test of je op de onderste rij bent?
mov bx, 8
div bx
cmp ax, 7
je bdown					; zo ja ga naar volgende test

add si, 8					;zo nee ga naar volgende vak


mov dx, byte ptr [bx+si]	;lees uit wat daar staat
cmp dx, 1					; als dit wit is
je placeposwhitedown		;ga naar schrijf pw
cmp dx, 2					; als dit zwart is
je loopposwhitedown			; ga door met pw loop
jmp bdown					;anders ga naar volgende test

;---------------
placeposwhitedown:
mov si, savesi				; lees juiste vak uit

mov dx, byte ptr [bt+si]	;kijk of er al een pb staat			
cmp dx, 3
je placeposbothdown			; anders ga naar plaats pa
push si
call setvakpossiblewhite	; anders plaats pw
jmp bdown

;---------------
placeposbothdown:			; plaats pa
mov si, savesi
push si
call setvakpossibleboth
jmp bdown


;---------------
loopposblackright:
mov ax, si
mov bx, 8
div bx
cmp dx, 7
je restartloop

add si, 1

mov dx, byte ptr [bx+si]
cmp dx, 2
je placeposblackright
cmp dx, 1
je loopposblackright
jmp restartloop

;---------------
placeposblackright:
mov si, savesi

mov dx, byte ptr [bt+si]
cmp dx, 4
je placeposbothright
push si
call setvakpossibleblack
jmp restartloop

;---------------
loopposwhiteright:
mov ax, si
mov bx, 8
div bx
cmp dx, 7
je restartloop

add si, 1

mov dx, byte ptr [bx+si]
cmp dx, 1
je placeposwhiteright
cmp dx, 2
je loopposwhiteright
jmp restartloop

;---------------
placeposwhiteright:
mov si, savesi

mov dx, byte ptr [bt+si]
cmp dx, 3
je placeposbothright
push si
call setvakpossiblewhite
jmp restartloop



;---------------
placeposbothdown:
mov si, savesi
push si
call setvakpossibleboth
jmp restartloop

;---------------
restartloop:					;restartloop
mov si, savesi					;haal locatie er uit
add si, 1						; ga naar volgende vakje
jmp startloop					; en ga naar de start van de loop

eindeloop:

;-------------------------------
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
countpossible PROC FAR
    push bp
	mov bp, sp
	push dx
	push es
	push cx
	push ax 
	push bx
	;zet waarde op stack
	
	;------------------------------------------
    
mov si, 0               	 ;your index
mov al, bl              	 ;bl = byte value from your question
mov bx, offset speelveld
loop:						; einde van speelveld?
cmp si, 64				
je eindeloop				; ga naar eindeloop

mov ax, byte ptr [bx+si]
mov bx, beurt
cmp bx, 1					;beurt is wit
je witbeurt					; ga naar beurt wit
jmp zwartbeurt				; anders naar beurt zwart


witbeurt:					; wit beurt
cmp ax, 3					; is er een pw?
je pluseen
cmp ax, 5					; of een pa?
je pluseen
jmp loop					; loopverder

zwartbeurt:					; zwart beurt
cmp ax, 4					; is er een pb?		
je pluseen				
cmp ax, 5					; of een pa?
je pluseen
jmp loop


pluseen:					; tel een op bij countpos
mov dx, countpos	
add dx, 1
mov countpos dx.
jmp loop



eindeloop:

    
    
     
	;------------------------------------------
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
whowon PROC FAR
    push bp
	mov bp, sp
	push dx
	push es
	push cx
	push ax 
	push bx
	;zet waarde op stack
	
	;------------------------------------------
    mov ax blackcoins
    mov bx whitecoins
    
    cmp ax, bx
    ja blackwon
    cmp ax, bx
    je bothwon
    jmp whitewon
    ;--------------
    
    blackwon:					;zwart heeft gewonnen
    mov ax locatiemunt
    
     mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
								;zet kleur in thisDrawing
	mov al, 0 ; kleur
	mov [thisDrawing + 6], al
	call printCircle
    
    jmp einde
    
    ;--------------
    bothwon:
     mov ax locatiemunt
    sub ax, 25
     mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
								;zet kleur in thisDrawing
	mov al, 0 ; kleur
	mov [thisDrawing + 6], al
	call printCircle
	
	 mov ax locatiemunt
    
     mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
								;zet kleur in thisDrawing
	mov al, 15 ; kleur
	mov [thisDrawing + 6], al
	call printCircle							
    
    jmp einde
    
    ;--------------
    whitewon:					;wit heeft gewonnen
      mov ax locatiemunt
    
     mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
								;zet kleur in thisDrawing
	mov al, 15 ; kleur
	mov [thisDrawing + 6], al
	call printCircle
     
     jmp einde
     
     ;--------------
     
     einde:
     
	mov ax, locatiemunt			;won plaatsen
	add ax, 25					; 25 px from coin
	push ax					
	call wonmessage				; call it
    
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
countcoins PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

mov si, 0                ;your index
mov al, bl               ;bl = byte value from your question
mov bx, offset speelveld
loop:
cmp si, 64
je eindeloop

mov ax, byte ptr [bx+si]

cmp ax, 1
je pluswhite
cmp ax, 2
je plusblack
jmp loop

pluswhite:
call addwhite
jmp loop

plusblack:
call addblack
jmp loop

eindeloop:


;-------------------------------
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
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

mov si, 0                ;your index
mov al, bl               ;bl = byte value from your question
mov bx, offset speelveld
loop:
cmp si, 64
je eindeloop


mov ax, byte ptr [bx+si]

cmp ax, 1
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
jmp loop

dleeg:
push ax
call  DRAWEM
jmp loop

dwhite:
push ax
call Wcoin
jmp loop

dblack:
push ax
call Bcoin
jmp loop

dposwhite:
mov bx, beurt
cmp bx, 1
je dpos
jmp dleeg

dposblack:
mov bx, beurt
cmp bx, 2
je dpos
jmp dleeg

dpos
push ax
call drawpos
jmp loop


eindeloop:


;-------------------------------
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
drawcoins ENDP


