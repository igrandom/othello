;hallo kriz ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------


include DRAWR.INC
include mousrdr.inc

; --- MACROS AND CONSTANTS -----------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200

; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables
PUBLIC speelveld
oldVideoMode	db ?
blackcoins 		db 0
whitecoins 		db 0
speelveld	dw 64 dup (0) ;in de inc
palette     db 0, 0, 0, 13, 53, 56    ; defines black and white
hardOffset	dw 0 ; test variable
PLAYFIELD dw 6420

; --- SCREEN BUFFER ------------------------------------------------------------
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing

screenBuffer	db 64000 dup(?)	; the 64000 bytes for the screen


; ----------------------------- CODE STARTS HERE -------------------------------
.CODE

startgame PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

call setupvakjes

;zet aantal black coins op 2
call addblack
call addblack

;zet aantal white coins op 2
call addwhite
call addwhite

call mousereader



	
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	startgame ENDP
	
	;---------------------------------------------------------------------------

addblack PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------



;zet aantal black coins op 2
mov ax, 0
mov al, blackcoins
add al, 1
mov blackcoins, al
	
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	addblack ENDP
	;---------------------------------------------------------------------------
	addwhite PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

;zet aantal white coins op 2
mov ax, 0
mov al, whitecoins
add al, 1
mov whitecoins, al

;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	addwhite ENDP
	
	;---------------------------------------------------------------------------

subblack PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------



;zet aantal black coins op 2
mov ax, 0
mov al, blackcoins
sub al, 1
mov blackcoins, al
	
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	subblack ENDP
	;---------------------------------------------------------------------------
	subwhite PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------

;zet aantal white coins op 2
mov ax, 0
mov al, whitecoins
sub al, 1
mov whitecoins, al

;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	subwhite ENDP
;---------------------------------------------------------------------------	
	setvakempty PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;------------------------------- ;push vak op stack

;mov si, 2                ;your index
;mov al, bl               ;bl = byte value from your question
;mov bx, offset arr
;mov byte ptr [bx+si], al

 mov si, [bp+4][0]
 mov bx, 0
 mov bl, 3
 mov speelveld[si], bl
 pop sp
 
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
setvakempty ENDP
    
;---------------------------------------------------------------------------

setvakwhite PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;------------------------------- ;push vak op stack
 ;mov ax, [bp+4][0]
 ;push bp
 ;mov bp, ax
 mov bx, 0
 mov bl, 1
mov speelveld[bp+4], bl
;pop bp
 
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
setvakwhite ENDP
    
;---------------------------------------------------------------------------
setvakblack PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;------------------------------- ;push vak op stack
 ;mov ax, [bp+4][0]
 ;push bp
 ;mov bp, ax
 mov bx, 0
 mov bl, 2
mov speelveld[bp+4], bl
;pop bp
 
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	setvakblack ENDP
    
;---------------------------------------------------------------------------

setvakpossiblewhite PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;------------------------------- ;push vak op stack
 ;mov ax, [bp+4][0]
 ;push bp
 ;mov bp, ax
 mov bx, 0
 mov bl, 3
mov speelveld[bp+4], bl
;pop bp
 
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
setvakpossiblewhite ENDP
    
;---------------------------------------------------------------------------
setvakpossibleblack PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;------------------------------- ;push vak op stack
 ;mov ax, [bp+4][0]
 mov bx, 0
 mov bl, 4
mov speelveld[bp+4], bl
 
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
setvakpossibleblack ENDP
    
;---------------------------------------------------------------------------
setvakpossibleboth PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;------------------------------- ;push vak op stack
 ;mov ax, [bp+4][0]
 mov bx, 0
 mov bl, 5
mov speelveld[bp+4], bl
 
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
setvakpossibleboth ENDP
    
;---------------------------------------------------------------------------

setupvakjes PROC NEAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

;-------------------------------
; in de array komt te staan wat het vakje kan zijn:
; een vakje kan leeg zijn = 0
; een vakje kan een wit bolletje hebben = 1
; een vakje kan een zwart bolletje hebben = 2
; een vakje kan een pw: 3 ; possible white
; een vakje kan een pb: 4 ; possible black
; een vakje kan een pa: 5 ; possible both
;------------------------------- 

mov ax, 0

mov ax, 20
push ax
call setvakpossibleblack

mov ax, 21
push ax
call setvakpossiblewhite

mov ax, 27
push ax
call setvakpossibleblack

mov ax, 28
push ax
call setvakwhite

mov ax, 29
push ax
call setvakblack

mov ax, 30
push ax
call setvakpossiblewhite

mov ax, 35
push ax
call setvakpossiblewhite

mov ax, 36
push ax
call setvakblack

mov ax, 37
push ax
call setvakwhite

mov ax, 38
push ax
call setvakpossibleblack

mov ax, 44
push ax
call setvakpossiblewhite

mov ax, 45
push ax
call setvakpossibleblack


	
;-------------------------------	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	setupvakjes ENDP
    
    END