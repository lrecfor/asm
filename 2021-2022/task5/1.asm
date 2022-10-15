_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
from db 100 
     db ? 
	 db 100 dup(0)
to db 100 
   db ? 
   db 100 dup(0)
buf db ?	 
wrt1 db "from: $"
wrt2 db 13,10,"to: $"
handle1 dw ?
handle2 dw ?
newline db 0Dh, 0Ah
_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack

_print_ax proc near
	push bx
	push cx
	push dx
	push ax
	
	test ax, ax
	jns m
	
	mov  cx, ax
	mov  ah, 02h
	mov  dl, '-'
	int  21h
	mov  ax, cx
	neg  ax

	m:
	xor cx, cx
	mov bx, 10
	
	m1:
	xor dx, dx
	div bx
	
	push dx
	inc cx
	
	test ax, ax
	jnz m1
	
	mov ah, 02h
	
	output:
	pop dx
	add dl, '0'
	int 21h
	
	loop output
	;call _putnewline
	
	pop ax
	pop dx
	pop bx
	pop cx
	ret
_print_ax endp

	
start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
	
	mov ah, 09h
	lea dx, wrt1
	int 21h
	
	mov ah, 0ah
	mov dx, offset from
	int 21h
	
	mov si, offset from+1
	mov cl, [si]
	mov ch, 0
	inc cx
	add si, cx
	mov al, 0
	mov [si], al
	
	mov ah, 3Dh
	mov al, 0
	mov dx, offset from+2
	int 21h
	mov handle1, ax
	
	mov ah, 09h
	lea dx, wrt2
	int 21h
	
	mov ah, 0ah
	mov dx, offset to
	int 21h
	
	mov ah, 40h
    mov cx, 2
    mov bx, 1
    mov dx, offset newline
    int 21h
	
	mov si, offset to+1
	mov cl, [si]
	mov ch, 0
	inc cx
	add si, cx
	mov al, 0
	mov [si], al
	
	mov ah, 3ch
	mov cx, 0
	mov dx, offset to+2
	int 21h
	mov handle2, ax

	copy:
	push bx
	push dx
	push cx
	mov ah, 3fh
	mov bx, handle1
	mov cx, 1
	mov dx, offset buf
	int 21h
	
	cmp ax, 0
	je eof
	
	mov ah, 40h
	mov bx, 1
	mov dx, offset buf
	mov cx, 1
	int 21h
	
	pop bx
	pop dx
	pop cx
	jmp copy
	
	eof:
	mov ah, 3eh                    
    mov bx, handle1               
    int	21h
	
	mov ah, 3eh                    
    mov bx, handle2                
    int	21h
		
    mov al, 0
    mov ah, 4ch
	int 21h
_code ends

end start