_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
str db 256 dup(?)  
strlen dw ? 
newline db 0Dh, 0Ah        
_data ends

_code segment para public 

assume cs:_code,ds:_data,ss:_stack

start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
    
    mov al, 0
    mov si, offset str
    mov bx, 0

char_in:    
    cmp al, 0Dh
    je output
    
    mov ah, 01h
    int 21h
    
    mov byte ptr [si + bx], al
    inc bx
    jmp char_in
    
output:
    mov si, offset strlen
    mov word ptr [si], bx
    
    mov ah, 40h
    mov cx, 2
    mov bx, 1
    mov dx, offset newline
    int 21h
    
    mov ah, 40h
    mov si, offset strlen
    mov cx, word ptr [si]
    mov bx, 1
    mov dx, offset str
    int 21h
    
    mov ah, 4ch
    mov al, 00h
	int 21h
_code ends

end start