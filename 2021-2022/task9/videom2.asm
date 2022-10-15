arg1 equ 4
arg2 equ 6
arg3 equ 8
arg4 equ 10

var1 equ -2
var2 equ -4
var3 equ -6
var4 equ -8

stack segment para stack
db 65530 dup(?)
stack ends

data segment para public
data ends

code segment para public 

assume cs:code,ds:data,ss:stack

include strings.inc

; void setmode(int mode)
; установка видеорежима (номер режима в младшем байте аргумента)    
_setmode proc near
    push bp
    mov bp, sp
    
    mov ax, word ptr [bp + arg1]
    mov ah, 00h
    int 10h
    
    mov sp, bp
    pop bp
    ret
_setmode endp 

start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    
    mov dx, 12h     
    push dx
    call _setmode  
    add sp, 2
    
    mov ax, 0A000h
    mov es, ax
    
    mov bx, 0
    
    mov al, 0FFh
    
    mov byte ptr es:[bx], al    ; рисует 8 пикселей
    mov byte ptr es:[bx+1], al  ; рисует следующие 8 пикселей
	mov byte ptr es:[bx+2], al
    mov byte ptr es:[bx+80], al ; рисует 8 пикселей с новой строки
    
    call _getchar
    
    mov dx, 3     ; текст 80х25 символов
    push dx
    call _setmode  
    add sp, 2
    
    call _exit0
code ends

end start



;;;;;
arg1 equ 4
arg2 equ 6
arg3 equ 8
arg4 equ 10

var1 equ -2
var2 equ -4
var3 equ -6
var4 equ -8

stack segment para stack
db 65530 dup(?)
stack ends

data segment para public
SCREEN_WIDTH_IN_BYTES equ 80
GC_INDEX EQU 3CEh
SET_RESET_INDEX EQU 0
SET_RESET_ENABLE_INDEX EQU 1
BIT_MASK_INDEX equ 8
COLOR EQU 0Ch
data ends

code segment para public 

assume cs:code,ds:data,ss:stack

include strings.inc

; void drawpixel(int row, int column, int color)
; рисование пикселя (код цвета в младшем байте аргумента)    
_drawpixel proc near
    push bp
    mov bp, sp
      
    mov byte ptr es:[bx], al    ; рисует 8 пикселей
    mov byte ptr es:[bx+1], al  ; рисует следующие 8 пикселей
	mov byte ptr es:[bx+2], al
    mov byte ptr es:[bx+80], al ; рисует 8 пикселей с новой строки
    
    mov sp, bp
    pop bp
    ret
_drawpixel endp  

;void draw_line_x(int start_x, int start_y, int len, int color)
;рисования отрезка, параллельного оси X
_draw_line_x proc near
    push bp
    mov bp, sp

    mov bx, word ptr [bp + arg1] ;start_x
    mov dx, word ptr [bp + arg2] ;start_y
	mov cx, word ptr [bp + arg3] ;len
	mov ax, word ptr [bp + arg4] ;color
	
_draw_line_x_cyc:
	;mov byte ptr es:[bx+di], al  ;for 12h
	
	mov dx, 320*100+160
	mov cx, 13
	mov di, dx
	mov al, 5h
	rep stosb
	
	inc di
	dec cx
	
	cmp cx, 0
	je _draw_line_x_ret
	
	jmp _draw_line_x_cyc
    
_draw_line_x_ret:
    mov sp, bp
    pop bp
    ret
_draw_line_x endp  

;void draw_line_y(int start_x, int start_y, int len, int color)
;рисования отрезка, параллельного оси Y
_draw_line_y proc near
    push bp
    mov bp, sp
    
    mov bx, word ptr [bp + arg1] ;start_x
    mov dx, word ptr [bp + arg2] ;start_y
	mov cx, word ptr [bp + arg3] ;len
	mov ax, word ptr [bp + arg4] ;color
	
_draw_line_y_cyc: 
	;mov byte ptr es:[bx+di], al
	;add di, 80
	;dec si
	
	;cmp si, 0
	;je _draw_line_y_ret
	
	;jmp _draw_line_y_cyc
	
	
    
_draw_line_y_ret:
    mov sp, bp
    pop bp
    ret
_draw_line_y endp  
    
start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax

    mov dx, 13h
    push dx
    call _setmode
    add sp, 2
	
	mov ax, 0A000h
    mov es, ax
    
	mov dx, 0FFh	;color
	push dx
    mov dx, 40 		;len
    push dx
    mov dx, 240 	;start_y
    push dx
    mov dx, 0 		;start_x
    push dx
    call _draw_line_x
    add sp, 8 
	
	mov dx, 1;0FFh	;color
	push dx
    mov dx, 480	;len
    push dx
    mov dx, 0 	;start_y
    push dx
    mov dx, 320 ;start_x
    push dx
    call _draw_line_y

    call _getchar
  
    mov dx, 02h
    push dx
    call _setmode
    add sp, 2
    
    call _exit0
code ends

end start

;mov bx, word ptr [bp + arg1] ;start_x
    ;mov dx, word ptr [bp + arg2] ;start_y
	
	;mov ax, dx
	;mov cx, 80
	;imul cx 
	;mov cx, ax
	;mov ax, bx
	;mov di, 8
	;idiv di
	;cbw
	;add cx, ax
	;mov bx, cx
	;xor di, di
	
	;mov cx, word ptr [bp + arg3] ;len
	;mov ax, word ptr [bp + arg4] ;color