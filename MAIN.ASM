;-----------------------------------------------------------------------------------;
;																					;
;																					;
;								----MAIN FILE----									;
;																					;
;																					;
;			this includes:															;
;						- mouse reader												;
;						- add black													;
;						- add white													;
;						- sub black													;
;						- sub white													;
;						- alle sets voor vakjes:									;
;							(setblack, setvakwhite, 								;
;							setvakposwhite, setvakposboth, 							;
;							setvakposblack, setvakempty)							;
;						- setupvakjes												;
;						- main functie												;
;																					;
;																					;
;-----------------------------------------------------------------------------------;

.MODEL large	                                   ; multiple data segments and multiple code segments
.STACK 2048  	                                   ; stack
include LOGICA.INC
include TEKEN.INC

; --- DATA SEGMENT -------------------------------------------------------------
.DATA
    PUBLIC speelveld
    PUBLIC COL, ROW, VAK
    blackcoins 		  db 0
    whitecoins 	   	  db 0
    speelveld	      db 64 dup(0)
    COL               dw 0
    ROW               dw 0
    VAK               dw 0
; ----------------------------- CODE STARTS HERE -------------------------------
.CODE
;------------------MOUSEREADER------------------;
; Uitleg: locatie van de muis uitlezen          ;
; Parameters doorgegeven met push:              ;
;                       geen                    ;
;-----------------------------------------------;
mousereader PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
    mov ax, 01h ;ACTIVEER MUIS
    int 33h	
    ;----Loopje----
    loopje:
        mov ax, 05h
        int 33h				     ;lees uit
        cmp bx, 1                ;if bx = 1 ; if left button is down
            je clicked			 ;true branch
            jmp loopje           ;false branch
    ;----end Loopje----

    ;----clicked----
    clicked: 				     ;als er geklikt is
        mov ax, 03h
        int 33h
        cmp cx, 600
            jae pclose
        contclicked:
        mov ROW, dx 			 ; row position
        mov COL, cx 			 ; column position
        mov ax, ROW				 ;kijk of row boven 20 ligt
        cmp ax, 20               ;if row is more than 20
            jae comparerowbelow  ;true branch
            jmp loopje           ;false branch
    ;----end clicked----
    
    pclose:
        cmp dx, 20
            jbe close
            jmp contclicked

    ;----comparerowbelow----
    comparerowbelow:
        cmp ax, 196				 ;kijk of row onder 196 ligt
            jbe comparecolabove  ;true branch
            jmp loopje           ;false branch
    ;----end comparerowbelow----

    ;----comparecolabove----
    comparecolabove:
        mov ax, COL				
        cmp ax, 20               ;kijk of col boven 20 ligt
            jae comparecolbelow  ;true branch
            jmp loopje           ;false branch
    ;----end comparecolabove----
    
    ;----comparecolbelow----
    comparecolbelow:
        cmp ax, 196				 ;kijk of col onder 196 ligt
            jbe calculatevak     ;true branch
            jmp loopje           ;false branch
    ;----end comparecolbelow----

    ;----calculatevak----
    calculatevak:
    	call calcvak			;dan is de pijl in het veld : bereken het vakje
        mov ax, VAK
        call WCoin
        jmp cont
    ;----end calculatevak----
    ; nu moet er nog gekeken worden of de vakjes clickable zijn
    ; functie komt ergens anders te staan maar moet hier ingeladen worden: merci :)
    
    close:
    mov ax, 02h ;DEACTIVEER MUIS
    int 33h
    mov ax, 0
    push ax
    mov ax, 200
    push ax
    mov ax, 320
    push ax
    mov ax, 0
    push ax
    call printRectangle
    mov	ax, 4c00h
    int	21h
    cont:
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
mousereader ENDP
;-----------------------------------------------;

;-------------------ADD BLACK-------------------;
; Uitleg: aantal zwarte coins ophogen           ;
; Parameters doorgegeven met push:              ;
;                       geen                    ;
;-----------------------------------------------;
addblack PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
    
    mov ax, 0
    mov al, blackcoins
    add al, 1
    mov blackcoins, al
    
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
addblack ENDP
;-----------------------------------------------;

;-------------------ADD WHITE-------------------;
; Uitleg: aantal witte  coins ophogen           ;
; Parameters doorgegeven met push:              ;
;                       geen                    ;
;-----------------------------------------------;
addwhite PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
    mov ax, 0
    mov al, whitecoins
    add al, 1
    mov whitecoins, al	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
addwhite ENDP
;-----------------------------------------------;

;-------------------SUB BLACK-------------------;
; Uitleg: aantal zwarte coins verlagen          ;
; Parameters doorgegeven met push:              ;
;                       geen                    ;
;-----------------------------------------------;
subblack PROC NEAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 

    mov ax, 0
    mov al, blackcoins
    sub al, 1
    mov blackcoins, al
	
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
subblack ENDP
;-----------------------------------------------;

;-------------------SUB WHITE-------------------;
; Uitleg: aantal witte coins verlagen           ;
; Parameters doorgegeven met push:              ;
;                       geen                    ;
;-----------------------------------------------;
subwhite PROC NEAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
    mov ax, 0
    mov al, whitecoins
    sub al, 1
    mov whitecoins, al
    
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
subwhite ENDP
;-----------------------------------------------;

;-------------------SET VAK EMPTY---------------;
; Uitleg: een vakje leegmaken                   ;
; Parameters doorgegeven met push:              ;
;             - locatie (vaknummer) [0]         ;
;-----------------------------------------------;
setvakempty PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax

    mov si, [bp+6][0]
    mov bl, 0
    mov [speelveld+si], bl
    
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 2
setvakempty ENDP
;-----------------------------------------------;

;-------------------SET VAK WHITE---------------;
; Uitleg: een witte coin plaatsen               ;
; Parameters doorgegeven met push:              ;
;             - locatie (vaknummer) [0]         ;
;-----------------------------------------------;
setvakwhite PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
	
    mov si, [bp+6][0]
    mov bl, 1
    mov [speelveld+si], bl
    
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 2
setvakwhite ENDP
;-----------------------------------------------;

;-------------------SET VAK BLACK---------------;
; Uitleg: een zwarte coin plaatsen              ;
; Parameters doorgegeven met push:              ;
;             - locatie (vaknummer) [0]         ;
;-----------------------------------------------;
setvakblack PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax
	 
    mov si, [bp+6][0]
    mov bl, 2
    mov [speelveld+si], bl
    
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 2
setvakblack ENDP
;-----------------------------------------------;

;----------------SET VAK POSSIBLE WHITE---------;
; Uitleg: een vakje mogelijk wit maken          ;
; Parameters doorgegeven met push:              ;
;             - locatie (vaknummer) [0]         ;
;-----------------------------------------------;
setvakpossiblewhite PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
    mov si, [bp+6][0]
    mov bl, 3
    mov [speelveld+si], bl	
    
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 2
setvakpossiblewhite ENDP
;-----------------------------------------------;

;----------------SET VAK POSSIBLE BLACK---------;
; Uitleg: een vakje mogelijk zwart maken        ;
; Parameters doorgegeven met push:              ;
;             - locatie (vaknummer) [0]         ;
;-----------------------------------------------;
setvakpossibleblack PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
    mov si, [bp+6][0]
    mov bl, 4
    mov [speelveld+si], bl

    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 2
setvakpossibleblack ENDP
;-----------------------------------------------;

;----------------SET VAK POSSIBLE BOTH----------;
; Uitleg: een vakje mogelijk wit of zwart maken ;
; Parameters doorgegeven met push:              ;
;             - locatie (vaknummer) [0]         ;
;-----------------------------------------------;
setvakpossibleboth PROC FAR
	push bp
	mov bp, sp
	push bx
	push dx
	push es
	push cx
	push ax 
	
    mov si, [bp+6][0]
    mov bl, 5
    mov [speelveld+si], bl
    
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 2
setvakpossibleboth ENDP
;-----------------------------------------------;

;---------------------SETUPVAKJES---------------;
; Uitleg: initiele waarden instellen            ;
; Parameters doorgegeven met push:              ;
;                       geen                    ;
;-----------------------------------------------;
setupvakjes PROC NEAR
	push bp
	mov bp, sp
	push ax
    push bx
    push cx
    push dx
    push es
    push si

    ;-------------------------------
    ; in de array komt te staan wat het vakje kan zijn:
    ; een vakje kan leeg zijn = 0
    ; een vakje kan een wit bolletje hebben = 1
    ; een vakje kan een zwart bolletje hebben = 2
    ; een vakje kan een pw: 3 ; possible white
    ; een vakje kan een pb: 4 ; possible black
    ; een vakje kan een pa: 5 ; possible both
    ;------------------------------- 
    
    cleanarray:
        mov si, 0
        cleanloop:
            cmp si, 64
                je @F
            mov [speelveld+si], 0
            inc si
            jmp cleanloop
            
    
    @@:
    mov ax, 19
    push ax
    call setvakpossibleblack

    mov ax, 20
    push ax
    call setvakpossiblewhite

    mov ax, 26
    push ax
    call setvakpossibleblack

    mov ax, 27
    push ax
    call setvakwhite

    mov ax, 28
    push ax
    call setvakblack

    mov ax, 29
    push ax
    call setvakpossiblewhite

    mov ax, 34
    push ax
    call setvakpossiblewhite

    mov ax, 35
    push ax
    call setvakblack

    mov ax, 36
    push ax
    call setvakwhite

    mov ax, 37
    push ax
    call setvakpossibleblack

    mov ax, 43
    push ax
    call setvakpossiblewhite

    mov ax, 44
    push ax
    call setvakpossibleblack

    pop si
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
	pop bp
	ret 0
setupvakjes ENDP
;-----------------------------------------------;

;-----------------------------------------------;
;   .88b  d88.  .d8b.  d888888b d8b   db        ;
;   88'YbdP`88 d8' `8b   `88'   888o  88        ;
;   88  88  88 88ooo88    88    88V8o 88        ;
;   88  88  88 88~~~88    88    88 V8o88        ;
;   88  88  88 88   88   .88.   88  V888        ;
;   YP  YP  YP YP   YP Y888888P VP   V8P        ;                          
;-----------------------------------------------;
main:
	mov  ah, 0 				; function 0 (set video mode)
	mov  al, 13h 			; argument 13h (mode 13h to be set)
	int  10h 

	mov  dx, offset palette ; set the palette (DAC) (offset relative to es)
    xor  bx, bx             ; set bx to zero (start at color index 0)
    mov  cx, 0             ; set color 0 and 1 (2 indexes in total)

	mov  ax, 1012h          ; function 1012h of int 10h (set DAC palette)
    int  10h  
	
	
    push ax
    push bx
    push cx
    push dx
    
    mov beurt, 1
	
	call printgame							;teken spel
    call setupvakjes						;zet de vakjes
    call drawcoins							;teken de munten
    
    
    call addblack							;zet aantal black coins op 2
    call addblack
    
    call addwhite							;zet aantal white coins op 2
    call addwhite
    
    call gameloop							; start gameloop
    
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    mov	ax, 4c00h
	int	21h
END main
