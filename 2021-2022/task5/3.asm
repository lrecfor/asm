
;mov ah, 09h
	;mov dx, offset wrt_from
	;int 21h

	;mov dx, offset from
    ;mov cx, 100
    ;call sstrf
	;mov word ptr [from_len], ax
	;mov bx, word ptr [from_len]
    ;mov dx, offset from
	;mov byte ptr[bx], '$'
	
	;mov ah, 09h
	;mov dx, offset wrt_to
	;int 21h
	
	mov dx, offset to_
    mov cx, 100
    call sstrf
	mov word ptr [to_len], ax
	mov bx, word ptr [to_len]
    mov dx, offset to_
	mov byte ptr[bx], 0h
	
	;mov ah, 09h
	;mov dx, offset to_
	;int 21h

	;mov cx, word ptr [to_len]
    ;mov dx, offset to
    ;call pstrf













_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
from db 100 dup(?)
to db 100 dup(?)
from_len dw ?
to_len dw ?
wrt_from db "from: ", "$"
wrt_to db "to: ", "$"
newline db 0Ah, 0Dh, "$"

str db 101 dup(?)
handle_from dw 0
handle_to dw 0

_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack
	
newlinefunc:
	mov ah, 09h
	mov dx, offset newline
	int 21h
	
	ret
	
pstrf:
    mov ah, 40h
    mov bx, 1
    int 21h
    ret
	
sstrf: 
    mov ah, 3fh
    mov bx, 0
    int 21h
	dec ax
    dec ax
    
    ret
	
start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
	
	mov ah, 09h
	mov dx, offset wrt_from
	int 21h

	mov dx, offset from
    mov cx, 100
    call sstrf
	mov word ptr [from_len], ax
	mov bx, word ptr [from_len]
    mov dx, offset from
	mov byte ptr[bx], 0h
	
	mov ah, 09h
	mov dx, offset wrt_to
	int 21h
	
	mov dx, offset to
    mov cx, 100
    call sstrf
	mov word ptr [to_len], ax
	mov bx, word ptr [to_len]
    mov dx, offset to
	mov byte ptr[bx], 0h

	;mov cx, word ptr [to_len]
    ;mov dx, offset to
    ;call pstrf
	
	call newlinefunc
	
    mov ah, 3dh
	mov al, 0
	mov dx, offset from
	int 21h
	
	mov [handle_from], ax
	
	mov ah, 3dh
	mov al, 1
	mov dx, offset to
	int 21h
	
	mov [handle_to], ax
	mov ah, 40h
	mov bx, [handle_to]
	mov cx, 1
	mov dx, offset [handle_to]
	int 21h
	
	;copyfile:
	
		mov ah, 42h
		mov al, 0
		mov cx, 0
		mov bx, [handle_from]
		mov dx, 100
		int 21h
		
		mov ah, 3fh
		mov bx, [handle_from]
		mov cx, 100
		mov dx, offset str
		int 21h
		
		;jmp copyfile

	mov ah, 40h
	mov bx, [handle_to]
	mov cx, 100
	mov dx, offset str
	int 21h
		
	mov ah, 3eh                    
    mov bx, [handle_from]                 
    int	21h
	
	mov ah, 3eh                    
    mov bx, [handle_to]                
    int	21h
		
    mov al, 0
    mov ah, 4ch
	int 21h
_code ends

end start







_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
from db 100 dup(?)
to db 100 dup(?)
from_len dw ?
to_len dw ?
wrt_from db "from: ",'$'
wrt_to db "to: ", '$'
newline db 0Ah, 0Dh, '$'

str db "hello", '$'
handle_from dw 0
handle_to dw 0

_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack
	
newlinefunc:
	mov ah, 09h
	mov dx, offset newline
	int 21h
	
	ret
	
pstrf:
    mov ah, 40h
    mov bx, 1
    int 21h
    ret
	
sstrf: 
    mov ah, 03fh
    mov bx, 0
    int 21h
	dec ax
    dec ax
    
    ret
	
strsize: 
	xor ax, ax
	
	begin:
	mov cl, byte ptr[bx]
	
	cmp cl, 0 
	jz exit
	
	inc bx
	
	jmp begin
	
	exit:
    ret
	
start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
	
	mov dx, offset from
    mov cx, 100
    call sstrf
	mov word ptr [from_len], ax
	mov bx, ax
	mov byte ptr[bx], 0
	
	mov ah, 3Dh
	mov al, 0
	mov dx, offset from
	int 21h
	
	mov [handle_from], ax
	
	mov al, 0
    mov si, offset to
    mov bx, 0
	
char_in:    
    cmp al, 0Dh
    je output_
    
    mov ah, 01h
    int 21h
    
    mov byte ptr [si + bx], al
	inc bx
	
    jmp char_in
	
	output_:
	call newlinefunc
	
	mov si, offset to_len
    mov word ptr [si], bx
	mov ah, 40h
    mov si, offset to_len
    mov cx, word ptr [si]
    mov bx, 1
    mov dx, offset to
    int 21h
	call newlinefunc
	
	mov ah, 3Dh
	mov al, 1
	mov dx, offset to
	int 21h
	
	mov [handle_to], ax
		
	mov ah, 40h
	mov bx, [handle_to]
	mov si, offset to_len
    mov cx, word ptr [si]
    mov dx, offset str
	int 21h
	
	mov ah, 3eh                    
    mov bx, [handle_from]                 
    int	21h
	
	mov ah, 3eh                    
    mov bx, [handle_to]                
    int	21h
		
    mov al, 0
    mov ah, 4ch
	int 21h
_code ends

end start



xor di, di
	xor si, si
	mov bx, offset hex
	xor ch, ch
	mov cl, 50
	
	convertloop:
	mov ah, password[si]
	mov al, ah
	mov cl, 4
	shr al, cl
	xlat
	mov hex_gamma[di], al
	inc di
	mov al, ah
	and al, 0Fh
	xlat
	mov hex_gamma[di], al
	inc di
	inc di
	inc si
	loop convertloop
	mov hex_gamma[di], '$'
	
	mov dx, offset hex_gamma+2
	mov ah, 09h
	int 21h
	
	
	
	
	
	\\\\\
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
password db 50 
     db ? 
	 db 50 dup(0)
hex_gamma db 50 
     db ? 
	 db 50 dup(0)
buf db ?	 
wrt1 db "from: $"
wrt2 db 13,10,"to: $"
wrt3 db 13,10,"password: $"
handle1 dw ?
handle2 dw ?
newline db 0Dh,0Ah,"$"
hex db "0123456789ABCDEF$"
_data ends

_code segment para public 

assume cs:_code, ds:_data, ss:_stack
	
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

	mov ah, 09h
	lea dx, wrt3
	int 21h
	
	mov al, 0
    mov si, offset password
    mov bx, 0
	
	char_in:    
    mov ah, 01h
    int 21h
	
	jmp m1
    
    mov byte ptr [si + bx], al
    inc bx
    jmp char_in
	
	m1:
	push bx
	push dx
	
	cmp al, 0Dh
    je outP
	
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
	mov ah, 02
	int 21h
	mov dl, cl
	cmp dl, 9
	jle l2
	add dl, 7
	
	l2:
	add dl, 30h
	mov ah, 02
	int 21h
	
	jmp char_in
	
	pop bx
	pop dx
	
	outP:	
	mov al, 0
	mov byte ptr[bx], al
	
	mov ah, 09h
	mov dx, offset newline
	int 21h
	
	mov ah, 09h
	mov dx, offset password
	int 21h
	
    mov al, 0
    mov ah, 4ch
	int 21h
_code ends

end start