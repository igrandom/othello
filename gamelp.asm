; ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------


include DRAWR.INC
include MOUSRDR.INC
include GAMELP.INC
include DRAWBW.INC
include gmfin.inc
include bnpos.inc
include dccoin.inc

; --- MACROS AND CONSTANTS -----------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200


; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables
public: richting, beurt

oldVideoMode	db ?
richting		db 1
beurt			db 2
palette     db 0, 0, 0, 13, 53, 56    ; defines black and white
hardOffset	dw 0 ; test variable
PLAYFIELD dw 6420

; --- SCREEN BUFFER ------------------------------------------------------------
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing

screenBuffer	db 64000 dup(?)	; the 64000 bytes for the screen


; ----------------------------- CODE STARTS HERE -------------------------------
.CODE

switchbeurt PROC NEAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

mov ax, beurt
cmp beurt 1
je naarblack
jmp naarwhite

:naarblack
mov beurt, 2

:naarwhite
mov beurt, 1

	
;-------------------------------
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	switchbeurt ENDP
;----------------------------------------------------------------------------------

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
call swapleft
mov richting, 2
call swapleft
mov richting, 3
call swapleft
mov richting, 4
call swapleft

call berekenpossible
call countcoins
call drawcoins
call switchbeurt
call countpossible
mov ax, countpossible
cmp ax, 0
je endgame
jmp startloop


endgame	:
call whowon
;-------------------------------
	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	gameloop ENDP
	
	
;----------------------------------------------------------------------------------	
	swapleft PROC NEAR
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
	swapleft ENDP
   	
	
