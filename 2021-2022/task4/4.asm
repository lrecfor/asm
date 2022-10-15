;output ax start
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
	
	;output ax end
	
	mov ax, word ptr [num2]
	;output ax start
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
	call exit0f
	
	;output ax end
	
	
	_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public

_data ends

_code segment para public

assume cs:_code,ds:_data,ss:_stack

start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
	
	mov ax, 453
    
    xor cx, cx
	mov bx, 10
	
	l1:
	xor dx, dx
	div bx
	push dx
	inc cx
	
	test ax, ax
	jnz l1
	
	mov ah, 02h
	
	l2:
	pop dx
	add dl, '0'
	int 21h
	loop l2
	
	mov ah, 4ch
	int 21h
_code ends

end start





\\\\\\\\\\\\\\\
;call _strstr
	push dx
	push ax
	mov ah, 09h
	mov dx, offset strstr
	int 21h
	pop ax
	pop dx
	
	;call _strcpy
	push dx
	push ax
	mov ah, 09h
	mov dx, offset strcpy
	int 21h
	pop ax
	pop dx
	
	push dx
    call _putstr
    add sp, 2
	
	;call _strcat
	push dx
	push ax
	mov ah, 09h
	mov dx, offset strcat
	int 21h
	pop ax
	pop dx

	call _strcmp
	push dx
	push ax
	mov ah, 09h
	mov dx, offset strcmp
	int 21h
	pop ax
	pop dx
	call _print_ax
	
	mov al, 'f'
	;call _strchr
	push dx
	push ax
	mov ah, 09h
	mov dx, offset strchr
	int 21h
	pop ax
	pop dx
	
	mov bx, dx
	mov ah, 02h
	mov dl, byte ptr[di+bx]
	int 21h
	
	call _exit0