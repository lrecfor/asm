_stack segment para stack
db 256 dup(?)
_stack ends

_data segment para public
char db ?
caret_ db 0Dh,0Ah,"$"
_data ends

_code segment para

assume cs:_code, ds:_data, ss:_stack

start:

mov ax,_data
mov ds,ax
mov ax,_stack
mov ss,ax

mov ah, 01h
int 21h
mov char,al

mov ah, 09h
mov dx, offset caret_
int 21h

mov dl, char ;!
mov ah, 02h
int 21h

mov ah, 4ch
int 21h

_code ends
end start