; Функции для ввода-вывода строк/символов (используется соглашение cdecl)
; Д.И. Панасенко 16.04.2020

; void putchar(int c)
; выводит символ на экран (младший байт переданного аргумента)
_putchar proc near
    push bp
    mov bp, sp
    
    mov dx, word ptr [bp + 4]
    mov ah, 02h
    int 21h
    
    mov sp, bp
    pop bp
    ret
_putchar endp    
    
; int getchar()
; читает символ с клавиатуры и возвращает его (считанный символ - младший байт (al) регистра ax)
_getchar proc near
    push bp
    mov bp, sp
    
    mov ah, 01h
    int 21h
    
    mov sp, bp
    pop bp
    ret
_getchar endp

; int strlen(const char *str)
; находит длинну строки (до завершающего нуля), адрес которой является аргументом
_strlen proc near
    push bp
    mov bp, sp
    
    mov bx, word ptr [bp + 4] 
    xor ax, ax ; счётчик (ax)

lencyc:    
    cmp byte ptr [bx], 0
    je lenret
    inc ax
    inc bx
    jmp lencyc
    
lenret:    
    mov sp, bp
    pop bp
    ret
_strlen endp
    
; void putstr(const char *str)
; выводит строку на экран (до завершающего нуля), адрес которой передан в качестве аргумента
_putstr proc near
    push bp
    mov bp, sp
    
    ; находим длину строки
    push word ptr [bp + 4] 
    call _strlen
    add sp, 2
    
    ; выводим строку
    mov cx, ax
    mov dx, word ptr [bp + 4]
    mov ah, 40h
    mov bx, 1
    int 21h
    
    mov sp, bp
    pop bp
    ret
_putstr endp
    
; void getstr(const char *str, int max_len)
; читает строку с клавиатуры (либо max_len - 1 байт, либо до перевода строки) и сохраняет её в память, 
; при этом дописывает в конец строки завершающий 0
_getstr proc near
    push bp
    mov bp, sp
    
    dec word ptr [bp + 6] ; уменьшаем требуемую длину на 1 (max_len - 1)
    mov bx, word ptr [bp + 4] ; адрес начала строки
    mov si, 0 ; счётчик
 
getscyc: 
    cmp si, word ptr [bp + 6]
    je getsret
    
    call _getchar
    
    cmp al, 10
    je getsret
    cmp al, 13
    je getsret
    
    mov byte ptr [bx], al
    inc bx
    inc si
    jmp getscyc
    
getsret:
    mov byte ptr [bx], 0
    call _putnewline
    mov sp, bp
    pop bp
    ret
_getstr endp

; void putnewline()
; выводит на экран возврат каретки (\r) и перевод строки (\n), т.е. переводит вывод на новую строку
_putnewline proc near
    push bp
    mov bp, sp
    
    mov dx, 10
    push dx
    call _putchar
    add sp, 2
    
    mov dx, 13
    push dx
    call _putchar
    add sp, 2
    
    mov sp, bp
    pop bp
    ret
_putnewline endp

; void exit(int code)
; завершает работу программы с кодом, переданным в качетве аргумента (кодом является младший байт аргумента)  
_exit proc near
    push bp
    mov bp, sp
    
    mov ax, word ptr [bp + 4]
    mov ah, 4ch
	int 21h
    
    mov sp, bp
    pop bp
    ret
_exit endp
    
; void exit0()
; завершает работу программы с кодом 0 
_exit0 proc near
    push bp
    mov bp, sp
    
    mov dx, 0
    push dx
    call _exit
    add sp, 2
    
    mov sp, bp
    pop bp
    ret
_exit0 endp

;char * strstr (const char *str, const char *strSearch)  
;поиск первого вхождение строки strSearch в строке str, возвращает 0 если нет вхождений, 
;иначе указатель на первое вхождение, если strSearch нулевой длины, то возвращ указ на начало строки str
_strstr proc near
    push bp
    mov bp, sp
	push dx
	
	mov bx, word ptr[bp+arg1]
	mov di, word ptr[bp+arg2]
	mov cx, bx
	
	push si
	call _strlen
	add sp, 2
	
	mov bx, cx
	xor cx, cx
	
	cmp ax, 0
	je strstr_null_
	jmp strstr_cyc
	
strstr_cyc:    
	mov dl, byte ptr [bx]
	mov dh, byte ptr [di]
	
	cmp dl, 0
	je strstr_end1
	
	cmp dh, 0
	je strstr_found
	
	cmp dl, dh
	je strstr_count

	inc bx
	
	jmp strstr_cyc
	
strstr_count:
	inc bx
	inc di
	inc cx
	jmp strstr_cyc
	
strstr_end1:
	cmp dh, 0
	je strstr_found
	jmp strstr_no
	
strstr_found:
	mov ax, bx
	sub ax, cx
	;mov di, ax
	jmp strstr_ret
	
strstr_no:
	mov di, 0
	jmp strstr_ret
	
strstr_null_:
	;mov bx, offset strstr_null
	push bx
	call _print
	add sp, 2
	
strstr_ret:
	pop dx
    mov sp, bp
    pop bp
    ret 4
_strstr endp

;char * strcpy (char *dst, const char *src) 
;копирует строку src в строку dest, копирование вместе с \0, возвращает указатель на dest 
_strcpy proc near
    push bp
    mov bp, sp
	
	mov bx, word ptr[bp+arg1]
	mov di, word ptr[bp+arg2]
	
	xor cx, cx
	
strcpy_cyc:    
	mov	dl, byte ptr[di]
	mov byte ptr[bx], dl
	
	cmp	byte ptr[di], 0
	je strcpy_ret
	
	inc	bx
	inc di
	jmp	strcpy_cyc
	
strcpy_ret:
	mov di, cx
    mov sp, bp
    pop bp
    ret 4
_strcpy endp

;int strcmp (const char *string1, const char *string2) 
;сравнение строк, возвращает <0 string1<string2, =0 string1=string2, >0 string1>string2
_strcmp proc near
	push bp
    mov bp, sp
	push dx
	
	mov bx, word ptr[bp+arg1]
	mov di, word ptr[bp+arg2]
	
strcmp_cyc:    
	mov dl, byte ptr [bx]
	mov dh, byte ptr [di]
	
	cmp dl, 0
	je equal
	
	inc bx
	inc di
	
	cmp dl, dh
	je strcmp_cyc 
	jl string1_string2
	jg string2_string1
	
string1_string2:
	mov ax, -1
	jmp strcmp_ret
	
equal:
	cmp dh, 0
    jne string1_string2
	mov ax, 0
	jmp strcmp_ret
	
string2_string1:
	mov ax, 1
    jmp strcmp_ret
	
strcmp_ret:
    pop dx
	mov sp, bp
    pop bp	
    ret 4
_strcmp endp

;char * strchr (const char *str, int c) 
;поиск первого вхождения символа с в строку str, возвращает указатель на символ, если не найден 0
_strchr proc near
    push bp
    mov bp, sp
	push dx
   
    mov bx, word ptr[bp+arg1]
	
	xor cx, cx
	
strchr_cyc:
	mov dl, byte ptr [bx]
	
	cmp dl, al
	je strchr_ret
	
	inc bx
	inc cx
	
    cmp dl, 0
	je strchr_no
	
	jmp strchr_cyc
	
strchr_no:
	mov cx, 0
	jmp strchr_ret
	
strchr_ret:
	mov di, cx 	
	pop dx
    mov sp, bp
    pop bp
    ret 2
_strchr endp

;char * strcat (char *dst, const char *src) 
;конкатенация, \0, возвращает указатель на dest
_strcat proc near
    push bp
    mov bp, sp
	
	mov bx, word ptr[bp+arg1]
	mov di, word ptr[bp+arg2]
		
strcat_cyc:  
	mov dl, byte ptr [bx]
	
	cmp dl, 0
	je strcat_move
	
	inc bx
	jmp strcat_cyc
	
strcat_move:
	mov al, byte ptr[di]
	mov byte ptr[bx], al
	
	cmp byte ptr[di], 0
	je strcat_ret
	
	inc di
	inc bx
	jmp strcat_move

strcat_ret:
	mov di, 0 
    mov sp, bp
    pop bp
    ret 4
_strcat endp

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
	call _putnewline
	
	pop ax
	pop dx
	pop bx
	pop cx
	ret
_print_ax endp

_print proc near
	push bx
	push cx
	push dx
	push ax
	
    push bx
	call _putstr
	add sp, 2
	
	pop ax
	pop dx
	pop bx
	pop cx
	ret
_print endp