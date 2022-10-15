_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
newline db 0Dh, 0Ah
str db 256 dup(?)
strlen dw ?   
_data ends

_code segment para public 

assume cs:_code,ds:_data,ss:_stack

pcharf: ; в dl до вызова функци помещён код символа
    mov ah, 02h
    int 21h
    ret
   
pstrf: ; в dx уже лежит адрес строки, а в cx - её длина
    mov ah, 40h
    mov bx, 1
    int 21h
    ret
    
sstrf: ; в dx уже лежит адрес строки, а в cx - её максимальная длина
    mov ah, 3fh
    mov bx, 0
    int 21h
    ; длина строки в ax (для отсечение первода строки и возрата каретки - уменьшить ax на 2)
    dec ax
    dec ax
    ret

pnewf:
    mov dx, offset newline
    mov cx, 2
    call pstrf
    ret

exit0f:
    mov ah, 4ch
    mov al, 00h
	int 21h
    ret
    
start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
    
    mov dx, offset str
    mov cx, 255
    call sstrf
    
    mov bx, offset strlen 
    mov word ptr [bx], ax
    
    ; считали длину строки
    mov bx, offset strlen
    mov cx, word ptr [bx]
    mov dx, offset str
    call pstrf
    
    call pnewf
    
    mov dl, 'D'
    call pcharf
    
	call exit0f
_code ends

end start