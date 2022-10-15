_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
from db 100 
     db ? 
	 db 100 dup(0)
to db 100 
   db ? 
   db 100 dup(0)
hex_gamma db 100 dup('$')
len dw ? 

buf db ?	
crypt db "4D4B2D3230312041524520415745534F4D4521", "$"
key db "41534d41534d41534d41534d41534d41534d41", "$"
res db 100 dup(?)
wrt1 db "from: $"
wrt2 db 13,10,"to: $"
wrt3 db 13,10,"password: $"
handle1 dw ?
handle2 dw ?
newline db 0Dh,0Ah,"$"
_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack
	
char_in: 
    mov ah, 01h
    int 21h
	
	m1:	
	cmp al, 0Dh
    je exit
	
	xor ah,ah
	mov bl, 10h
	div bl
	mov dl, al
	cmp dl, 9
	jle l1
	add dl, 7
	
	l1:
	add dl, 30h
	mov cl, ah 
	mov byte ptr [si], dl
	inc si
	mov dl, cl
	cmp dl, 9
	jle l2
	add dl, 7
	
	l2:
	add dl, 30h
	mov byte ptr [si], dl
    inc si
	jmp char_in
	
	exit:
	ret
	
xor_:
	push bx
	push dx
	push cx
	push ax
	
	nach:
	;mov al, buf[0]
	;xor al, hex_gamma[di]
	;add al, 30h
	;mov buf[0], al
	mov ah, 40h
	mov bx, 1
	mov dx, offset buf
	mov cx, 1
	int 21h
	
	
	
	pop bx
	pop dx
	pop cx
	pop ax
	ret
	
start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
	
	mov ah, 09h
	lea dx, wrt1
	int 21h
	
	mov ah, 0ah
	mov dx, offset from
	int 21h
	
	mov si, offset from+1
	mov cl, [si]
	mov ch, 0
	inc cx
	add si, cx
	mov al, 0
	mov [si], al
	
	mov ah, 3Dh
	mov al, 0
	mov dx, offset from+2
	int 21h
	mov handle1, ax
	
	mov ah, 09h
	lea dx, wrt2
	int 21h
	
	mov ah, 0ah
	mov dx, offset to
	int 21h
	
	mov si, offset to+1
	mov cl, [si]
	mov ch, 0
	inc cx
	add si, cx
	mov al, 0
	mov [si], al
	
	mov ah, 3ch
	mov cx, 0
	mov dx, offset to+2
	int 21h
	mov handle2, ax
	
	mov ah, 09h
	lea dx, wrt3
	int 21h
	
	mov al, 0
	mov si, offset hex_gamma
	mov cx, 0
	
	call char_in

    mov ah, 40h
    mov cx, 2
    mov bx, 1
    mov dx, offset newline
    int 21h
	
	mov bx, offset hex_gamma
	mov cx, 0
	search:
	push cx
	mov cl, byte ptr[bx]
	
	cmp cl, '$'
	jz found
	inc bx
	pop cx
	inc cx
	push cx
	jmp search
	found:
	pop cx
	mov word ptr[len], cx

	mov di, 0
	push di
	
	read:
	mov ah, 3fh
	mov bx, handle1
	mov cx, 1
	mov dx, offset buf
	int 21h
	
	copy:
	cmp ax, 0
	je en
	
	mov al, buf[0]
	
	xor ah,ah
	mov bl, 10h
	div bl
	mov dl, al
	cmp dl, 9
	jle l11
	add dl, 7
	
	l11:
	add dl, 30h
	mov buf[0], dl
	mov cl, ah 
	mov dl, cl
	cmp dl, 9
	
	pop di
	call xor_
	push di
	
	jle l22
	add dl, 7
	
	l22:
	add dl, 30h
	mov buf[0], dl
	
	pop di
	call xor_
	push di
	
	jmp read
	
	en:
	mov ah, 3eh                    
    mov bx, handle1               
    int	21h
	
	mov ah, 3eh                    
    mov bx, handle2                
    int	21h
	
    mov al, 0
    mov ah, 4ch
	int 21h
_code ends

end start