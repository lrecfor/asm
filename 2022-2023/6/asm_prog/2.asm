;
; Модуль main.asm.
;
; Пример обращения к аргументам функции main.
;
; Маткин Илья Александрович 18.09.2013
;

.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac
include functions.inc

.data


.data?

.const
str1 db "SPACE",0

.code

printf proto c :dword, :vararg
malloc proto c :dword
rand proto c 

;char * join (char **str_array, char *str)
;Объединяет строки из массива str_array в одну,
;вставляя между ними строку str. 
;Возвращает получившуюся строку.
join proc c array:DWORD, size_:dword, string_:dword
	local result:dword
	local res_ptr:dword
    local str_length:dword
	local count:dword
	local i:dword
	
	;;find length of result string
	mov [str_length], 0
	mov [i], 0
	mov eax, [size_]
	mov [count], eax

    jmp while_cmp

	while_body:
		mov ecx, [i]
		mov ebx, [array]
		push dword ptr[ecx + ebx]
		call _strlen
		add esp, 4

		add [str_length], eax

		;invoke printf, offset format, dword ptr[ecx + ebx]

		add [i], 4
		dec count
    
	while_cmp:
		mov ecx, [i]
		mov ebx, [array]
		cmp [count], 0
		jne while_body
	
	push [string_]
	call _strlen
	add esp, 4
	mov ebx, [size_]
	dec ebx
	imul eax, ebx
	add [str_length], eax
	inc [str_length]

    ;invoke printf, offset format_eax, [str_length]

	;;malloc 
	push [str_length]
	call malloc
	add esp, 4
	test eax, eax
	jz join_ret
	mov [result], eax
	mov [res_ptr], eax

	;;copying 
	mov [i], 0
	mov eax, [size_]
	mov [count], eax

	mov ecx, [i]
	mov ebx, [array]

    jmp while_cmp_

	while_body_:
		mov ecx, [i]
		mov ebx, [array]

		.if [i] == 0
			push dword ptr[ecx + ebx]
			push [res_ptr]
			call _strcpy
			add esp, 8
		.else
			push dword ptr[ecx + ebx]
			push [res_ptr]
			call _strcat
			add esp, 8
		.endif

		.if [count] != 1
			push offset str1
			push [res_ptr]
			call _strcat
			add esp, 8
		.endif
		
		add [i], 4
		dec count
    
	while_cmp_:
		mov ecx, [i]
		mov ebx, [array]
		cmp [count], 0
		jne while_body_

	mov dword ptr[ecx + ebx], 0

join_ret:
	mov eax, [result]
	ret
join endp

main proc c argc:DWORD, argv:DWORD, envp:DWORD
    local buf:dword

	local er:dword
	local i:dword

    push 100
	call malloc
	add esp, 4
	test eax, eax
	jz main_ret
	mov [buf], eax

	push 5
	push [buf]
	call GenStrings
	add esp, 8

	;;join
	push offset str1
	push 5
	push [buf]
	call join
	add esp, 12

	invoke printf, offset format, eax
	
main_ret:
	mov eax, 0
	ret

main endp


end
