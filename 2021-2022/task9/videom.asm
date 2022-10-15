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

start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    
    mov dx, 3     ; текст 80х25 символов
    push dx
    call _setmode  
    add sp, 2
    
    mov ax, 0B800h
    mov es, ax
    
    mov bx, 0
    
    mov al, 'A'    ; на каждый символ - 2 байта, младший байт - код символа
    mov ah, 0E4h   ; страший байт - цвет фона/текста: старшие 4 бита - цвет фона, младшие 4 бита - цвет текста
    
    mov word ptr es:[bx], ax 
    mov word ptr es:[bx+2], ax   ; символ в следующей позиции
	mov word ptr es:[bx+4], ax 
    mov word ptr es:[bx+160], ax ; символ в начале следующей строки
    
    call _getchar
    
    call _exit0
code ends

end start