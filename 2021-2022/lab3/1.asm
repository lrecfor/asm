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
include funcs.inc
    
; void setmode(int mode)
; установка видеорежима (номер режима в младшем байте аргумента)    

; void drawpixel(int x, int y, int color)
; рисование пикселя (код цвета в младшем байте аргумента)    
_drawpixel proc near
    push bp
    mov bp, sp
	push ax
	push bx
	push cx
	push dx
    
    mov bh, 0
    mov cx, word ptr [bp + arg1]
    mov dx, word ptr [bp + arg2]
    mov ax, word ptr [bp + arg3]
    mov ah, 0ch
    int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
    mov sp, bp
    pop bp
    ret
_drawpixel endp 

;void _draw_line(int start_x, int start_y, int end_x, int end_y, int color)
;функция принимает 5 аргументов: x и y координаты начальной и конечной точки отрезка, цвет отрезка

;void _x_coord(int offset, int direct)
;функция высчитывает координату по x
_x_coord proc near
	push bp
    mov bp, sp
	sub sp, 14
	
	mov word ptr[bp+var7], -100	;-14
	mov word ptr[bp+var6], -86	;-12
	mov word ptr[bp+var5], -50	;-10
	mov word ptr[bp+var4], 0	;-8
	mov word ptr[bp+var3], 50	;-6
	mov word ptr[bp+var2], 86	;-4
	mov word ptr[bp+var1], 100	;-2
	
	mov si, word ptr[bp+arg1]
	mov di, word ptr[bp+arg2]
	
	mov bx, word ptr[bp+si]
	
	cmp si, -14
	jz _x_coord_rev
	cmp si, -2
	jz _x_coord_rev2
	
	jmp _x_coord_ret

_x_coord_rev:
	neg di
	jmp _x_coord_ret

_x_coord_rev2:
	cmp di, 2
	jz _x_coord_rev
	jmp _x_coord_ret
	
_x_coord_ret:
	mov sp, bp
    pop bp
	ret
_x_coord endp

;void _y_coord(int offset, int direct)
;функция высчитывает координату по y
_y_coord proc near
	push bp
    mov bp, sp
	sub sp, 14
	
	mov word ptr[bp+var7], 0
	mov word ptr[bp+var6], 50
	mov word ptr[bp+var5], 86
	mov word ptr[bp+var4], 100
	mov word ptr[bp+var3], 86
	mov word ptr[bp+var2], 50
	mov word ptr[bp+var1], 0
	
	mov si, word ptr[bp+arg1]
	mov di, word ptr[bp+arg2]
	
	mov bx, word ptr[bp+si]
	
	cmp si, -14
	jz _y_coord_rev
	cmp si, -2
	jz _y_coord_rev2
	
	cmp di, 2
	jz _y_coord_neg
	jmp _y_coord_ret

_y_coord_rev:
	neg di
	jmp _y_coord_ret

_y_coord_rev2:
	cmp di, 2
	jz _y_coord_rev
	jmp _y_coord_ret
	
_y_coord_neg:
	neg bx
		
_y_coord_ret:
	mov sp, bp
    pop bp
	ret
_y_coord endp

;void _draw_square()
;выводит квадрат размером 4х4
_draw_square proc near
	push bp
    mov bp, sp
	sub sp, 4
	
	mov dx, word ptr[bp+arg1] 
	mov word ptr[bp+var2], dx ;x
	mov dx, word ptr[bp+arg2]
	mov word ptr[bp+var1], dx ;y
	
	mov dx, word ptr[bp+arg3]
	push dx
	mov dx, word ptr[bp+var1]
	push dx
	mov dx, word ptr[bp+var2]
	push dx
	call _drawpixel
	add sp, 6
	
	sub word ptr[bp+var1], 1
	
	mov dx, word ptr[bp+arg3]
	push dx
	mov dx, word ptr[bp+var1]
	push dx
	mov dx, word ptr[bp+var2]
	push dx
	call _drawpixel
	add sp, 6
	
	add word ptr[bp+var2], 1
	add word ptr[bp+var1], 1
	
	mov dx, word ptr[bp+arg3]
	push dx
	mov dx, word ptr[bp+var1]
	push dx
	mov dx, word ptr[bp+var2]
	push dx
	call _drawpixel
	add sp, 6
	
	sub word ptr[bp+var1], 1
	
	mov dx, word ptr[bp+arg3]
	push dx
	mov dx, word ptr[bp+var1]
	push dx
	mov dx, word ptr[bp+var2]
	push dx
	call _drawpixel
	add sp, 6
	
	mov sp, bp
    pop bp
	ret
_draw_square endp

;void _draw_squares(int x, int y)
;вызывает функцию для вывода квадрата
_draw_squares proc near
	push bp
    mov bp, sp
	sub sp, 4
	
	mov dx, word ptr[bp+arg1]
	mov word ptr[bp+var2], dx ;x
	mov dx, word ptr[bp+arg2]
	mov word ptr[bp+var1], dx ;y
	
	cmp word ptr[bp+var1], 100
	jz _square_1
	jge _square_3
	cmp word ptr[bp+var1], 14
	jge _square_2
	
_square_1:
	cmp word ptr[bp+var2], 260
	jz _square_1_draw
	jmp _draw_squares_ret
_square_1_draw:
	mov dx, 4h
	push dx
	mov dx, 100
	push dx
	mov dx, 240
	push dx
	call _draw_square
	add sp, 6
	jmp _draw_squares_ret
	
_square_2:
	cmp word ptr[bp+var1], 50
	jle _square_2_x
	jmp _draw_squares_ret
_square_2_x:
	cmp word ptr[bp+var2], 210
	jge _square_2_dop
	jmp _draw_squares_ret
_square_2_dop:
	cmp word ptr[bp+var2], 246
	jl _square_2_draw
	jmp _draw_squares_ret
_square_2_draw:
	mov dx, 4h
	push dx
	mov dx, 50
	push dx
	mov dx, 210
	push dx
	call _draw_square
	add sp, 6
	jmp _draw_squares_ret
	
_square_3:
	cmp word ptr[bp+var1], 150
	jle _square_3_x
	jmp _draw_squares_ret
_square_3_x:
	cmp word ptr[bp+var2], 74
	jle _square_3_draw
	jmp _draw_squares_ret
_square_3_draw:
	mov dx, 4h
	push dx
	mov dx, 120
	push dx
	mov dx, 80
	push dx
	call _draw_square
	add sp, 6
	
_draw_squares_ret:
	mov sp, bp
    pop bp
	ret
_draw_squares endp

; void radar()    
; основная функция радара (вызывает нужные функции) 
_radar proc near
    push bp
    mov bp, sp
	sub sp, 14
	
	mov dx, 13h
    push dx
    call _setmode
    add sp, 2
		
	xor dx, dx
	mov word ptr[bp+var7], 0 ;y for squares
	mov word ptr[bp+var6], 0 ;x for squares
	mov word ptr[bp+var5], dx
	mov word ptr[bp+var4], -2   ;-2 ;di, y
	mov word ptr[bp+var3], -2	;-2 ;si, y
	mov word ptr[bp+var2], -2   ;-2 ;di, x
	mov word ptr[bp+var1], -2  ;-2 ;si, x

_radar_set_time:
	mov ah, 00h
	int 1Ah
	add dx, 9
	mov word ptr[bp+var5], dx
	
_radar_check_time:	
	mov ah, 01h
	int 16h
	jnz _radar_ret
	
	mov ah, 00h
	int 1Ah
	cmp dx, word ptr[bp+var5]
	ja _radar_cyc_start
	jb _radar_check_time
	
_radar_cyc_start:
	mov dx, 13h
    push dx
    call _setmode
    add sp, 2

	mov dx, word ptr[bp+var7]
	push dx
	mov dx, word ptr[bp+var6]
	push dx
	call _draw_squares
	add sp, 4

	mov bx, 2 ;green
	push bx
	
	mov bx, word ptr[bp+var4]
	push bx
	mov bx, word ptr[bp+var3]
	push bx
	call _y_coord
	add sp, 4
	add bx, 100
	push bx ;end_y
	mov word ptr[bp+var7], bx
	mov word ptr[bp+var4], di
	mov word ptr[bp+var3], si 
	
	mov bx, word ptr[bp+var2]
	push bx
	mov bx, word ptr[bp+var1]
	push bx
	call _x_coord
	add sp, 4 
	add bx, 160
	push bx ;end_x
	mov word ptr[bp+var6], bx 
	mov word ptr[bp+var2], di
	mov word ptr[bp+var1], si
	
	mov bx, 100 ;start_y
	push bx
	mov bx, 160 ;start_x
	push bx
	call _draw_line
	add sp, 10
	
	mov di, word ptr[bp+var4]
	add word ptr[bp+var3], di
	mov di, word ptr[bp+var2]
	add word ptr[bp+var1], di
	
	jmp _radar_set_time
	
_radar_ret:
    mov dx, 02h
    push dx
    call _setmode
    add sp, 2
    
    mov sp, bp
    pop bp
    ret
_radar endp
    
start: ; вызов функции radar (модифицировать главную функцию программы не требуется)
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
	
	call _radar
	
    call _exit0
code ends

end start