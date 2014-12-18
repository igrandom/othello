.MODEL small	                                   ; multiple data segments and multiple code segments
.STACK 2048  	                                   ; stack
.DATA
    blackcoins 		  db 0
    whitecoins 	   	  db 0
    speelveld	      dw 64 dup (0) ;in de inc
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
    
    ;----Loopje----
    loopje:
        mov ax, 03h
        int 33h				     ;lees uit
        cmp bx, 1                ;if bx = 1 ; if left button is down
            je clicked			 ;true branch
            jmp loopje           ;false branch
    ;----end Loopje----

    ;----clicked----
    clicked: 				     ;als er geklikt is
        mov ROW, dx 			 ; row position
        mov COL, cx 			 ; column position
        mov ax, ROW				 ;kijk of row boven 20 ligt
        cmp ax, 20               ;if row is more than 20
            jae comparerowbelow  ;true branch
            jmp loopje           ;false branch
    ;----end clicked----

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
        cmp ax, 20				 ;kijk of col onder 196 ligt
            jbe calculatevak     ;true branch
            jmp loopje           ;false branch
    ;----end comparecolbelow----

    ;----calculatevak----
    calculatevak:
        call calcvak			;dan is de pijl in het veld : bereken het vakje
    ;----end calculatevak----
    ; nu moet er nog gekeken worden of de vakjes clickable zijn
    ; functie komt ergens anders te staan maar moet hier ingeladen worden: merci :)
    
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
subblack PROC FAR
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
subwhite PROC FAR
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

    mov si, [bp+4][0]
    push bp
    mov bp, offset speelveld
    mov bx, 0
    mov bl, 3
    mov byte ptr [bp+si], bl
    pop bp
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
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
    mov si, [bp+4][0]
    push bp
    mov bp, offset speelveld
    mov bx, 0
    mov bl, 1
    mov byte ptr [bp+si], bl
    pop bp
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
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
    mov si, [bp+4][0]
    push bp
    mov bp, offset speelveld
    mov bx, 0
    mov bl, 2
    mov byte ptr [bp+si], bl
    pop bp
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
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
    mov si, [bp+4][0]
    push bp
    mov bp, offset speelveld
    mov bx, 0
    mov bl, 3
    mov byte ptr [bp+si], bl
    pop bp	
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
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
    mov si, [bp+4][0]
    push bp
    mov bp, offset speelveld
    mov bx, 0
    mov bl, 4
    mov byte ptr [bp+si], bl
    pop bp
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
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
    mov si, [bp+4][0]
    push bp
    mov bp, offset speelveld
    mov bx, 0
    mov bl, 5
    mov byte ptr [bp+si], bl
    pop bp
    pop ax
	pop cx
	pop es
	pop dx
	pop bx
	pop bp
	ret 0
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
	pop ax
	pop cx
	pop es
	pop dx
	pop bx
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
;   YP  YP  YP YP   YP Y888888P VP   V8P        ;                          ;
;-----------------------------------------------;
main:
    call setupvakjes
    ;zet aantal black coins op 2
    call addblack
    call addblack
    ;zet aantal white coins op 2
    call addwhite
    call addwhite
    call gameloop
END main
