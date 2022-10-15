_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
str db "Hello, World!",0Dh,"$"
_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack

start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
	
	mov dx, offset str
	mov ah, 09h
	int 21h
       
    mov ah, 4ch
	int 21h
_code ends

end start