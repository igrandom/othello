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

locatiemunt equ 10000


; --- DATA SEGMENT -------------------------------------------------------------

.DATA
savesi dw 0								; savesi is om si in op te slaan							
richting dw 1								; richting is om bij te houden welke richting je uit aan het swappen bent
beurt dw 2								; beurt is om bij te houden wie er aan de beurt is
blackcoins dw 0	
whitecoins dw 0
countpos dw 0


; ----------------------------- CODE STARTS HERE -------------------------------
.CODE
;---------------------CALCVAK-------------------;
; Uitleg: bereken van col en row van een vak    ;
;		van uit pixel locatie (COL en ROW)		;
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


    mov ax, beurt							;zet je beurt in ax
	cmp ax, 1								;vergelijk beurt met 1
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
    
    	mov ax, beurt 					;kijk wie er aan de beurt is 
    	cmp ax, 1
    		je beurtwhite
    		jmp beurtblack
	;----end startloop

	;----beurt wit----
	beurtwhite: 						;kijk of het vakje een pw is, is het possible? 
		mov ax, VAK
		cmp ax, 3						
			je vakjepossible			;True: ga naar vakje possible
			jmp bothcmp					;False: kijk of het bothcmp is
	;----end beurt wit-----

	;----beurt zwart----
	beurtblack:
		mov ax, VAK						;kijk of het vakje een pb is, is het possible? 
		cmp ax, 4
			je vakjepossible			;True: ga naar vakje possible
			jmp bothcmp					;False: kijk of het bothcmp is
	;----end beurt zwart----
	
	;----both compare----
	bothcmp:
		mov ax, VAK
		cmp ax, 5						;kijk of het vakje pa, is het possible?
			je vakjepossible			;True: ga naar: vakje possible
			jmp startloop				;False: start opnieuw met gameloop
	;----eind both compare----

	;----vak possible----
	vakjepossible:						; als vakje is possible
		cmp ax, 1						;kijk wie er aan de beurt is
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
        call countcoins					;tel het aantal muntjes
        ;   call drawscore					;teken de score die daar bij hoort	
        call switchbeurt				;verander van beurt
        call drawcoins					;teken de muntjes op het veld
        call countpossible				; tel het aantal possible
        mov ax, countpossible	
        cmp ax, 0						; als nul teken spel opnieuw
        	je endgame				
        	jmp startloop
    ;----end start swap----
    
    
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
swap PROC FAR
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
;back1:					;dit veranderd
;je callup
back1f:
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
push bp
mov bp, ax
mov bx, speelveld[bp]
pop bp
cmp bx, 0
je z
cmp bx, 3
je z
cmp bx, 4
je z
cmp bx, 5
je z

push bp
mov bp, ax
mov bx, speelveld[bp]
pop bp

cmp bx, beurt
je loopleftback
jmp setbx14
z:
jmp e
back4:					;dit veranderd per righting
jmp loopleft

;----------------------
laststepback:
push bp
mov bp, ax
mov bx, speelveld[bp]
pop bp
cmp bx, beurt
jne e
jmp loopleftback

loopleftback:
jmp setbx15
back5:					;dit veranderd per richting
push bp
mov bp, ax
mov bx, speelveld[bp]
pop bp
cmp bx, beurt
je e

mov dx, beurt
cmp dx, 1
je witup
jmp zwartup

witup:
push ax
call setvakwhite
push ax
call Wcoin
jmp e

zwartup:
push ax
call setvakblack
push ax
call Bcoin
jmp e


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
je schuinld1
cmp ax, 7
je schuinro1
jmp schuinrd1

left1:
cmp dx, 0
je t
jmp back1f
e:
jmp t
up1:
cmp ax, 0
je t
jmp back1f

right1:
cmp dx, 7
je t
jmp back1f

down1:
cmp ax, 7
je t
jmp back1f

schuinlo1:
cmp dx, 0
je t
cmp ax, 0
je t
jmp back1f

schuinld1:
cmp dx, 0
je t
cmp ax, 7
je t
jmp back1f

schuinro1:
cmp dx, 7
je t
cmp ax, 0
je t
jmp back1f

schuinrd1:
cmp dx, 7
je t
cmp ax, 7
je callup
jmp back1f
t:
jmp callup
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
je schuinld2
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
je schuinlo3
cmp ax, 7
je schuinlo3
jmp schuinlo3
callup:
jmp done
left3:
cmp dx, 0	
jmp back3
b3:
jmp back3
up3:
cmp ax, 0
jmp b3

right3:
cmp dx, 0	
jmp b3

down3:
cmp ax, 0
jmp b3

schuinlo3:
cmp dx, 0
je b3
cmp ax, 0
jmp b3

schuinld3:
cmp dx, 0
je b3
cmp ax, 7
jmp b3

schuinro3:
cmp dx, 7
je b3
cmp ax, 3
jmp back3

schuinrd3:
cmp dx, 7
je b3
cmp ax, 7
jmp b3


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
je schuinld4
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

schuinld4:
sub ax, 7
jmp down2

schuinro4:
add ax, 7
jmp down2

schuinrd4:
sub ax, 9
jmp down2
d:
jmp schuinro1
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
je schuinld5
cmp ax, 7
je d
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

;-----------------BEREKEN POSSIBLE--------------;
; Uitleg: berekening van mogelijke zetten       ;
; Parameters doorgegeven met push:              ;
;             geen                              ;
;-----------------------------------------------;
berekenpossible PROC NEAR
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
jne @F
jmp eindeloop
@@:

push bp
mov bp, bx
mov ax, speelveld[bp+si]
pop bp
mov savesi, si

cmp ax, 1					;witte steen?
je restartloop				; jump over
cmp ax, 2					; zwarte steen
je restartloop				;jump over

push bp
mov bp, bx
mov byte ptr [bp+si], 0
pop bp


;---------------
possibleup:
mov si, savesi

mov ax, si					;nu kijken of er ergens een steen omheen staat
mov bx, 8					; delen om te kijken of vakje aan de rand zit
div bx						; col: dx row: ax

cmp ax, 0					; bovenste rij?
je possibleleft				;ga naar volgende test			
sub si, 8
push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
cmp dx, 1
je loopposblackup
cmp dx, 2
je loopposwhiteup
jmp restartloop
eindeloopfff:
jmp eindeloopff
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
push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
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
push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
cmp dx, 1
je loopposblackdown
cmp dx, 2
je loopposwhitedown
jmp restartloop

bdown:
possibleright:
mov si, savesi

mov ax, si					;nu kijken of er ergens een steen omheen staat
mov bx, 8					; delen om te kijken of vakje aan de rand zit
div bx						; col: dx row: ax
	
cmp dx, 7					;meest rechtse kolom?
jne @F      				; ga naar volgende test
jmp restartloop
@@:
add si, 1
push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
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

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp		;lees en zet in dx
cmp dx, 2					;is het een zwarte?
je placeposblackup			;plaats pos black
cmp dx, 1					;vergelijk dx met 1
je loopposblackup			;restart loop
jmp bup


placeposblackup:
mov si, savesi

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
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

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp		;lees en zet in dx
cmp dx, 1					;is het een witte?
je placeposwhiteup			;plaats poswhite
cmp dx, 2
je loopposwhiteup			;restart loop
jmp bup


;-----
placeposwhiteup:
mov si, savesi

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
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


loopposblackleft:
mov ax, si					;test of je boven aan bent
mov bx, 8
div bx
cmp dx, 0
je bleft					;zo ja een omlaag

sub si, 1 					;een naar links

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
cmp dx, 2					;is het een zwarte?
je placeposblackleft		;plaats pos black
cmp dx, 1
je loopposblackleft			;startloop opnieuw
jmp bleft
eindeloopff:
jmp eindeloopf
;-----
placeposblackleft:
mov si, savesi

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
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

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
cmp dx, 1					;is het een witte?
je placeposwhiteleft		;plaats pos white
cmp dx, 2
je loopposwhiteleft			;startloop opnieuw
jmp bleft

;-----
placeposwhiteleft:
mov si, savesi

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
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
je cont
jmp next
cont:
jmp bdown					;zo ja ga door
next:   
add si, 8					;een naar beneden

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
cmp dx, 2					;is het een zwarte?
je placeposblackdown		;plaats pos black
cmp dx, 1
je loopposblackdown
jmp bdown
placeposblackdown:			;plaats possible black	
mov si, savesi				;lees plaats uit

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
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
jne @F
jmp bdown                   ; zo ja ga naar volgende test
@@:

add si, 8					;zo nee ga naar volgende vak


push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp	;lees uit wat daar staat
cmp dx, 1					; als dit wit is
je placeposwhitedown		;ga naar schrijf pw
cmp dx, 2					; als dit zwart is
je loopposwhitedown			; ga door met pw loop
jmp bdown					;anders ga naar volgende test
eindeloopf:
jmp eindeloop
;---------------
placeposwhitedown:
mov si, savesi				; lees juiste vak uit

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp	;kijk of er al een pb staat			
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

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
cmp dx, 2
je placeposblackright
cmp dx, 1
je loopposblackright
jmp restartloop

;---------------
placeposblackright:
mov si, savesi

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
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

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
cmp dx, 1
je placeposwhiteright
cmp dx, 2
je loopposwhiteright
jmp restartloop

;---------------
placeposwhiteright:
mov si, savesi

push bp
mov bp, bx
mov dx, speelveld[bp+si]
pop bp
cmp dx, 3
je placeposbothright
push si
call setvakpossiblewhite
jmp restartloop



;---------------
placeposbothright:
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
countpossible PROC NEAR
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
looper:						; einde van speelveld?
cmp si, 64				
je eindeloop				; ga naar eindeloop

push bp
mov bp, bx
mov ax, speelveld[bp+si]
pop bp
mov bx, beurt
cmp bx, 1					;beurt is wit
je witbeurt					; ga naar beurt wit
jmp zwartbeurt				; anders naar beurt zwart


witbeurt:					; wit beurt
cmp ax, 3					; is er een pw?
je pluseen
cmp ax, 5					; of een pa?
je pluseen
jmp looper					; loopverder

zwartbeurt:					; zwart beurt
cmp ax, 4					; is er een pb?		
je pluseen				
cmp ax, 5					; of een pa?
je pluseen
jmp looper


pluseen:					; tel een op bij countpos
mov dx, countpos	
add dx, 1
mov countpos, dx
jmp looper



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
whowon PROC NEAR
    push bp
	mov bp, sp
	push dx
	push es
	push cx
	push ax 
	push bx
	;zet waarde op stack
	
	;------------------------------------------
    mov ax, blackcoins
    mov bx, whitecoins
    
    cmp ax, bx
    ja blackwon
    cmp ax, bx
    je bothwon
    jmp whitewon
    ;--------------
    
    blackwon:					;zwart heeft gewonnen
    mov ax, locatiemunt         ;zet locatie in ax
    push ax
	mov ax, 0                   ;zet kleur in ax
    push ax
	call printCircle
    
    jmp einde
    
    ;--------------
    bothwon:
    mov ax, locatiemunt
    sub ax, 25
    push ax
								
	mov ax, 0 ; kleur
	push ax
	call printCircle
	
    mov ax, locatiemunt
    
    push ax
	mov ax, 15 ; kleur
	push ax
	call printCircle							
    
    jmp einde
    
    ;--------------
    whitewon:					;wit heeft gewonnen
    mov ax, locatiemunt
    
    push ax
	mov ax, 15 ; kleur
	push ax
	call printCircle
     
     jmp einde
     
     ;--------------
     
     einde:
     
	mov ax, locatiemunt			;won plaatsen
	add ax, 25					; 25 px from coin
	push ax					
	call printWON				; call it
    
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

;-------------------------------

mov si, 0                ;your index
mov al, bl               ;bl = byte value from your question
mov bx, offset speelveld
looper2:
cmp si, 64
je eindeloop

mov ax, speelveld[bx+si]

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
looper3:
cmp si, 64
je eindeloop


mov ax, speelveld[bx+si]

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
jmp looper3

dleeg:
push ax
call  DRAWEM
jmp looper3

dwhite:
push ax
call Wcoin
jmp looper3

dblack:
push ax
call Bcoin
jmp looper3

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

dpos:
push ax
call drawpos
jmp looper3


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

END

