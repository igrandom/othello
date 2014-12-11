; ==============================================================================
; Example for buffered drawing in mode 13h.
; Example showing palette manipulation via port IO.
; Example for a very generic game-loop.
; ==============================================================================
.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------

include DRAWR.INC
include DRAWC.INC
include PRINTG.INC

; --- MACROS AND CONSTANTS -----------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200

; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables
PUBLIC thisDrawing
oldVideoMode	db ?
thisDrawing 	db 0, 0, 0, 0, 0, 0 , 0
palette     db 0, 0, 0, 13, 53, 56    ; defines black and white
hardOffset	dw 0 ; test variable

; --- SCREEN BUFFER ------------------------------------------------------------
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing

screenBuffer	db 64000 dup(?)	; the 64000 bytes for the screen


; ----------------------------- CODE STARTS HERE -------------------------------
.CODE        ; code segment

main:


mov	ax, @DATA
	mov	ds, ax
	mov es, ax
	
					; call Video BIOS
	mov  ah, 0 				; function 0 (set video mode)
	mov  al, 13h 			; argument 13h (mode 13h to be set)
	int  10h 

	mov  dx, offset palette ; set the palette (DAC) (offset relative to es)
    xor  bx, bx             ; set bx to zero (start at color index 0)
    mov  cx, 2             ; set color 0 and 1 (2 indexes in total)

	
mov  ax, 1012h          ; function 1012h of int 10h (set DAC palette)
    int  10h                ; call Video BIOS

    
    push cx
    push ax
    
    
    					
	call printGame
    
    
	
		mov ax, 100000
    mov [thisDrawing + 0], ah
    mov [thisDrawing + 1], al
							;zet kleur in thisDrawing
	mov al, 1 ; kleur
	mov [thisDrawing + 6], al
	
	call printCircle
    
    
    

	pop cx
	pop ax
    
    
    
	
	


; Exit to DOS
	mov	ax, 4c00h
	int	21h

; --- END

; _------------------------------- END OF CODE ---------------------------------
END main