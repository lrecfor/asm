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

; void drawpixel(int row, int column, int color)
; рисование пикселя (код цвета в младшем байте аргумента)    
_drawpixel proc near
    push bp
    mov bp, sp
    
    mov bh, 0
    mov dx, word ptr [bp + arg1] ;row x
    mov cx, word ptr [bp + arg2] ;column y
    mov ax, word ptr [bp + arg3] ;color
    mov ah, 0ch
    int 10h
    
    mov sp, bp
    pop bp
    ret
_drawpixel endp  

;void draw_line_x(int start_x, int start_y, int len, int color)
;рисования отрезка, параллельного оси X
_draw_line_x proc near
    push bp
    mov bp, sp
    
    mov bh, 0
    mov cx, word ptr [bp + arg1] ;start_x
    mov dx, word ptr [bp + arg2] ;start_y
	mov bx, word ptr [bp + arg3] ;len
	mov ax, word ptr [bp + arg4] ;color
	
_draw_line_x_cyc:
	push ax
	push cx
	push dx
	
    call _drawpixel
	inc cx
	dec bx
	
	cmp bx, 0
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
    
    mov bh, 0
    mov cx, word ptr [bp + arg1] ;start_x
    mov dx, word ptr [bp + arg2] ;start_y
	mov bx, word ptr [bp + arg3] ;len
	mov ax, word ptr [bp + arg4] ;color
	
_draw_line_y_cyc:
	push ax
	push cx
	push dx
    
	call _drawpixel
	inc dx
	dec bx
	
	cmp bx, 0
	je _draw_line_y_ret
	
	jmp _draw_line_y_cyc
    
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

    mov dx, 04h
    push dx
    call _setmode
    add sp, 2
    
	mov dx, 2	;color
	push dx
    mov dx, 50 	;len
    push dx
    mov dx, 25 	;start_y
    push dx
    mov dx, 25 	;start_x
    push dx
    call _draw_line_x
    add sp, 8
	
	mov dx, 3	;color
	push dx
    mov dx, 75	;len
    push dx
    mov dx, 25 	;start_y
    push dx
    mov dx, 50 	;start_x
    push dx
    call _draw_line_y
    add sp, 8
	
	mov dx, 2	;color
	push dx
    mov dx, 50 	;len
    push dx
    mov dx, 99 	;start_y
    push dx
    mov dx, 25 	;start_x
    push dx
    call _draw_line_x
    add sp, 8
    
    call _getchar
  
    mov dx, 02h
    push dx
    call _setmode
    add sp, 2
    
    call _exit0
code ends

end start