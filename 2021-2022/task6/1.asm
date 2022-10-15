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
str1 db 256 dup(?)
str2 db 256 dup(?)
strstr_null db "strstr: arg2 is null",0Ah,0Dh, 0

data ends

code segment para public 

assume cs:code,ds:data,ss:stack

include strings.inc
 
start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    
    mov dx, 256
    push dx
    mov dx, offset str1
    push dx
    call _getstr
    add sp, 4
	
	mov dx, 256
    push dx
    mov dx, offset str2
    push dx
    call _getstr
	add sp, 4
	
	mov dx, offset str1
	mov si, offset str2
	
	;mov al, 'd'

	push si
	push dx
	;call _strcat
	;call _strcmp
	;call _strchr
	call _strstr
	;call _strcpy
	
	call _print_ax
	
	push dx
    call _putstr
    add sp, 2
	
	call _putnewline
	
	push si
    call _putstr
    add sp, 2
	
	call _putnewline
	
    call _exit0
code ends

end start