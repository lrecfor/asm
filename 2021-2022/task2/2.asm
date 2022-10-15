_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
str_ db 240 dup(?)
_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack

start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
    
    mov ah, 03fh
    mov bx, 0 
	mov dx, offset str_
	mov cx, 240
    int 21h
    
	mov cx, ax
    mov ah, 040h
	mov bx, 1
    mov dx, offset str_
    int 21h
    
    mov al, 0
    mov ah, 4ch
	int 21h
_code ends

end start