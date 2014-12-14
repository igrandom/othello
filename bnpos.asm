; ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------

include startg.INC
include drawbw.inc
include gamelp.inc
include drawem.inc

; --- MACROS AND CONSTANTS -----------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200

; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables

savesi 			db 0
oldVideoMode	db ?
palette     db 0, 0, 0, 13, 53, 56    ; defines black and white
hardOffset	dw 0 ; test variable
PLAYFIELD dw 6420

; --- SCREEN BUFFER ------------------------------------------------------------
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing

screenBuffer	db 64000 dup(?)	; the 64000 bytes for the screen


; ----------------------------- CODE STARTS HERE -------------------------------
.CODE



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
placeposblackdown:
mov si, savesi

mov dx, byte ptr [bt+si]
cmp dx, 4
je placeposbothdown
push si
call setvakpossibleblack
jmp bdown

;---------------
loopposwhitedown:
mov ax, si
mov bx, 8
div bx
cmp ax, 7
je bdown

add si, 8

mov dx, byteptr [bx+si]
cmp dx, 1
je placeposwhitedown
cmp dx, 2
je loopposblackdown
jmp bdown

;---------------
placeposwhitedown:
mov si, savesi

mov dx, byte ptr [bt+si]
cmp dx, 3
je placepsbothdown
push si
call setvakpossiblewhite
jmp bdown

;---------------
placeposbothdown:
mov si, savesi
push si
call setvakpossibleboth
jmp bdown


;---------------
loopposblackright:


jmp restartloop

;---------------
loopposwhiteright:


jmp restartloop

;---------------
restartloop:
mov si, savesi
add si, 1

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
    
    END