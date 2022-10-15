arg1 equ 4
arg2 equ 6
arg3 equ 8
arg4 equ 10

var1 equ -2
var2 equ -4
var3 equ -6
var4 equ -8

stack segment para stack
db 65530 dup(?)
stack ends

data segment para public
str1 db 256 dup(?)
num1 dd ?
num2 dd ?
res dd ?
dw ?
sign db ?
error_sign db "error: sign is wrong", 0
error_num1b db "error: num1 is too big", 0
error_num1s db "error: num1 is too small", 0
error_num2b db "error: num2 is too big", 0
error_num2s db "error: num2 is too small", 0
error_str0 db "error: string is strange", 0
error_str1 db "error: there're letters in number", 0
error_str3_1 db "error: num1 is empty", 0
error_str3_2 db "error: num2 is empty", 0
error_str4 db "error: one of numbers starts with 0", 0
error_div_null db "error: divine by null", 0
data ends

code segment para public 

assume cs:code,ds:data,ss:stack

include strings.inc
    
; int atoi(const char *str)
; функция перевода строки в число
_atoi: 
    push bp
    mov bp, sp
	
	mov bx, word ptr[bp+arg1]
	xor ax, ax
	xor si, si
	xor di, di
	 
	cmp byte ptr[bx], 45
	jz _atoi_neg
	
	cmp byte ptr[bx], '0'
	jz _atoi_null1
	jmp _atoi_cyc
	
_atoi_neg:
	cmp byte ptr[bx+1], '0'
	jz _atoi_error4
	mov si, 1 
	inc bx
	
_atoi_cyc:
	mov dx, 10
	mov cl, byte ptr[bx]
	
	inc di
	cmp di, 6
	ja _atoi_error2
	
	cmp cl, 32
	jz _atoi_exit
	
	cmp cl, 0
	jz _atoi_exit
	
	cmp cl, '0'
	jb _atoi_error1
	
	cmp cl, '9'
	ja _atoi_error1
	
	sub cl, '0'
	mul dx
	add ax, cx
	inc bx
	
	jmp _atoi_cyc
	
_atoi_exit:
	xor di, di
	cmp si, 1 ;num is neg?
	jz _neg ;yes
	jmp _atoi_ret
	
_neg: 
	neg ax
	jmp _atoi_ret
	
_atoi_error1: ;letters in number
	mov di, 1
	jmp _atoi_ret
	
_atoi_error2: ;number too long
	mov di, 2
	jmp _atoi_ret
_atoi_null1:
	cmp byte ptr[bx+1], 32
	jne _atoi_null2
	
	mov ax, 0
	jmp _atoi_ret
	
_atoi_null2:
	cmp byte ptr[bx+1], 0
	jne _atoi_error4
	
	mov ax, 0
	jmp _atoi_ret
	
_atoi_error4: ;starts with null
	mov di, 4

_atoi_ret:
    mov sp, bp
    pop bp
    ret

; int check(const char *input_line)    
; функция проверки введённой строки на соответствие формату
; функция возвращает 1, если строка удовлетворяет формату, иначе возвращает 0
; при выполнении дополнительного задания, функция также выводит сообщение об ошибке    
; 1)строка не соответствует формату полностью (присутствуют буквы, нет второго операнда, проч.); OK
; 2)знак операции не является допустимым (?^& и т.п.); OK
; 3)число1 или число2 не входят в требуемый диапазон. OK
_check: 
    push bp
    mov bp, sp
	
	mov bx, word ptr[bp+arg1]
	
	cmp byte ptr[bx], 32
	jz _check_error_str3_1
	
	mov cx, bx
	push cx
	call _strlen
	add sp, 2
	
	cmp ax, 0
	jz _check_error_str0
	cmp ax, 5
	jb _check_error_str0
	jmp _check_st
	
	_check_error_str3_1:
	mov dx, offset error_str3_1
	jmp _check_error
	
	_check_error_str0:
	mov dx, offset error_str0
	jmp _check_error
	
_check_st:
	push word ptr[bp+arg1]
	call _atoi
	add sp, 2

	cmp di, 1
	jz _check_error_str1
	
	cmp di, 2
	jz _tmp 
	
	cmp di, 4
	jz _check_error_str4
	
	jmp _check_num1
	
	_tmp: jmp _check_error_num1b
	
_check_num1_ok:	
	mov word ptr[num1], ax
	;call _print_ax ;out num1
	
	call _intsize
	mov bx, ax
	inc bx
	mov al, byte ptr[bx]
	mov byte ptr[sign], al
	
check_sign_start:
	mov al, byte ptr[sign]
	
	cmp al, 43
	jz _check_sign_end
	cmp al, 45
	jz _check_sign_end
	cmp al, 42
	jz _check_sign_end
	cmp al, 47
	jz _check_sign_end
	cmp al, 37
	jz _check_sign_end
	
	jmp _check_error_sign
	
_check_sign_end:
	inc bx
	mov al, byte ptr[bx]
	cmp al, 32
	jne _check_error_sign
	cmp al, 0
	jz _check_error_str3_2
	
_check_sign_2:
	inc bx
	mov al, byte ptr[bx]
	cmp al, 32
	jz _check_error_str3_2
	cmp al, 0
	jz _check_error_str3_2
	
	jmp _check_continue
	
_check_error_str3_2:
	mov dx, offset error_str3_2
	jmp _check_error
	
_check_continue:
	push bx
	call _atoi
	add sp, 2
	
	mov word ptr[num2], ax
	;call _print_ax ;out num2
	
	cmp di, 1
	jz _check_error_str1
	
	cmp di, 2
	jz _check_error_num2b
	
	cmp di, 4
	jz _check_error_str4
	
	jmp _check_num2
	
_tmp_2: jmp _check_num1_ok
	
_check_error_str1:
	mov dx, offset error_str1
	jmp _check_error
_check_error_str4:
	mov dx, offset error_str4
	jmp _check_error
_check_error_sign:
	mov dx, offset error_sign
	jmp _check_error
	
_check_num1: ;in ax number
	cmp ax, 0
	je _tmp_2 ;_check_num1_ok
	
	cmp si, 0
	je _pos_n1
	
	cmp ax, 0
	jng _tmp_2 ;_check_num1_ok
	jmp _check_error_num1s
	
	_pos_n1:
	cmp ax, 0
	jg _tmp_2 ;_check_num1_ok
	jmp _check_error_num1b
	
_check_error_num1b: 
	mov dx, offset error_num1b
	jmp _check_error
_check_error_num1s: 
	mov dx, offset error_num1s
	jmp _check_error
_check_error_num2b: 
	mov dx, offset error_num2b
	jmp _check_error
_check_error_num2s: 
	mov dx, offset error_num2s	
	jmp _check_error
	
_check_num2: ;in ax number
	cmp ax, 0
	je _check_str_end
	
	cmp si, 0
	je _pos_n2
	
	cmp ax, 0
	jng _check_str_end
	jmp _check_error_num2s
	
	_pos_n2:
	cmp ax, 0
	jg _check_str_end
	jmp _check_error_num2b

_check_error:
	push dx
	call _putstr
	add sp, 2
	
	mov ax, 0
	jmp _check_ret
	
_check_str_end:
	cmp byte ptr[sign], 47
	jz _check_div
	jmp _check_str_ok
	
	_check_div: 
	mov ax, word ptr[num2]
	cmp ax, 0
	jz _check_str_err
	
	jmp _check_str_ok

_check_str_err:
	mov dx, offset error_div_null
	jmp _check_error
	
_check_str_ok:
	mov ax, 1

_check_ret: 
    mov sp, bp
    pop bp
    ret

; void calc()    
; функция калькулятора (вызывает нужные функции: чтения строки, проверки строки, 
; перевода строк в числа, выполнения математической операции и вывода результата) 
_calc: 
    push bp
    mov bp, sp
	sub sp, 2
	
	mov dx, 256
    push dx
    mov dx, offset str1
    push dx
    call _getstr
    add sp, 4
	
	mov dx, offset str1
	push dx
	call _check
	add sp, 2
	
	cmp ax, 0
	jz _calc_ret
	
_calc_start:
	;mov ax, word ptr[i]
	;mov bx, word ptr[i+2]
	
	cmp byte ptr[sign], 43
	jz _calc_add
	
	cmp byte ptr[sign], 45
	jz _calc_sub
	
	cmp byte ptr[sign], 42
	jz _calc_mul
	
	cmp byte ptr[sign], 47
	jz _calc_div
	
	jmp _calc_div_with_rest
	
_calc_add:
	mov ax, -2
	mov bx, -2
	add ax, bx
	call _print_ax
	
	jmp _calc_print_res
	
_calc_sub:
	sub ax, bx
	sbb dx, cx
	
	jmp _calc_print_res
	
_calc_mul:
	imul dx
	jmp _calc_print_res
	
_calc_div:
	mov cx, dx
	cwd
	idiv cx
	
	;mov bx, word ptr[num2]
	;mov dx, 0
	;mov ax, word ptr[num1+2]
	;div bx
	;mov word ptr[result+2], ax
	;mov ax, word ptr[num1]
	;div bx
	;mov word ptr[result], ax	
	;mov word ptr[remainder], dx
	
	;call _print_ax
	
	jmp _calc_print_res
	
_calc_div_with_rest:
    mov cx, dx
	cwd
	idiv cx
	mov ax, dx
	
_calc_print_res:
	;call _print_ax
	
_calc_ret:
    mov sp, bp
    pop bp
    ret

start: ; вызов функции calc (модифицировать главную функцию программы не требуется)
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    
    call _calc

	call _exit0
code ends

end start