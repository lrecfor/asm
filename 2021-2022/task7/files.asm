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

; file_desc fopen(const str *filename, int mode)
; функция открытия файла (режим открытия в младшем байте второго аргумента)
; возвращает -1, если произошла ошибка, иначе возвращает дескриптор файла
_fopen proc near
    push bp
    mov bp, sp
    
    mov ax, word ptr [bp + arg2]
    mov ah, 3dh
    mov dx, word ptr [bp + arg1]
    int 21h
    
    jnc fopenret
    mov ax, -1

fopenret:    
    mov sp, bp
    pop bp
    ret
_fopen endp

; int fclose(file_desc f)
; функция закрытия файла
; возвращает -1, если произошла ошибка, иначе возвращает 0
_fclose proc near
    push bp
    mov bp, sp
    
    mov ah, 3eh
    mov bx, word ptr [bp + arg1]
    int 21h
    
    jnc fcloseret0
    mov ax, -1
    jmp fcloseret
    
fcloseret0: 
    mov ax, 0

fcloseret:    
    mov sp, bp
    pop bp
    ret
_fclose endp

; int fread(file_desc f, int size, char *buf)
; функция чтения из фалйа
; возвращает число прочитанных байт, в случае ошибки возвращает -1
_fread proc near
    push bp
    mov bp, sp
    
    mov ah, 3fh
    mov bx, word ptr [bp + arg1]
    mov cx, word ptr [bp + arg2]
    mov dx, word ptr [bp + arg3]
    int 21h
    
    jnc freadret
    mov ax, -1

freadret:    
    mov sp, bp
    pop bp
    ret
_fread endp

; int fwrite(file_desc f, int size, char *buf)
; функция записи в файл
; возвращает число записаных байт, в случае ошибки возвращает -1
_fwrite proc near
    push bp
    mov bp, sp
    
    mov ah, 40h
    mov bx, word ptr [bp + arg1]
    mov cx, word ptr [bp + arg2]
    mov dx, word ptr [bp + arg3]
    int 21h
    
    jnc fwriteret
    mov ax, -1

fwriteret:    
    mov sp, bp
    pop bp
    ret
_fwrite endp
    
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