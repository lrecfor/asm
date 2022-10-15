_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
str1_max db 240         
str1_len db ?      
str1 db 256 dup(?)
str2_max db 240
str2_len db ?  
str2 db 256 dup(?)
str3_max db 240
str3_len db ? 
str3 db 256 dup(?)
new_line db 0ah,0dh,'$'
_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack

start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
    
    mov ah, 0ah
    mov dx, offset str1_max
    int 21h
    
    mov ah, 09h
    mov dx, offset new_line
    int 21h
    
    mov bx, 0
    mov bl, byte ptr[str1_len]
    mov si, offset str1
    mov byte ptr[si+bx], '$'
	
	mov ah, 0ah
    mov dx, offset str2_max
    int 21h
    
    mov ah, 09h
    mov dx, offset new_line
    int 21h
    
    mov bx, 0
    mov bl, byte ptr[str2_len]
    mov si, offset str2
    mov byte ptr[si+bx], '$'
	
	mov ah, 0ah
    mov dx, offset str3_max
    int 21h
    
    mov ah, 09h
    mov dx, offset new_line
    int 21h
    
    mov bx, 0
    mov bl, byte ptr[str3_len]
    mov si, offset str3
    mov byte ptr[si+bx], '$'
	
	mov ah, 09h
    mov dx, offset str1
    int 21h
	mov	 ah, 02h
	mov	 dl,' '
	int	 21h
	mov ah, 09h
    mov dx, offset str2
    int 21h
	mov	 ah, 02h
	mov	 dl,' '
	int	 21h
	mov ah, 09h
    mov dx, offset str3
    int 21h
	
	mov ah, 09h
    mov dx, offset new_line
    int 21h
	
	mov ah, 09h
    mov dx, offset str1
    int 21h
	mov	 ah, 02h
	mov	 dl, 059
	int	 21h
	mov ah, 09h
    mov dx, offset str2
    int 21h
	mov	 ah, 02h
	mov	 dl, 059
	int	 21h
	mov ah, 09h
    mov dx, offset str3
    int 21h
    
	mov ah, 09h
    mov dx, offset new_line
    int 21h
	
	mov ah, 09h
    mov dx, offset str1
    int 21h
	mov	 ah, 02h
	mov	 dl, 0ah
	int	 21h
	mov ah, 09h
    mov dx, offset str2
    int 21h
	mov	 ah, 02h
	mov	 dl, 0ah
	int	 21h
	mov ah, 09h
    mov dx, offset str3
    int 21h
	
    mov al, 0
    mov ah, 4ch
	int 21h
_code ends

end start