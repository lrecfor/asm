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
include flag.inc

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
	push ax
	push dx
	mov ax, dx
	mov di, 320
	mul di
	add ax, bx
	mov dx, ax
	mov di, dx
	pop dx
	pop ax
	
	stosb
	inc bx
	dec cx
	
	cmp cx, 0
	jz _draw_line_x_ret
	
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
	
	push dx
	mov ax, dx
	mov di, 320
	mul di
	add ax, bx
	mov dx, ax
	mov di, dx
	pop dx
	
	mov cx, word ptr [bp + arg3] ;len
	mov ax, word ptr [bp + arg4] ;color
	
_draw_line_y_cyc: 
	stosb
	add di, 319
	dec cx
	
	cmp cx, 0
	jz _draw_line_y_ret
	
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

    mov dx, 13h
    push dx
    call _setmode
    add sp, 2
	
	mov ax, 0A000h
    mov es, ax
    
	; mov dx, 4h		;color
	; push dx
    ; mov dx, 320 	;len
    ; push dx
    ; mov dx, 100 	;start_y
    ; push dx
    ; mov dx, 0 		;start_x
    ; push dx
    ; call _draw_line_x
    ; add sp, 8 
	
	; mov dx, 0Eh		;color
	; push dx
    ; mov dx, 200		;len
    ; push dx
    ; mov dx, 0 		;start_y
    ; push dx
    ; mov dx, 160 	;start_x
    ; push dx
    ; call _draw_line_y
	; add sp, 8
	
	call _draw_island

    call _getchar
  
    mov dx, 02h
    push dx
    call _setmode
    add sp, 2
    
    call _exit0
code ends

end start