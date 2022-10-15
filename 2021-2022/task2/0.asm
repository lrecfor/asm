_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
str_max db 240         ; максимальная длина строки
str_len db ?           ; реальная длина строки
str_str db 256 dup(?)  ; байты считанной строки
new_line db 0ah,0dh,'$'; перевод на новую строку
_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack

start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
    
    mov ah, 0ah
    mov dx, offset str_max
    int 21h
    
    mov ah, 09h
    mov dx, offset new_line
    int 21h
    
    mov bx, 0 ; xor bx, bx
    mov bl, byte ptr[str_len] ; в bx - реальная длина строки
    mov si, offset str_str
    mov byte ptr[si+bx], '$' ; помещаем в конец строки $
    mov ah, 09h
    mov dx, offset str_str
    int 21h
    
    mov al, 0
    mov ah, 4ch
	int 21h
_code ends

end start