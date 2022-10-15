; Функции для файлового ввода-вывода (используется соглашение cdecl)
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
fname1 db 256 dup(?)
buf1 db 256 dup(?)
fcorrect db "Open OK!", 0
ferror db "Open error!", 0
data ends

code segment para public 

assume cs:code,ds:data,ss:stack

include strings.inc
include files.inc
    
; void test()
; функция для демонстрации работы ввода-вывода
_test proc near
    push bp
    mov bp, sp
    sub sp, 2
    
    ; ввод имени файла
    mov dx, 256
    push dx
    mov dx, offset fname1
    push dx
    call _getstr
    add sp, 4
    
    ;открытие файла
    mov dx, 0
    push dx
    mov dx, offset fname1
    push dx
    call _fopen
    add sp, 4
    
    cmp ax, -1
    je testerr
    
    ; открытие успешно, сохраняем дескриптор в локальную переменную
    mov word ptr [bp + var1], ax
    mov dx, offset fcorrect
    push dx
    call _putstr
    add sp, 2
    call _putnewline
    
    ;читаем из файла в буфер buf1
    mov dx, offset buf1
    push dx
    mov dx, 255
    push dx
    mov dx, word ptr [bp + var1]
    push dx
    call _fread
    add sp, 6
    
    cmp ax, -1
    je testret
    
    ; вывод буфера
    mov dx, offset buf1
    push dx
    call _putstr
    add sp, 2
    call _putnewline
    
    jmp testret

testerr:
    mov dx, offset ferror
    push dx
    call _putstr
    add sp, 2
    call _putnewline
    jmp testret

testret:    
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