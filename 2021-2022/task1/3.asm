_stack segment para stack
db 240 dup(?)
_stack ends

_data segment para public
buf db 240 dup('$')
enter_ db "enter:", 0Dh, 0Ah, "$"
caret_ db 0Dh, 0Ah, "$"
result_ db "result:", 0Dh, 0Ah, "$"
_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack

start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
	
	mov ah,09h
    mov dx, offset enter_
    int 21h
	
	mov ah,0Ah
	mov dx,offset buf
    int 21h
	
	mov ah,09h
    mov dx, offset caret_
    int 21h
	
    mov ah,09h
    mov dx, offset result_
    int 21h
	
	mov ah, 09h
	mov dx, offset buf+2
	int 21h
       
    mov ah, 4ch
	int 21h
_code ends

end start