_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
str2 db 256 dup(?)
_data ends

_code segment para public

assume cs:_code, ds:_data, ss:_stack

start:
    mov ax, _data 
    mov ds, ax
    mov ax, _stack
    mov ss, ax
    
    mov dl, 'D' 
    mov ah, 02h   
    int 21h

    mov al, 0   
    mov ah, 4ch 
    int 21h     
_code ends

end start
	