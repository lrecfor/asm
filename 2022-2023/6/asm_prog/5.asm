;
; Модуль main.asm.
;
; Шаблон задания для поиска элементов массива, удовлетворяющих условию.
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

NullArray proc buf:dword, bufSize:dword

    local i:dword

    mov [i], 0

    jmp while_cmp_generate

    while_body_generate:
        invoke crt_rand, 10
        mov ecx, [i]
		mov ebx, [buf]
        mov dword ptr[ecx + ebx], 0

		add [i], 4
		dec bufSize
    
	while_cmp_generate:
		mov ecx, [i]
		mov ebx, [buf]
		cmp [bufSize], 0
		jne while_body_generate
    
    ret

NullArray endp

Cmp3 proc c elem:dword
    .if [elem] < 15000
        mov eax, 1
    .else
        mov eax, 0
    .endif

    ret
Cmp3 endp

;Функцию сохраняет в первом буфере элементы второго,
;удовлетворяющие условию
;Возвращает количество элементов в первом буфере,
;т.е. удовлетворяющих условию.
FilterBuf proc dstBuf:dword, srcBuf:dword, srcBufSize:dword, cmpFun:dword
    local i:dword
    local j:dword

    mov [i], 0
    mov [j], 0

    jmp while_cmp_FilterBuf

    while_body_FilterBuf:
		mov ecx, [i]
		mov ebx, [srcBuf]
		
		push dword ptr[ecx+ebx]
        call Cmp3
        add esp, 4

        .if eax == 1
            mov eax, dword ptr[ecx+ebx]
            mov ecx, [j]
            mov ebx, [dstBuf]
            mov dword ptr[ecx+ebx], eax
            add [j], 4
        .endif

		add [i], 4
		dec srcBufSize
    
	while_cmp_FilterBuf:
		mov ecx, [i]
		mov ebx, [srcBuf]
		cmp [srcBufSize], 0
		jne while_body_FilterBuf

    mov eax, [j]
    mov edx, 0
    mov edi, 4
	div edi

    ret
FilterBuf endp


BUF_SIZE = 10

main proc c argc:DWORD, argv:DWORD, envp:DWORD

    local srcBuf:DWORD
    local dstBuf:DWORD
    
    invoke crt_malloc, 4*BUF_SIZE
    mov [srcBuf], eax
    
    invoke crt_malloc, 4*BUF_SIZE
    mov [dstBuf], eax
    
    invoke GenerateRandomBuf, [srcBuf], BUF_SIZE
    ;invoke NullArray, [dstBuf], BUF_SIZE
    invoke PrintBuf, [srcBuf], BUF_SIZE
    invoke printf, offset format, offset string
    invoke FilterBuf, [dstBuf], [srcBuf], BUF_SIZE, Cmp3
    invoke PrintBuf, [dstBuf], eax
	
	mov eax, 0
	ret

main endp


end
