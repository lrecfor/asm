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
string_ db "sdfad11asdfka1222221safa1", 0
substr_ db "1", 0
null db "NULL", 0
.code

;printf proto c :dword, :dword, :vararg
malloc proto c :dword
rand proto c 
strstr proto c :dword, :dword

;Функция разбивает строку на подстроки по подстроке.
;Возвращает указатель на массив указателей на получившиеся подстроки.
;Память под массив должна выделяться в куче (malloc).

;split ("sdfad11asdfka1222221safa1", "1") ->
;0 -> "sdfad"
;1 -> ""
;2 -> "asdfka"
;3 -> "22222"
;4 -> "safa"
;5 -> ""
;6 = NULL

;char ** split (const char *str, char *substr);
split proc c string1:dword, _substr_:dword
	local i:dword
	local result:dword
	local subStrSize:dword
	local count:dword
	local cpySize:dword
	local tmp:dword
	local temp:dword
	local start:dword

	push [_substr_]
	call _strlen
	add esp, 4
	mov [subStrSize], eax

	mov [i], 0
	mov [count], 6
	mov ebx, [string1]
	mov [start], ebx
	invoke malloc, 250
	test eax, eax
	jz split_ret
	mov [result], eax

	.while [count] != 0
		dec [count]
		push [_substr_]
		push ebx
		call _strstr
		add esp, 8
		.if eax == [_substr_]
			jmp split_ret
		.elseif eax == 0
			push [start]
			call _strlen
			add esp, 4
			invoke malloc, eax
			test eax, eax
			jz split_ret
			mov [temp], eax

			jmp _split_copy	

		.else
			mov ebx, eax
			mov [tmp], ebx

			.if eax == [start]
				.if [i] == 0
					mov eax, [subStrSize]
					mov [cpySize], eax
				.else
					mov [temp], offset null_ 
					jmp _split_move
				.endif
			.else
				mov [cpySize], ebx
				mov eax, [start]
				sub [cpySize], eax
			.endif

			mov ebx, [tmp]

			invoke malloc, [cpySize]
			test eax, eax
			jz split_ret
			mov [temp], eax

			_split_copy:
			push [cpySize]
			push [start]
			push eax
			call strcpy
			add esp, 12

			_split_move:
			mov ecx, [i]
			mov eax, [result]
			mov ebx, [temp]
			mov dword ptr[ecx+eax], ebx

			add [i], 4
			mov ebx, [tmp] 
			add ebx, [subStrSize]
			mov [start], ebx
		.endif
	.endw

	split_ret:
	mov ecx, [i]
	mov eax, [result]
	mov ebx, [temp]
	mov dword ptr[ecx+eax], 0;offset null
	mov eax, [result]
	ret
split endp

Print1 proc c array:dword, count_:dword
	local i:dword
	local num:dword

	mov [i], 0
	mov [num], 0
	.while 1
        mov ecx, [i]
        mov ebx, [array]

        .break .if !dword ptr[ecx+ebx]
        
        invoke printf, offset format_num_val, [num], dword ptr[ecx + ebx]
		add [i], 4
        
        mov ecx, [i]
        mov ebx, [array]
		inc [num]
		mov eax, [count_]
	 ;[num] == eax
    .endw
	ret
Print1 endp

main proc c argc:DWORD, argv:DWORD, envp:DWORD
    local buf:dword

	;;split
	invoke split, offset string_, offset substr_

	mov [buf], eax

	invoke Print1, [buf], 7
	
main_ret:
	mov eax, 0
	ret

main endp


end
