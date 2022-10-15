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

stack segment para stack
db 65530 dup(?)
stack ends

data1 segment para public
n1 dw ? ; число строк в матрице
m1 dw ? ; число столбцов в матрице
matr1 dw 30000 dup(?) ; матрица
data1 ends

data2 segment para public
n2 dw ? ; число строк в матрице
m2 dw ? ; число столбцов в матрице
matr2 dw 30000 dup(?) ; матрица
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
_readm1: 
    push bp
    mov bp, sp
    
    mov sp, bp
    pop bp
    ret
    
; void readm2(const str *filename)   
; читает матрицу в сегмент es, преобразуя считанные строки в числа
; выводит сообщение об ошибке, если файл с данным именем не существует
_readm2: 
    push bp
    mov bp, sp
    
    mov sp, bp
    pop bp
    ret

; void calc()    
; основная функция калькулятора (вызывает нужные функции) 
_calc: 
    push bp
    mov bp, sp
    
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