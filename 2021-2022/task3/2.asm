_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
num dw ?
numstr db '$$$$$' 
_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack

start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
	   
    mov num, 0
	
print:
	mov ah, 2
	mov dl, num
	int 21h
	
	mov si, offset numstr
	mov ax, num
	call number2string
	
	mov ah, 09h
	mov dx, offset numstr
	int 21h
	
	int num
	jmp start
	
    mov al, 0
    mov ah, 4ch
	int 21h
_code ends

end start