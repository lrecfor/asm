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

;void _draw_line(int start_x, int start_y, int end_x, int end_y, int color)
;функция принимает 5 аргументов: x и y координаты начальной и конечной точки отрезка, цвет отрезка
_draw_line proc near
    push bp
    mov bp, sp
	sub sp, 14
	push bx
    
    mov cx, 1 
	mov dx, 1 
	
	mov di, word ptr [bp + arg4] ;end_y 
	sub di, word ptr [bp + arg2] ;start_y
	jge _draw_line_keep_y  
	neg dx 
	neg di  
	
_draw_line_keep_y: 
	mov word ptr[bp+var7], dx 
	
	mov si, word ptr [bp + arg3] ;end_x  
	sub si, word ptr [bp + arg1] ;start_x
	jge _draw_line_keep_x 
	neg cx 
	neg si 
	
_draw_line_keep_x: 
	mov word ptr[bp+var6], cx
	
	cmp si, di  
	jge _draw_line_horz_seg  
	mov cx, 0 
	xchg si, di
	jmp _draw_line_save_values 
	
_draw_line_horz_seg:
	mov dx, 0

_draw_line_save_values:
	mov word ptr[bp+var5], di 
	mov word ptr[bp+var4], cx
	mov word ptr[bp+var3], dx 
	
	mov ax, word ptr[bp+var5]  
	shl ax, 1 
	mov word ptr[bp+var2], ax  
	sub ax, si 
	mov bx, ax 
	sub ax, si  
	mov word ptr[bp+var1], ax 
	
	mov cx, word ptr [bp + arg1] 
	mov dx, word ptr [bp + arg2]
	inc si 
	mov al, byte ptr [bp + arg5] ;color
	 
_draw_line_mainloop:
	dec si 
	jz _draw_line_ret 
	mov ah, 12 
	int 10h  
	cmp bx, 0
	jge _draw_line_diagonal_line
	 
	add cx, word ptr[bp+var4] 
	add dx, word ptr[bp+var3] 
	add bx, word ptr[bp+var2]
	jmp short _draw_line_mainloop	
	 
_draw_line_diagonal_line:
	add cx, word ptr[bp+var6] 
	add dx, word ptr[bp+var7] 
	add bx, word ptr[bp+var1] 
	jmp short _draw_line_mainloop		
	
_draw_line_ret:
	pop bx
    mov sp, bp
    pop bp
    ret
_draw_line endp

; void drawpixel(int color, int x, int y) 
; рисование пикселя (код цвета в младшем байте аргумента)    
_drawpixel_v proc near
    push bp
    mov bp, sp
	push bx
	push dx
      
	mov bx, word ptr[bp+arg1]
	mov dx, word ptr[bp+arg2]
	
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
_drawpixel_v endp  

;void _draw_circle(int x, int y, int radius, int color)
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
	call _drawpixel_v
	add sp, 6
	
	mov dx, word ptr[bp+arg4]
	push dx
	mov dx, word ptr[bp+arg2]
	sub dx, word ptr[bp+var3]
	push dx
	mov dx, word ptr[bp+arg1]
	add dx, word ptr[bp+var4]
	push dx
	call _drawpixel_v
	add sp, 6
	
	mov dx, word ptr[bp+arg4]
	push dx
	mov dx, word ptr[bp+arg2]
	add dx, word ptr[bp+var3]
	push dx
	mov dx, word ptr[bp+arg1]
	sub dx, word ptr[bp+var4]
	push dx
	call _drawpixel_v
	add sp, 6
	
	mov dx, word ptr[bp+arg4]
	push dx
	mov dx, word ptr[bp+arg2]
	sub dx, word ptr[bp+var3]
	push dx
	mov dx, word ptr[bp+arg1]
	sub dx, word ptr[bp+var4]
	push dx
	call _drawpixel_v
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