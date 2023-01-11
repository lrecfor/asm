;
; Модуль main.asm.
;
; Шаблон задания для сложения элементов массивов.
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

.code
printf proto c :dword, :vararg

; Функция сложения элементов массива.
AddBuf proc resBuf:dword, op1Buf:dword, op2Buf:dword, bufSize:dword
    local tmp:dword
    local i:dword

    mov [i], 0

    jmp while_cmp_PrintBuf

    while_body_PrintBuf:
		mov ecx, [i]
		mov ebx, [op1Buf]
		
		mov eax, dword ptr[ecx+ebx]
        mov [tmp], eax

        mov ebx, [op2Buf]
		mov eax, dword ptr[ecx+ebx]
        add [tmp], eax
    
        mov ebx, [resBuf]
		mov eax, dword ptr[ecx+ebx]
        mov edi, [tmp]
        mov dword ptr[ecx+ebx], edi

		add [i], 4
		dec bufSize
    
	while_cmp_PrintBuf:
		mov ecx, [i]
		mov ebx, [op1Buf]
		cmp [bufSize], 0
		jne while_body_PrintBuf

    ret

AddBuf endp


BUF_SIZE = 100

main proc c argc:DWORD, argv:DWORD, envp:DWORD

    local resBuf:DWORD
    local op1Buf:DWORD
    local op2Buf:DWORD
    
    invoke crt_malloc, 4*BUF_SIZE
    mov [resBuf], eax
    
    invoke crt_malloc, 4*BUF_SIZE
    mov [op1Buf], eax
    
    invoke crt_malloc, 4*BUF_SIZE
    mov [op2Buf], eax

    
    invoke GenerateRandomBuf, [op1Buf], BUF_SIZE
    invoke GenerateRandomBuf, [op2Buf], BUF_SIZE
    invoke PrintBuf, [op1Buf], BUF_SIZE
    invoke printf, offset format, offset string
    invoke PrintBuf, [op2Buf], BUF_SIZE
    invoke printf, offset format, offset string
    invoke AddBuf, [resBuf], [op1Buf], [op2Buf], BUF_SIZE
    invoke PrintBuf, [resBuf], BUF_SIZE
	
	mov eax, 0
	ret

main endp


end
