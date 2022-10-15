; шаблон для зачётного задания №2 (калькулятор матриц)
; Д.И. Панасенко 14.04.2020

arg1 equ 4
arg2 equ 6
arg3 equ 8
arg4 equ 10

var1 equ -2
var2 equ -4
var3 equ -6
var4 equ -8
var5 equ -10

stack segment para stack
db 65530 dup(?)
stack ends

data1 segment para public
n1 dw ? ; число строк в матрице
m1 dw ? ; число столбцов в матрице
matr1 dw 30000 dup(?) ; матрица
fname1 db "file1.txt",0;256 dup(?)
error1_1 db "error: first file doesn't exist",0
error1_2 db "error: first matrix has wrong size",0
data1 ends

data2 segment para public
n2 dw ? ; число строк в матрице
m2 dw ? ; число столбцов в матрице
matr2 dw 30000 dup(?) ; матрица
fname2 db 256 dup(?)
error2_1 db "error: second file doesn't exist",0
error2_2 db "error: second matrix has wrong size",0
data2 ends

code segment para public 

assume cs:code,ss:stack,ds:data1,es:data2

include strings.inc
include files.inc
    
; int atoi(const char *str)
; функция перевода строки в число, возвращает в ax число
_atoi: 
    push bp
    mov bp, sp
	push bx
	push cx
	push dx
	push si
	
	mov bx, word ptr[bp+arg1]
	mov al, byte ptr[bx]
	cmp al, 10
	jz _atoi_13
	cmp al, 32
	jz _atoi_13
	cmp al, 13
	jz _atoi_13
	cmp al, 0
	jz _atoi_13
	xor ax, ax
	xor si, si
	
	cmp byte ptr[bx], '-'
	jz _atoi_neg
	jmp _atoi_cyc
	
_atoi_neg:
	mov si, 1 
	inc bx
	
_atoi_cyc:
	mov dx, 10
	mov cl, byte ptr[bx]
	
	cmp cl, 32
	jz _atoi_exit
	
	cmp cl, 13
	jz _atoi_exit
	
	cmp cl, 0
	jz _atoi_exit
	
	sub cl, '0'
	mul dx
	add ax, cx
	inc bx
	
	jmp _atoi_cyc
	
_atoi_exit:
	cmp si, 1 ;num is neg?
	jz _neg ;yes
	jmp _atoi_ret
	
_atoi_13:
	mov di, -1
	jmp _atoi_ret
	
_neg: 
	neg ax

_atoi_ret:
	pop si
	pop dx
	pop cx
	pop bx
    mov sp, bp
    pop bp
    ret
  

; void itoa(int num, char *str)
; функция перевода числа в строку    
_itoa: 
    push bp
    mov bp, sp
    
    mov sp, bp
    pop bp
    ret
    
; void readm1(const str *filename)   
; читает матрицу в сегмент ds, преобразуя считанные строки в числа
; выводит сообщение об ошибке, если файл с данным именем не существует
_readm1 proc near 
    push bp
    mov bp, sp
	sub sp, 10
	
	mov word ptr[bp+var5], offset matr1
	mov word ptr[bp+var4], 0
	mov word ptr[bp+var3], 0
	mov word ptr[bp+var2], 0
	
	mov dx, 0
    push dx
    mov dx, word ptr[bp+arg1] ;open file1 for reading
    push dx
	mov dx, 'ds'
	push dx
    call _fopen_seg
    add sp, 6
	
	mov word ptr [bp+var1], ax ;handle file1
	
	cmp ax, -1
	jz _readm1_error1
	
_readm1_size:
	mov ah, 3fh
	mov bx, word ptr [bp+var1]
	mov cx, 11
	mov dx, word ptr[bp+var2]
	int 21h
	
	push word ptr[bp+var2]
	call _atoi
	add sp, 2
	
	mov word ptr[n1], ax
	;mov ax, word ptr[n1]
	;call _print_ax
	
	mov ax, word ptr[n1]
	call _intsize
	mov di, ax
	mov bx, ax
	inc bx
	push bx
	call _atoi
	add sp, 2
	
	mov word ptr[m1], ax	
	mov word ptr[bp+var3], ax
	;mov ax, word ptr[m1]
	;call _print_ax
	
	mov ax, word ptr[n1]
	call _intsize
	mov di, ax
	mov ax, word ptr[m1]
	call _intsize
	add di, ax
	add di, 3
	mov ax, di
	
	mov ax, 4200h
	mov bx, word ptr [bp+var1]
	mov cx, 0
	mov dx, di
	int 21h

	mov word ptr[bp+var2], 0
	xor si, si 
	xor di, di
	jmp _readm1_cyc

_readm1_error1:
	mov dx, offset error1_1
	push dx
	mov dx, 'ds'
	push dx
	call _putstr_seg
	add sp, 2
	jmp _readm1_ret
	
_readm1_cyc:
	mov dx, word ptr[bp+var2]
	push dx
	mov dx, 6
	push dx
	mov dx, word ptr [bp+var1]
	push dx
	call _fread
	add sp, 6
	
	cmp ax, 0
	je _tmp
	;je _readm1_ret
	
	push di
	push word ptr[bp+var2]
	call _atoi
	add sp, 2
	cmp di, -1
	je _tmp;_readm1_ret

	mov word ptr[bp+var2], 0
	mov word ptr[bp+var2], ax
	
	pop di
	mov bx, offset matr1
	add bx, word ptr[bp+var4]
	mov ax, word ptr[bp+var2]
	;mov word ptr[bx], ax
	;call _print_ax
	add word ptr[bp+var4], 2
	push di
	
	mov ax, word ptr[bp+var2]
	call _intsize
	mov di, ax
	mov ax, 6
	sub ax, di
	mov di, ax
	
	cmp di, 1
	jz  _readm1_5
	cmp di, 0
	jz  _readm1_6
	
	dec di
	neg di

	mov ax, 4201h
	mov bx, word ptr [bp+var1]
	mov cx, -1
	mov dx, di
	int 21h

	inc si
	cmp si, word ptr[bp+var3]
	jz _readm1_5
	
_readm1_cyc_rep:
	pop di
	
	jmp _readm1_cyc
	
_tmp: jmp _readm1_ret
	
_readm1_6:	
	mov ax, 4201h
	mov bx, word ptr [bp+var1]
	mov cx, 0
	mov dx, 1
	int 21h
	
	inc si
	cmp si, word ptr[bp+var3]
	jz _readm1_forward
	
	jmp _readm1_cyc_rep
	
_readm1_5:
	inc si
	cmp si, word ptr[bp+var3]
	jl _readm1_cyc_rep

_readm1_forward:
	mov ax, 4201h
	mov bx, word ptr [bp+var1]
	mov cx, 0
	mov dx, 1
	int 21h
	
_readm1_xor:
	xor si, si
	mov word ptr[bp+var2], 0
	jmp _readm1_cyc_rep
	
_readm1_ret:
	mov dx, word ptr [bp+var1]
	push dx
	mov dx, 'ds'
	push dx
	call _fclose_seg
    mov sp, bp
    pop bp
    ret
_readm1 endp

; void readm2(const str *filename)   
; читает матрицу в сегмент es, преобразуя считанные строки в числа
; выводит сообщение об ошибке, если файл с данным именем не существует
_readm2 proc near
    push bp
    mov bp, sp
	sub sp, 2
	
	mov dx, 0
    push dx
    mov dx, word ptr[bp+arg1] ;open file2 for reading
    push dx
	mov dx, 'es'
	push dx
    call _fopen_seg
    add sp, 6
	
    cmp ax, -1
	jz _readm2_error1
	
	mov word ptr [bp+var1], ax ;handle file2
	
	mov dx, offset matr2
	push dx
	mov dx, 30000
	push dx
	mov dx, word ptr [bp+var1]
	push dx
	mov dx, 'es'
	call _fread_seg
	add sp, 8
	
	mov dx, offset matr2
	push dx
	mov dx, 'ds'
	push dx
	call _putstr_seg
	add sp, 2
	
	jmp _readm2_ret
	
_readm2_error1: ;
	mov dx, offset error2_1
	push dx
	mov dx, 'es'
	push dx
	call _putstr_seg
	add sp, 2

_readm2_ret:
	mov dx, word ptr [bp+var1]
	push dx
	mov dx, 'es'
	push dx
	call _fclose_seg
    mov sp, bp
    pop bp
    ret
_readm2 endp

; void calc()    
; основная функция калькулятора (вызывает нужные функции) 
_calc:
    push bp
    mov bp, sp
	sub sp, 4
	
	;mov dx, 256
    ;push dx
    ;mov dx, offset fname1 ;get filename 1
    ;push dx
	;mov dx, 'ds'
	;push dx
    ;call _getstr_seg
    ;add sp, 4
	
	;mov dx, offset fname1 ;put filename 1
	;push dx
	;mov dx, 'ds'
	;push dx
	;call _putstr_seg
	;add sp, 2
	
	;mov dx, 256
    ;push dx
    ;mov dx, offset fname2 ;get filename 2
    ;push dx
	;mov dx, 'es'
	;push dx
    ;call _getstr_seg
    ;add sp, 4
	
	;mov dx, offset fname2 ;put filename 2
	;push dx
	;mov dx, 'es'
	;push dx
	;call _putstr_seg
	;add sp, 2
	
	;mov dx, 256
    ;push dx
    ;mov dx, word ptr[bp+var2] ;get filename 3
    ;push dx
    ;call _getstr
    ;add sp, 4
	
	;mov dx, word ptr[bp+var2] ;put filename 3
	;push dx
	;mov dx, 'ds'
	;push dx
	;call _putstr_seg
	;add sp, 2
	
	;call _getchar
	;mov word ptr[bp+var1], ax	;get sign
	;call _putnewline
	
	mov dx, offset fname1
    push dx 
	call _readm1	;read file1
	add sp, 2
	
	mov bx, offset matr1
	xor di, di
	ll22:
	mov ax, word ptr[bx]
	call _print_ax
	add bx, 2
	inc di
	cmp di, 20
	jl ll22
	
	;mov dx, offset fname2
    ;push dx 
	;call _readm2	;read file2
	;add sp, 2
    
    mov sp, bp
    pop bp
    ret

start: ; вызов функции calc (модифицировать главную функцию программы не требуется)
    mov ax, data1
    mov ds, ax
    mov ax, data2
    mov es, ax
    mov ax, stack
    mov ss, ax
	
    call _calc
	
	_mul:	;умножение матриц
	xor cx, cx
	mov ax, word ptr[n1]
	mov di, word ptr es:[m2]
	mul di
	mov di, word ptr [m1]
	mul di
	mov di,ax
	
	_mul_cyc:
	mov ax, word ptr[si]
	mov dx, word ptr es:[bx]
	
	imul dx
	add cx, ax

	add word ptr [bp+var3], 1
	
	mov ax, word ptr[n1]
	mov dl, byte ptr es:[m2]
	mul dl
	mov dl, al
	mov ax, word ptr [bp+var3]
	div dl
	cmp ah, 0
	jz _next_string_matr1
	
	mov ax, word ptr [bp+var3]
	mov dl, byte ptr[m1]
	div dl
	cmp ah, 0
	jz _next2
	jmp _next1
	
	_next1:
	mov ax, word ptr[m1]
	mov dl, 2
	mul dl
	add bx, ax
	add si, 2
	jmp _mul_ret
	
	_next_string_matr1:
	mov ax, cx

	mov cx, word ptr[bp+var2]
	
	push bx
	mov bx, offset string
	call _itoa
	
	mov bx, cx
	call _intsize
	mov cx, ax
	
	mov ah, 40h
	mov dx, offset string
	int 21h
	
	_32_:
	mov ah, 40h
	mov dx, offset space
	mov cx, 1
	int 21h
	
	pop bx
	
	xor cx, cx
	mov si, offset matr1
	mov ax, word ptr[m1]
	mov dl, 2
	mul dl
	add word ptr [bp+var5], ax
	add si, word ptr [bp+var5]
	mov bx, offset matr2
	mov word ptr[bp+var4], 0
	jmp _mul_ret
	
	_next2:
	mov ax, cx
	
	mov cx, word ptr[bp+var2]
	
	push bx
	mov bx, offset string
	call _itoa
	
	mov bx, cx
	call _intsize
	mov cx, ax
	
	mov ah, 40h
	mov dx, offset string
	int 21h
	
	_32__:
	mov ah, 40h
	mov dx, offset space
	mov cx, 1
	int 21h
	
	pop bx
	
	mov si, offset matr1
	add si, word ptr [bp+var5]
	add word ptr[bp+var4], 2
	mov bx, offset matr2
	add bx, word ptr[bp+var4]
	xor cx, cx
	
	_mul_ret:
	dec di
	cmp di, 0
	jz _ret
	jmp _mul_cyc
	
	
	
	////
	_multiplication proc near	;умножение матриц
	push bp
    mov bp, sp
	xor cx, cx
	mov ax, word ptr[n1]
	mov di, word ptr es:[m2]
	mul di
	mov di, word ptr [m1]
	mul di
	mov di,ax
	
	_mul_cyc:
	mov dx, word ptr es:[bx]
	mov ax, word ptr[si]
	
	imul dx
	add cx, ax

	add word ptr [bp+var3], 1
	
	mov ax, word ptr[n1]
	mov dl, byte ptr es:[m2]
	mul dl
	mov dl, al
	mov ax, word ptr [bp+var3]
	div dl
	cmp ah, 0
	jz _next_string_matr1
	
	mov ax, word ptr [bp+var3]
	mov dl, byte ptr[m1]
	div dl
	cmp ah, 0
	jz _next2
	jmp _next1
	
	_next1:
	mov ax, word ptr[m1]
	mov dl, 2
	mul dl
	add bx, ax
	add si, 2
	jmp _mul_ret
	
	_next_string_matr1:	;end
	mov ax, cx
	mov cx, word ptr[bp+var2]
	
	push bx
	mov bx, offset string
	call _itoa
	
	mov bx, cx
	call _intsize
	mov cx, ax
	
	mov ah, 40h
	mov dx, offset string
	int 21h
	
	mov ah, 40h
	mov dx, offset caret
	mov cx, 1
	int 21h
	pop bx
	
	xor cx, cx
	mov si, offset matr1
	mov ax, word ptr[m1]
	mov dl, 2
	mul dl
	add word ptr [bp+var5], ax
	add si, word ptr [bp+var5]
	mov bx, offset matr2
	mov word ptr[bp+var4], 0
	jmp _mul_ret
	
	_next2:
	mov ax, cx
	mov cx, word ptr[bp+var2]
	
	push bx
	mov bx, offset string
	call _itoa
	
	mov bx, cx
	call _intsize
	mov cx, ax
	
	mov ah, 40h
	mov dx, offset string
	int 21h
	
	mov ah, 40h
	mov dx, offset space
	mov cx, 1
	int 21h
	pop bx
	
	mov si, offset matr1
	add si, word ptr [bp+var5]
	add word ptr[bp+var4], 2
	mov bx, offset matr2
	add bx, word ptr[bp+var4]
	xor cx, cx
	
	_mul_ret:
	dec di
	cmp di, 0
	jz _multiplication_ret
	jmp _mul_cyc

_multiplication_ret:
	mov sp, bp
    pop bp
    ret
_multiplication endp




////mov cx, word ptr[bp+arg2]
	push bx
	mov bx, offset string
	call _itoa
	
	mov bx, cx
	call _intsize
	mov cx, ax
	
	mov ah, 40h
	mov dx, offset string
	int 21h
	
	mov ah, 40h
	mov dx, offset caret
	mov cx, 1
	int 21h
	pop bx
	
	
	call _exit0
code ends

end start