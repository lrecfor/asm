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
fname1 db 256 dup(?)
result db 256 dup(?)
caret db 13,10
space db 32
string dw 12 dup(0)
error1_1 db "error: first file doesn't exist",0
data1 ends

data2 segment para public
n2 dw ? ; число строк в матрице
m2 dw ? ; число столбцов в матрице
matr2 dw 30000 dup(?) ; матрица
fname2 db 256 dup(?)
string2 dw 12 dup(0)
error2_1 db "error: second file doesn't exist",0
error2_2 db "error: matrixes sizes arent compatible",0
data2 ends

code segment para public 

assume cs:code,ss:stack,ds:data1,es:data2

include strings.inc
include files.inc
    
; int atoi(const char *str)
; функция перевода строки в число
_atoi: 
    push bp
    mov bp, sp
	push bx
	push cx
	push dx
	
	mov bx, word ptr[bp+arg1]
	mov al, byte ptr[bx]
	
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
	pop dx
	pop cx
	pop bx
    mov sp, bp
    pop bp
    ret
	
; void itoa(int num, char *str)
; функция перевода числа в строку    
; в регистре ax - число, в регистре bx - адрес строки для числа, в di - количество разрядов
_itoa: 
    push bp
    mov bp, sp
	push ax
	push cx
	push dx
	push di
	
	mov cx, ax
	call _intsize
	mov di, ax
	
	test cx, cx
	jns _itoa_st

	mov byte ptr[bx], '-'
	neg cx
	
	_itoa_st:
	mov ax, cx
	dec di
	
_itoa_cyc:
	xor dx, dx
	mov cx, 10
	div cx
	
	add dl, '0'
	mov byte ptr[bx+di], dl
	dec di
	
	cmp ax, 0
	jnz _itoa_cyc
    
	pop di
	pop dx
	pop cx
	pop ax
    mov sp, bp
    pop bp
    ret
    
; void readm1(const str *filename)   
; читает матрицу в сегмент ds, преобразуя считанные строки в числа
; выводит сообщение об ошибке, если файл с данным именем не существует
_readm1:
    push bp
    mov bp, sp
    sub sp, 6
	
	mov word ptr[bp+var3], 0
	mov word ptr[bp+var2], 0
	
	mov ax, 0
    mov ah, 3dh
    mov dx, word ptr[bp+arg1]	;open file1 for reading
    int 21h
	
	mov word ptr [bp+var1], ax ;handle file1

	cmp ax, -1
	jz _readm1_error1
	cmp ax, 2
	jz _readm1_error1
	jmp _readm1_size
	
_readm1_error1:
	mov dx, offset error1_1
	push dx
	mov dx, 'ds'
	push dx
	call _putstr_seg
	add sp, 2
	jmp _readm1_ret
	
_readm1_size:
	mov ah, 3fh
	mov bx, word ptr [bp+var1]
	mov cx, 11
	mov dx, offset string
	int 21h
	
	mov dx, offset string
	push dx
	call _atoi
	add sp, 2
	mov word ptr[n1], ax	;число строк n1

	call _intsize
	mov di, ax
	inc ax
	mov bx, offset string
	add bx, ax
	push bx
	call _atoi
	add sp, 2
		
	mov word ptr[m1], ax	;число столбцов m1
	
_readm1_pos:
	call _intsize
	add di, ax
	add di, 3
	
	mov ax, 4200h
	mov bx, word ptr [bp+var1]
	mov cx, 0
	mov dx, di
	int 21h

	xor di, di
	xor si, si
	mov word ptr[bp+var3], 0
	mov word ptr[bp+var2], 0
	mov bx, offset matr1

_readm1_cyc:
	mov cx, word ptr [bp+var1]
	push bx
	mov ah, 3fh
	mov bx, cx
	mov cx, 5
	mov dx, offset string
	int 21h
	pop bx
	
	mov dx, offset string
	push dx
	call _atoi
	add sp, 2
	
_readm1_put:
	mov word ptr [bx], ax
	add bx, 2
	
	add word ptr[bp+var2], 1
	
	mov si, word ptr[bp+var2]
	push ax
	push bx
	mov ax, word ptr[n1]
	mov bx, word ptr[m1]
	mul bx
	mov cx, ax
	pop bx
	pop ax
	cmp si, cx
	jz _readm1_tmp
	
	jmp _readm1_next
	
_readm1_tmp: jmp _readm1_ret
	
_readm1_next:
	call _intsize
	mov si, 5
	sub si, ax
	cmp si, 0
	jz _readm1_5
	dec si
	
	inc di
	cmp di, word ptr[m1]
	jz _readm1_13
	cmp si, 0
	jz _readm1_cyc
	
	neg si
	
	_readm1_move:
	mov cx, word ptr [bp+var1]
	push bx
	mov ax, 4201h
	mov bx, cx
	mov cx, -1
	mov dx, si
	int 21h
	pop bx
	jmp _readm1_cyc
	
	_readm1_13:
	cmp si, 0
	jz _readm1_4_13
	dec si
	neg si
	xor di, di
	jmp _readm1_move
	
	_readm1_4_13:
	xor di, di
	mov cx, word ptr [bp+var1]
	push bx
	mov ax, 4201h
	mov bx, cx
	mov cx, 0
	mov dx, 1
	int 21h
	pop bx
	jmp _readm1_cyc
	
	_readm1_5:
	inc di
	cmp di, word ptr[m1]
	jz _readm1_5_13
	mov cx, word ptr [bp+var1]
	push bx
	mov ax, 4201h
	mov bx, cx
	mov cx, 0
	mov dx, 1
	int 21h
	pop bx
	jmp _readm1_cyc
	
	_readm1_5_13:
	xor di, di
	mov cx, word ptr [bp+var1]
	push bx
	mov ax, 4201h
	mov bx, cx
	mov cx, 0
	mov dx, 2
	int 21h
	pop bx
	jmp _readm1_cyc
	
_readm1_ret:
	mov ah, 3eh                    
    mov bx, word ptr [bp+var1]        
    int	21h
    mov sp, bp
    pop bp
    ret
	
; void readm2(const str *filename)   
; читает матрицу в сегмент es, преобразуя считанные строки в числа
; выводит сообщение об ошибке, если файл с данным именем не существует
_readm2 proc near
    push bp
    mov bp, sp
	sub sp, 4
	
	mov word ptr[bp+var2], 0
	
	push ds
	mov cx, data2
	mov ds, cx

	mov ax, 0
    mov ah, 3dh
    mov dx, word ptr[bp+arg1]	;open file2 for reading
    int 21h
	
	pop ds
	
	cmp ax, -1
	jz _readm2_error1
	cmp ax, 2
    jz _readm2_error1
	
	mov word ptr [bp+var1], ax ;handle file2
	jmp _readm2_size
	
_readm2_error1: 
	mov dx, offset error2_1
	push dx
	mov dx, 'es'
	push dx
	call _putstr_seg
	add sp, 2
	jmp _readm2_ret
	
_readm2_size:
	mov cx, word ptr [bp+var1]
	mov ah, 3fh
	mov bx, cx
	mov cx, 11
	mov dx, offset string2
	int 21h
	
	mov dx, offset string2
	push dx
	call _atoi
	add sp, 2
	mov es:[n2], ax	;число строк n1
	
	call _intsize
	mov di, ax
	inc ax
	mov bx, offset string2
	add bx, ax
	push bx
	call _atoi
	add sp, 2
		
	mov es:[m2], ax	;число столбцов m1
	
_readm2_pos:
	call _intsize
	add di, ax
	add di, 3
	
	mov ax, 4200h
	mov bx, word ptr [bp+var1]
	mov cx, 0
	mov dx, di
	int 21h

	xor di, di
	xor si, si
	mov word ptr[bp+var2], 0
	mov bx, offset matr2

_readm2_cyc:
	mov cx, word ptr [bp+var1]
	push bx
	mov ah, 3fh
	mov bx, cx
	mov cx, 5
	mov dx, offset string2
	int 21h
	pop bx
	
	mov dx, offset string2
	push dx
	call _atoi
	add sp, 2
	
_readm2_put:
	mov word ptr es:[bx], ax
	add bx, 2

	add word ptr[bp+var2], 1

	mov si, word ptr[bp+var2]
	push ax
	push bx
	mov ax, word ptr es:[n2]
	mov bx, word ptr es:[m2]
	mul bx
	mov cx, ax
	pop bx
	pop ax
	cmp si, cx
	jz _readm2_tmp

	jmp _readm2_next
	
_readm2_tmp: jmp _readm2_ret
	
_readm2_next:
	call _intsize
	mov si, 5
	sub si, ax
	cmp si, 0
	jz _readm2_5
	dec si
	
	inc di
	cmp di, word ptr es:[m2]
	jz _readm2_13
	cmp si, 0
	jz _readm2_cyc
	
	neg si
	
	_readm2_move:
	mov cx, word ptr [bp+var1]
	push bx
	mov ax, 4201h
	mov bx, cx
	mov cx, -1
	mov dx, si
	int 21h
	pop bx
	jmp _readm2_cyc
	
	_readm2_13:
	cmp si, 0
	jz _readm2_4_13
	dec si
	neg si
	xor di, di
	jmp _readm2_move
	
	_readm2_4_13:
	xor di, di
	mov cx, word ptr [bp+var1]
	push bx
	mov ax, 4201h
	mov bx, cx
	mov cx, 0
	mov dx, 1
	int 21h
	pop bx
	jmp _readm2_cyc
	
	_readm2_5:
	inc di
	cmp di, es:[m2]
	jz _readm2_5_13
	mov cx, word ptr [bp+var1]
	push bx
	mov ax, 4201h
	mov bx, cx
	mov cx, 0
	mov dx, 1
	int 21h
	pop bx
	jmp _readm2_cyc
	
	_readm2_5_13:
	xor di, di
	mov cx, word ptr [bp+var1]
	push bx
	mov ax, 4201h
	mov bx, cx
	mov cx, 0
	mov dx, 2
	int 21h
	pop bx
	jmp _readm2_cyc

_readm2_ret:
	mov bx, word ptr [bp+var1]        
	push ds
	mov cx, data2
	mov ds, cx
	mov ah, 3eh                    
    int	21h
	pop ds
    mov sp, bp
    pop bp
    ret
_readm2 endp

_multiplication proc near	;умножение матриц
	push bp
    mov bp, sp
	
	_mns_2:	
	mov si, offset matr1
	mov bx, offset matr2

	mov cx, word ptr es:[m2]
	mov dx, word ptr[n1]
	push dx
	push si
	
	_loop11:
	push cx
	mov cx, word ptr[m1]
	xor di, di
	push bx
	push si
	
	_loop22:
	mov dx, word ptr es:[bx]
	mov ax, word ptr[si]
	
	push bx
	imul dx
	mov bx, 30000
	idiv bx
	add di, dx
	pop bx
	
	add si, 2
	
	push di
	push ax
	push bx
	mov ax, word ptr es:[m2]
	mov bx, 2
	mul bx
	mov di, ax
	pop bx
	pop ax

	add bx, di
	
	pop di
	loop _loop22
	
	mov ax, di
	mov cx, word ptr[bp+arg2]
	
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
	
	pop si
	pop bx
	add bx, 2
	
	pop cx
	dec cx
	cmp cx, 0
	jz _mns2_next_str
	jmp _loop11
	
	_mns2_next_str:
	pop si
	pop dx
	dec dx
	cmp dx, 0
	jz _multiplication_ret
	add si, word ptr[m1]
	add si, word ptr[m1]
	push dx
	push si
	
	mov bx, word ptr[bp+arg2]
	mov ah, 40h
	mov dx, offset caret
	mov cx, 1
	int 21h
	
	mov bx, offset matr2
	mov cx, word ptr es:[m2]
	jmp _loop11

_multiplication_ret:
	mov sp, bp
    pop bp
    ret
_multiplication endp

; void calc()    
; основная функция калькулятора (вызывает нужные функции) 
_calc:
    push bp
    mov bp, sp
	sub sp, 10
	
	mov word ptr [bp+var5], 0
	mov word ptr [bp+var4], 0
	mov word ptr [bp+var3], 0
	mov word ptr [bp+var2], 0
	
	mov dx, 256
    push dx
    mov dx, offset fname1 ;get filename 1
    push dx
    call _getstr
    add sp, 4
	
	mov dx, 256
    push dx
    mov dx, offset fname2 ;get filename 2
    push dx
	mov dx, 'es'
	push dx
    call _getstr_seg
    add sp, 4
	
	mov dx, 256
    push dx
    mov dx, word ptr[bp+var2] ;get filename 3
    push dx
    call _getstr
    add sp, 4
	
_result_file_open:
	mov ah, 3ch
	mov cx, 0
    mov dx, word ptr [bp+var2]	;open file for writing result
    int 21h
	
	mov word ptr [bp+var2], 0
	mov word ptr [bp+var2], ax 	;handle result file
	
	cmp ax, -1
	jz _tmp1
	
	call _getchar
	mov byte ptr[bp+var1], al	;get sign
	call _putnewline
	
	mov dx, offset fname1
    push dx 
	call _readm1	;read file1
	add sp, 2
	
	mov dx, offset fname2
    push dx 
	call _readm2	;read file2
	add sp, 2
	jmp _check_size
	
_tmp1: jmp _tmp

_check_size:	;проверка размеров матриц
	mov ax, word ptr[n1]
	mov si, word ptr[m1]
	mov bx, word ptr es:[n2]
	mov di, word ptr es:[m2]
	
	cmp word ptr[bp+var1], 42
	jz _m1n2
	
	cmp ax, bx
	jz _n1n2
	jmp _check_size_error
	
	_n1n2:
	cmp si, di
	jz _check_size_ok
	jmp _check_size_error
		
	_m1n2:
	cmp si, bx
	jz _check_size_ok
	jmp _check_size_error
	
_check_size_error:	;вывод сообщения об ошибке
	mov dx, offset error2_2
	push dx
	mov dx, 'es'
	push dx
	call _putstr_seg
	add sp, 2
	jmp _ret

_check_size_ok:		;проверка прошла успешно
	xor si, si
	xor bx, bx
	mov si, offset matr1
	mov bx, offset matr2
	
	mov word ptr[string], 0
	
_choice_operation:	;анализ введенного символа операции
	cmp word ptr[bp+var1], 43
	jz _add
	cmp word ptr[bp+var1], 45
	jz _sub
	jmp _mul
	
_choice_operation_cyc:	;анализ введенного символа операции для цикла
	cmp word ptr[bp+var1], 43
	jz _add_ret
	cmp word ptr[bp+var1], 45
	jz _sub_ret
	
_add:	;сложение матриц
	mov ax, word ptr[m1]
	mov cx, word ptr[n1]
	mul cx
	mov di, ax
	
	_add_cyc:
	mov ax, word ptr[si]
	mov cx, word ptr es:[bx]
	add ax, cx
	
	jmp _print_in_file
	
	_add_ret:
	add bx, 2
	add si, 2
	dec di
	cmp di, 0
	jz _tmp
	jmp _add_cyc
	
_tmp: jmp _ret
	
_sub:	;вычитание матриц
	mov ax, word ptr[m1]
	mov cx, word ptr[n1]
	mul cx
	mov di, ax
	
	_sub_cyc:
	mov ax, word ptr[si]
	mov cx, word ptr es:[bx]
	sub ax, cx
	
	jmp _print_in_file
	
	_sub_ret:
	add bx, 2
	add si, 2
	dec di
	cmp di, 0
	jz _ret
	jmp _sub_cyc
	
_mul:	;умножение матриц
	mov ax, word ptr[bp+var3]
	mov bx, word ptr[bp+var2]
	mov cx, word ptr[bp+var5]
	mov dx, word ptr[bp+var4]
	push dx
	push cx
	push bx
	push ax
	call _multiplication
	add sp, 8
	jmp _ret

_print_in_file:
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
	
	add word ptr [bp+var3], 1
	mov ax, word ptr [bp+var3]
	mov cl, byte ptr[m1]
	div cl
	cmp ah, 0
	jz _1310
	
	_32:
	mov ah, 40h
	mov dx, offset space
	mov cx, 1
	int 21h
	jmp _cont
	
	_1310:
	mov ah, 40h
	mov dx, offset caret
	mov cx, 1
	int 21h
	
	_cont:
	pop bx
	jmp _choice_operation_cyc
	
_ret:
	mov ah, 3eh                    
    mov bx, word ptr [bp+var1]        
    int	21h
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
	
	call _exit0
code ends

end start