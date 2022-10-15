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
fname1 db 256 dup(?)
fname2 db 256 dup(?)
buf1 db 256 dup(?)
buf db ?
handle1 dw ?
handle2 dw ?
fcorrect db "Open OK!", 0
ferror db "Open error!", 0
data ends

code segment para public 

assume cs:code,ds:data,ss:stack

include strings.inc
include files.inc

;fcopy(file_desc in, file_desc out)
;функциz копирования файла
_fcopy proc near
    push bp
    mov bp, sp
	
fcopy_cyc:
	mov ah, 3fh
	mov bx, word ptr[bp+4]
	mov cx, 1
	mov dx, offset buf
	int 21h
	
	cmp ax, 0
	je fcopyret
	
	mov ah, 40h
	mov bx, word ptr[bp+6]
	mov dx, offset buf
	mov cx, 1
	int 21h
	
	jmp fcopy_cyc
	
fcopyret:
    mov sp, bp
    pop bp
    ret
_fcopy endp

;fadd(file_desc in, file_desc out)
;функция добавления содержимого файла in в конец файла out 
_fadd proc near
    push bp
    mov bp, sp
	
	mov ah, 42h
	mov bx, word ptr[bp+arg2]
	xor cx, cx
	xor dx, dx
	mov al, 2
	int 21h

fadd_cyc:
	mov ah, 3fh
	mov bx, word ptr[bp+4]
	mov cx, 1
	mov dx, offset buf
	int 21h
	
	cmp ax, 0
	je faddret
	
	mov ah, 40h
	mov bx, word ptr[bp+6]
	mov dx, offset buf
	mov cx, 1
	int 21h
	
	jmp fadd_cyc
	
faddret:
    mov sp, bp
    pop bp
    ret
_fadd endp

;void prog()
;функция для демонстрации работы программы
_prog proc near
    push bp
    mov bp, sp
    sub sp, 5

    mov dx, 256
    push dx
    mov dx, offset fname1
    push dx
    call _getstr
    add sp, 4
	
	mov dx, 0
    push dx
    mov dx, offset fname1
    push dx
    call _fopen
    add sp, 4
	
    mov word ptr [bp + var2], ax
	mov dx, offset fcorrect
    push dx
    call _putstr
    add sp, 2
    call _putnewline
	
    cmp ax, -1
    je progerr
    
	mov dx, 256
    push dx
    mov dx, offset fname2
    push dx
    call _getstr
    add sp, 4
	
    mov dx, 0
    push dx
    mov dx, offset fname2
    push dx
    call _fopenC
    add sp, 4
	
    mov word ptr [bp + var1], ax
	mov dx, offset fcorrect
    push dx
    call _putstr
    add sp, 2
    call _putnewline
	
    cmp ax, -1
    je progerr
	
	mov dx, word ptr [bp + var1]
    push dx
    mov dx, word ptr [bp + var2]
    push dx
	call _fcopy
	;call _fadd
    add sp, 4
	
	push word ptr [bp + var2]
	call _fclose
	
	cmp ax, -1
    je progret
	
	push word ptr [bp + var1]
	call _fclose
	
	cmp ax, -1
    je progret
    
    jmp progret

progerr:
    mov dx, offset ferror
    push dx
    call _putstr
    add sp, 2
    call _putnewline
    jmp progret

progret:
    mov sp, bp
    pop bp
    ret
_prog endp
 
start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    
    call _prog
    
    call _exit0
code ends

end start