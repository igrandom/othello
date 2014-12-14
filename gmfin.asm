    
    .MODEL large	; multiple data segments and multiple code segments
.STACK 2048

include startg.INC
include drawbw.inc
include gamelp.inc
include drawem.inc


; --- MACROS AND CONSTANTS -----------------------------------------------------
;Other constants	
SCREENW		equ 320
SCREENH		equ 200

; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables
public: 		countpos

countpos 		db 0
locatiemunt 	db 9999
oldVideoMode	db ?
palette     db 0, 0, 0, 13, 53, 56    ; defines black and white
hardOffset	dw 0 ; test variable
PLAYFIELD dw 6420


; --- SCREEN BUFFER ------------------------------------------------------------
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing

screenBuffer	db 64000 dup(?)	; the 64000 bytes for the screen


; ----------------------------- CODE STARTS HERE -------------------------------
.CODE
    
    
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
	
	;-----------------------------------------------------------------------
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
		
		
	;------------------------------------------
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
	whowon ENDP
    END
    
    