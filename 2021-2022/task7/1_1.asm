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
	
	mov si, word ptr[bp+4]
	mov di, word ptr[bp+6]
	
fcopy_cyc:
	push bx
	push cx
	push dx
	mov ah, 3fh
	mov bx, si
	mov cx, 1
	mov dx, offset buf
	int 21h
	
	cmp ax, 0
	je fcopyret
	
	mov ah, 40h
	mov bx, di
	mov dx, offset buf
	mov cx, 1
	int 21h
	
	pop dx
	pop cx
	pop bx
	jmp fcopy_cyc
	
fcopyret:
    mov sp, bp
    pop bp
    ret
_fcopy endp

;fadd(file_desc in, file_desc out)
;функция добавления содержимого файла in в конец файла out 
    
;void prog()
;функция для демонстрации работы программы
_prog proc near
    push bp
    mov bp, sp
    sub sp, 4
    ;fname1
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
	
    cmp ax, -1
    je progerr
    
	;fname2
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
    call _fopen
    add sp, 4
    mov word ptr [bp + var1], ax
	
    cmp ax, -1
    je progerr
    
    mov dx, word ptr [bp + var1]
    push dx
    mov dx, word ptr [bp + var2]
    push dx
	call _fcopy
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