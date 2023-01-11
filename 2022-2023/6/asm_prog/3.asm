;
; Модуль main.asm.
;
; Шаблон задания для инвертирования списка чисел.
;
; Маткин Илья Александрович 03.10.2014
;

.686
.model flat, stdcall
option casemap:none

include C:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac
include functions.inc

.data


.data?

.const

buffer dd 1234141,12341234,234532,349689,9897132,198
;string db "------------------------------------------------",0

.code

printf proto c :dword, :vararg


;void swap (void *p1, void *p2, size_t size)
;осуществляет перестановку элементов массива
Swap proc first:dword, second:dword
    mov ebx, [first]
    mov eax, [second]

    mov edx, dword ptr[ebx]
    xchg dword ptr[eax], edx
	mov dword ptr[ebx], edx

    ret
Swap endp

; Инвертирование массива чисел
InvertBuf proc buf:dword, bufSize:dword
    local i:dword
    local j:dword

    mov [i], 0
    mov eax, [bufSize]
    mov edi, 4
    mul edi
    mov [j], eax
    sub [j], 4

    mov eax, [bufSize]
    mov edx, 0
    mov edi, 2
    div edi
    mov [bufSize], eax

    jmp while_cmp_InvertBuf

    while_body_InvertBuf:
		mov ecx, [i]
        mov eax, [j]
		mov ebx, [buf]

        InvertBuf_replace:
        invoke Swap, addr dword ptr[ecx+ebx], addr dword ptr[eax+ebx]

		;mov edx, dword ptr[eax+ebx]
		;xchg dword ptr[ebx+ecx], edx
		;mov dword ptr[eax+ebx], edx

		add [i], 4
        sub [j], 4
		dec bufSize
    
	while_cmp_InvertBuf:
		mov ecx, [i]
        mov eax, [j]
		;mov ebx, [buf]
		cmp [bufSize], 0
		jne while_body_InvertBuf

    ret

InvertBuf endp

main proc c argc:DWORD, argv:DWORD, envp:DWORD
    local buf:DWORD
    local size__:dword
    
    ;mov ebx, [argv]
    ;mov ecx, dword ptr[ebx+4]
    ;invoke printf, offset format, eax
    ;mov ecx, 4
    ;mul ecx

    mov [size__], 10
    
    invoke crt_malloc, 4*10
    mov buf, eax            
    mov byte ptr [buf][0], 0  
    
    invoke GenerateRandomBuf, [buf], [size__]
    invoke PrintBuf, [buf], [size__]
    invoke printf, offset format, offset string
    invoke InvertBuf, [buf], [size__]
    invoke PrintBuf, [buf], [size__]
	
	mov eax, 0
	ret

main endp


end
