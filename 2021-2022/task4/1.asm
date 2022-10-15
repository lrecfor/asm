_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
newline db 0Dh, 0Ah
digits db "0123456789"
num1 dw ?           ; число
snum1 db 15 dup(?)   ; строка для храниния числа
lnum1 dw ?           ; длина строки с числом
num2 dw ?            ; число
snum2 db 15 dup(?)   ; строка для храниния числа
lnum2 dw ?           ; длина строки с числом
new_line db 0ah,0dh
_data ends

_code segment para public

assume cs:_code,ds:_data,ss:_stack

atoi: ; в регистре bx - адрес строки c числом, в регистре si - длина числа, функция возвращает в регистре di полученное число	
	xor ax, ax
	
	strint:
	mov dx, 10
	mov cl, byte ptr[bx]
	
	cmp cl, 0dh 
	jz exit
	
	sub cl, '0'
	mul dx
	add ax, cx
	inc bx
	
	jmp strint
	
	exit:
	mov di, ax
    ret

itoa: ; в регистре ax - число, в регистре bx - адрес строки для числа, в регистре si - адрес длины строки для числа, в di - количество разрядов	
	dec di
	
	intstr:
	xor dx, dx
	mov cx, 10
	div cx
	
	add dl, '0'
	mov byte ptr[bx+di], dl
	dec di
	
	test ax, ax
	jnz intstr
    ret

pstrf: ; в dx уже лежит адрес строки, а в cx - её длина
    mov ah, 40h
    mov bx, 1
    int 21h
    ret

sstrf: ; в dx уже лежит адрес строки, а в cx - её максимальная длина
    mov ah, 3fh
    mov bx, 0
    int 21h ; длина строки в ax (для отсечение первода строки и возрата каретки - уменьшить ax на 2)
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
	
intsize:
	xor cx, cx
	mov bx, 10
	
	m1:
	xor dx, dx
	div bx
	inc cx
	test ax, ax
	jnz m1
	
	exit_:
	mov ax, cx
	ret

start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
    
    mov dx, offset snum1
    mov cx, 15
    call sstrf
    mov word ptr [lnum1], ax
    
    mov bx, offset snum1
	mov si, word ptr [lnum1]
    call atoi
    mov word ptr [num1], di
	mov word ptr [num2], di
    add word ptr [num2], 12345
	
	mov ax, word ptr [num2]	
	call intsize
	mov di, ax
	mov word ptr [lnum2], di
    
	mov ax, word ptr [num2]	
    mov bx, offset snum2
	mov si, offset lnum1
	call itoa

    mov cx, word ptr [lnum1]
    mov dx, offset snum1
    call pstrf
    call pnewf
    mov cx, word ptr [lnum2]
    mov dx, offset snum2
    call pstrf

	call exit0f
_code ends

end start