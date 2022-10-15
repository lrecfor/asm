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
str1 db "we don't need money to feel good cause you're the ride or die the rest of my life don't need a party to feel high we're like the modern version of Bonnie&Clyde", 0
color db 5 dup (?)
letters db "ABCDEF", 0
data ends

code segment para public 

assume cs:code,ds:data,ss:stack

include strings.inc

;void print_str_mem(char * str, int text_color, int box_color)
;функция осуществляюет посимвольный вывод строки в консоль с помощью записи в видеопамять
_print_str_mem proc near
	push bp
	mov bp, sp
	push dx
	
	mov si, word ptr[bp+arg1] ;string
	mov al, byte ptr[bp+arg3] ;box color
	
	cmp al, 10
	jl _print_str_mem_multi
	
	mov dx, offset letters
	push dx
	call _strchr
	add sp, 2
	
	add al, 10

_print_str_mem_multi:
	mov dl, 16
	mul dl
	
	mov cl, al
	
	mov dl, 1
	mov al, byte ptr[bp+arg2] ;text color
	mul dl
	add al, cl
	
	mov cl, al
	
	xor bx, bx
	xor di, di
	
_print_str_mem_cyc:
    mov al, byte ptr[si]    
    mov ah, cl
	
	cmp al, 0
	jz _print_str_mem_ret
    
    mov word ptr es:[bx+di], ax
	
	inc di
	inc di
	inc si

	jmp _print_str_mem_cyc

_print_str_mem_ret:
	pop dx 
	mov sp, bp
    pop bp
    ret
_print_str_mem endp

start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    
    mov dx, 3    
    push dx
    call _setmode  
    add sp, 2
    
    mov ax, 0B800h
    mov es, ax
    
	mov dx, 4 ;box color
	push dx
	mov dx, 7 ;text color
	push dx
	mov dx, offset str1 ;string
	push dx
    call _print_str_mem
    
    call _getchar
    
    call _exit0
code ends

end start