_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
str db ': ', '$'
_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack

start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
	
	mov ah, 02h       
    mov dl, 0      
    mov cx, 64	
char:
	int 21h
    inc dx
    mov dl, 20h
	int 21h
	pop dx
	inc dl
	test dl, 0fh
	
	jnz cont
	push dx
	mov dl, 0ah
	int 21h
	mov dl, 0dh
	int 21h
	pop dx
	
cont:
	loop char
	
	
	mov al, 0
    mov ah, 4ch
	int 21h
_code ends

end start