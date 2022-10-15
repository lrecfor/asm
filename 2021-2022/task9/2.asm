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

; void drawpixel(int color, int x, int y) 
; рисование пикселя (код цвета в младшем байте аргумента)    
_drawpixel proc near
    push bp
    mov bp, sp
	push bx
	push dx
      
	mov bx, word ptr[bp+arg1]
	mov dx, word ptr[bp+arg2]
	;mov ax, word ptr[bp+arg3]
	
	mov ax, dx
	mov di, 320
	mul di
	add ax, bx
	mov dx, ax
	mov di, dx
	mov ax, word ptr[bp+arg3]
	stosb
    
	pop dx
	pop bx
    mov sp, bp
    pop bp
    ret
_drawpixel endp  

;void draw_circle(int x, int y, int radius, int color)
;функция принимает 4 аргумента: x и y координаты центра, радиус окружности, цвет линии окружности
;word ptr[bp+var4] - x
;word ptr[bp+var3] - y
;word ptr[bp+var2] - delta
;word ptr[bp+var1] - error
_drawcircle proc near
    push bp
    mov bp, sp
	sub sp, 8

	mov word ptr[bp+var4], 0
	mov ax, word ptr[bp+arg3]
	mov word ptr[bp+var3], ax
	mov word ptr[bp+var2], 2
	mov ax, 2
	mov dx, 0
	imul word ptr[bp+var3]
	sub word ptr[bp+var2], ax
	mov word ptr[bp+var1], 0
	
	jmp _drawcircle_cyc
	
_drawcircle_ret:
    mov sp, bp
    pop bp
    ret

_drawcircle_cyc:
	mov ax, word ptr[bp+var3]
	cmp ax, 0
	jl _drawcircle_ret
	
	mov dx, word ptr[bp+arg4]
	push dx
	mov dx, word ptr[bp+arg2]
	add dx, word ptr[bp+var3]
	push dx
	mov dx, word ptr[bp+arg1]
	add dx, word ptr[bp+var4]
	push dx
	call _drawpixel
	add sp, 6
	
	mov dx, word ptr[bp+arg4]
	push dx
	mov dx, word ptr[bp+arg2]
	sub dx, word ptr[bp+var3]
	push dx
	mov dx, word ptr[bp+arg1]
	add dx, word ptr[bp+var4]
	push dx
	call _drawpixel
	add sp, 6
	
	mov dx, word ptr[bp+arg4]
	push dx
	mov dx, word ptr[bp+arg2]
	add dx, word ptr[bp+var3]
	push dx
	mov dx, word ptr[bp+arg1]
	sub dx, word ptr[bp+var4]
	push dx
	call _drawpixel
	add sp, 6
	
	mov dx, word ptr[bp+arg4]
	push dx
	mov dx, word ptr[bp+arg2]
	sub dx, word ptr[bp+var3]
	push dx
	mov dx, word ptr[bp+arg1]
	sub dx, word ptr[bp+var4]
	push dx
	call _drawpixel
	add sp, 6
	
	mov ax, word ptr[bp+var2]
	mov word ptr[bp+var1], ax
	mov ax, word ptr[bp+var3]
	add word ptr[bp+var1], ax
	mov ax, word ptr[bp+var1]
	mov dx, 0
	mov bx, 2
	imul bx
	sub ax, 1
	mov word ptr[bp+var1], ax
	
	cmp word ptr[bp+var2], 0
	jg _drawcircle_cyc2
	je _drawcircle_cyc2
	
	cmp word ptr[bp+var1], 0
	jg _drawcircle_cyc2
	inc word ptr[bp+var4]
	mov ax, 2
	mov dx, 0
	imul word ptr[bp+var4]
	add ax, 1
	add word ptr[bp+var2], ax
	jmp _drawcircle_cyc
	
_drawcircle_cyc2:
	mov ax, word ptr[bp+var2]
	sub ax, word ptr[bp+var4]
	mov bx, 2
	mov dx, 0
	imul bx
	sub ax, 1
	mov word ptr[bp+var1], ax
	
	cmp word ptr[bp+var2], 0
	jg _drawcircle_cyc3
	
	cmp word ptr[bp+var1], 0
	jg _drawcircle_cyc3
	
	inc word ptr[bp+var4]
	mov ax, word ptr[bp+var4]
	sub ax, word ptr[bp+var3]
	mov bx, 2
	mov dx, 0
	imul bx
	add word ptr[bp+var2], ax
	dec word ptr[bp+var3]
	jmp _drawcircle_cyc
	
_drawcircle_cyc3:
	dec word ptr[bp+var3]
	mov ax, 2
	mov dx, 0
	imul word ptr[bp+var3]
	mov bx, 1
	sub bx, ax
	add word ptr[bp+var2], bx
	jmp _drawcircle_cyc
   
_drawcircle endp  
    
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
    
	mov dx, 0Eh	;color
	push dx
    mov dx, 25 	;radius
    push dx
    mov dx, 100 	;y
    push dx
    mov dx, 160 	;x
    push dx
    call _drawcircle
    add sp, 8

    call _getchar
  
    mov dx, 02h
    push dx
    call _setmode
    add sp, 2
    
    call _exit0
code ends

end start