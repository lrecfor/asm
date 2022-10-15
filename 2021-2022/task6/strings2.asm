; Функции для ввода-вывода строк/символов (используется соглашение cdecl)
; Д.И. Панасенко 16.04.2020

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
str2 db "Hello, World!", 0
data ends

code segment para public 

assume cs:code,ds:data,ss:stack

include strings.inc
    
; void test()
; функция для демонстрации работы ввода-вывода
_test proc near
    push bp
    mov bp, sp
    
    ; ввод-вывод символа
    call _getchar
    
    push ax
    call _putchar
    add sp, 2
    
    call _putnewline
    
    ; ввод строки
    mov dx, 256
    push dx
    mov dx, offset str1
    push dx
    call _getstr
    add sp, 4
    
    ; вывод строк
    mov dx, offset str1
    push dx
    call _putstr
    add sp, 2
    
    call _putnewline
    
    mov dx, offset str2
    push dx
    call _putstr
    add sp, 2
    
    mov sp, bp
    pop bp
    ret
_test endp
 
start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    
    call _test
    
    call _exit0
code ends

end start