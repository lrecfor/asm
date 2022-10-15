arg1 equ 4
arg2 equ 6
arg3 equ 8
arg4 equ 10
arg5 equ 12

var1 equ -2
var2 equ -4
var3 equ -6
var4 equ -8
var5 equ -10
var6 equ -12
var7 equ -14

stack segment para stack
db 65530 dup(?)
stack ends

data segment para public
data ends

code segment para public 

assume cs:code,ds:data,ss:stack

include strings.inc
;include brez.inc

;void _draw_line(int start_x, int start_y, int end_x, int end_y, int color)
;функция принимает 5 аргументов: x и y координаты начальной и конечной точки отрезка, цвет отрезка
_draw_line proc near
    push bp
    mov bp, sp
	sub sp, 14
    
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
	mov ah, 12h
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
    mov sp, bp
    pop bp
    ret
_draw_line endp  
    
start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    
	mov ah, 0
	mov al, 4h
	int 10h
	
	mov dx, 3 ;color
	push dx
	mov dx, 199 ;end_y
	push dx
	mov dx, 319 ;end_x
	push dx
	mov dx, 0 ;start_y
	push dx
	mov dx, 0 ;start_x
	push dx
	call _draw_line
	add sp, 10
	
	call _getchar 
	
	mov ah, 0 	
	mov al, 2	
	int 10h		
		
	call _exit0
code ends

end start